import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/conversation_model.dart';
import '../services/message_service.dart';

class MessagesState {
  final bool isLoading;
  final List<Conversation> conversations;
  final int unreadCount;
  final String? errorMessage;

  const MessagesState({
    this.isLoading = false,
    this.conversations = const [],
    this.unreadCount = 0,
    this.errorMessage,
  });

  MessagesState copyWith({
    bool? isLoading,
    List<Conversation>? conversations,
    int? unreadCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessagesState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final messagesProvider = NotifierProvider<MessagesNotifier, MessagesState>(
  MessagesNotifier.new,
);

class MessagesNotifier extends Notifier<MessagesState> {
  final MessageService _service = MessageService();

  @override
  MessagesState build() {
    return const MessagesState();
  }

  Future<void> fetchConversations() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _service.getConversations();
      final data = response.data as Map<String, dynamic>;
      final rawList = (data['data'] as List?) ?? [];

      final conversations = rawList
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        isLoading: false,
        conversations: conversations,
        clearError: true,
      );

      // Fetch the real unread total separately — it's not derivable from
      // the conversation list alone since /unread counts messages, not
      // conversations with unread > 0.
      await fetchUnreadCount();
    } on DioException catch (e) {
      print('FETCH CONVERSATIONS ERROR: ${e.response?.data}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load conversations',
      );
    } catch (e) {
      print('FETCH CONVERSATIONS UNKNOWN ERROR: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await _service.getUnreadCount();
      final data = response.data as Map<String, dynamic>;
      final count = (data['data']?['unreadCount'] as num?)?.toInt() ?? 0;
      state = state.copyWith(unreadCount: count);
    } on DioException catch (e) {
      print('FETCH UNREAD MESSAGE COUNT ERROR: ${e.response?.data}');
    } catch (e) {
      print('FETCH UNREAD MESSAGE COUNT UNKNOWN ERROR: $e');
    }
  }
}