import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_client;
import '../core/constants/api_constants.dart';
import '../models/chat_message_model.dart';

/// Wraps the raw socket.io client, matching every event name/payload shape
/// in socketHandler.js exactly. One socket connection is shared across the
/// whole app (singleton) since the server also uses it for real-time
/// notification pushes via the user's personal room â€” ChatScreen only
/// joins/leaves a specific chat ROOM on top of that shared connection,
/// it doesn't own the connection lifecycle itself.
class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  io_client.Socket? _socket;
  final _storage = const FlutterSecureStorage();

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (isConnected) return;

    final token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('No access token found â€” cannot connect socket');
    }

    _socket = io_client.io(
      ApiConstants.socketUrl,
      io_client.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    // Wait for the connection to actually establish before returning,
    // so callers can safely emit right after connect() resolves.
    final completer = Future<void>(() async {
      var attempts = 0;
      while (!isConnected && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }
    });
    await completer;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  // ── join_chat ────────────────────────────────────────────
  // Server responds via ack callback: { success, messages: [...] } or
  // { success: false, error }. Also marks messages read server-side.
  Future<List<ChatMessage>> joinChat(String bookingId) async {
    if (!isConnected) await connect();

    final c = Completer<List<ChatMessage>>();
    _socket!.emitWithAck(
      'join_chat',
      {'bookingId': bookingId},
      ack: (response) {
        if (response is Map && response['success'] == true) {
          final rawMessages = (response['messages'] as List?) ?? [];
          final messages = rawMessages
              .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
              .toList();
          c.complete(messages);
        } else {
          c.completeError(
            Exception(response is Map ? response['error'] : 'join_chat failed'),
          );
        }
      },
    );
    return c.future;
  }

  void leaveChatRoom() {
    // socket.io-client for Dart doesn't expose an explicit leave() call
    // from the client side in the same way the server does; the server's
    // "disconnecting" handler only cleans up the personal user room, not
    // per-chat rooms, and those are harmless to remain subscribed to
    // until the whole socket disconnects. If you want explicit leave
    // semantics, add a matching "leave_chat" handler server-side.
  }

  // ── send_message ─────────────────────────────────────────
  Future<void> sendMessage(String bookingId, String text) async {
    if (!isConnected) await connect();

    final c = Completer<void>();
    _socket!.emitWithAck(
      'send_message',
      {'bookingId': bookingId, 'text': text},
      ack: (response) {
        if (response is Map && response['success'] == true) {
          c.complete();
        } else {
          c.completeError(
            Exception(response is Map ? response['error'] : 'send_message failed'),
          );
        }
      },
    );
    return c.future;
  }

  void sendTyping(String bookingId) {
    _socket?.emit('typing', {'bookingId': bookingId});
  }

  void sendStopTyping(String bookingId) {
    _socket?.emit('stop_typing', {'bookingId': bookingId});
  }

  void markMessagesRead(String bookingId) {
    _socket?.emit('mark_messages_read', {'bookingId': bookingId});
  }

  // ── Listeners ────────────────────────────────────────────
  void onReceiveMessage(void Function(ChatMessage message) callback) {
    _socket?.on('receive_message', (data) {
      callback(ChatMessage.fromJson(data as Map<String, dynamic>));
    });
  }

  void onUserTyping(void Function(String userId) callback) {
    _socket?.on('user_typing', (data) {
      callback((data as Map)['userId'].toString());
    });
  }

  void onUserStopTyping(void Function(String userId) callback) {
    _socket?.on('user_stop_typing', (data) {
      callback((data as Map)['userId'].toString());
    });
  }

  void onMessagesRead(void Function(String bookingId, String readBy) callback) {
    _socket?.on('messages_read', (data) {
      final map = data as Map;
      callback(map['bookingId'].toString(), map['readBy'].toString());
    });
  }

  // Removes all listeners registered above for this screen instance.
  // Call in dispose() to avoid duplicate handlers stacking up if the
  // user opens the same chat screen multiple times.
  void offChatListeners() {
    _socket?.off('receive_message');
    _socket?.off('user_typing');
    _socket?.off('user_stop_typing');
    _socket?.off('messages_read');
  }
}