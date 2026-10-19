import 'package:flutter/material.dart';

import '../../models/chat_message_model.dart';
import '../../services/socket_service.dart';
import '../../services/message_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ChatScreen extends StatefulWidget {
  final String bookingId;
  final String otherPartyName;
  final String otherPartyPhoto;

  const ChatScreen({
    super.key,
    required this.bookingId,
    required this.otherPartyName,
    required this.otherPartyPhoto,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketService _socketService = SocketService();
  final MessageService _messageService = MessageService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  List<String> _quickReplies = [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _otherUserTyping = false;
  String? _errorMessage;

  // Not persisted anywhere — this device's own userId isn't available
  // here since ChatScreen is deliberately a plain StatefulWidget (no
  // Riverpod ref). Messages are told apart by comparing sender.name to
  // widget.otherPartyName instead: anything NOT from the other party is
  // treated as "mine". This works because a booking chat only ever has
  // two participants.
  bool _isMine(ChatMessage m) => m.sender.name != widget.otherPartyName;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    try {
      await _socketService.connect();
      final history = await _socketService.joinChat(widget.bookingId);

      if (!mounted) return;
      setState(() {
        _messages = history;
        _isLoading = false;
      });

      _socketService.onReceiveMessage((message) {
        if (!mounted) return;
        setState(() => _messages = [..._messages, message]);
        _scrollToBottom();

        if (!_isMine(message)) {
          _socketService.markMessagesRead(widget.bookingId);
          _refreshQuickReplies(message.text);
        }
      });

      _socketService.onUserTyping((_) {
        if (!mounted) return;
        setState(() => _otherUserTyping = true);
      });

      _socketService.onUserStopTyping((_) {
        if (!mounted) return;
        setState(() => _otherUserTyping = false);
      });

      // Seed quick replies from the last incoming message, if any.
      final lastIncoming = _messages.lastWhere(
        (m) => !_isMine(m),
        orElse: () => ChatMessage(
          id: '',
          bookingId: widget.bookingId,
          sender: ChatMessageSender(id: '', name: '', photo: ''),
          text: '',
          readBy: const [],
          createdAt: DateTime.now(),
        ),
      );
      if (lastIncoming.text.isNotEmpty) {
        _refreshQuickReplies(lastIncoming.text);
      }

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load conversation: $e';
      });
    }
  }

  Future<void> _refreshQuickReplies(String lastIncomingText) async {
    try {
      final response = await _messageService.getQuickReplies(lastIncomingText);
      final data = response.data as Map<String, dynamic>;
      final replies = ((data['data']?['replies'] as List?) ?? [])
          .map((e) => e.toString())
          .toList();
      if (!mounted) return;
      setState(() => _quickReplies = replies);
    } catch (_) {
      // Quick replies are a nice-to-have — fail silently rather than
      // interrupting the chat experience.
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send([String? textOverride]) async {
    final text = (textOverride ?? _textController.text).trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _quickReplies = [];
    });
    _textController.clear();
    _socketService.sendStopTyping(widget.bookingId);

    try {
      await _socketService.sendMessage(widget.bookingId, text);
      // The message will arrive back via onReceiveMessage (server
      // broadcasts to everyone in the room, including the sender), so we
      // don't append it locally here to avoid a duplicate.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not send: $e')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _socketService.offChatListeners();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.split(RegExp(r'\s+')).map((e) => e[0]).take(2).join().toUpperCase();
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        foregroundColor: AppColors.textPrimary,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryNavy,
              backgroundImage: widget.otherPartyPhoto.isNotEmpty
                  ? NetworkImage(widget.otherPartyPhoto)
                  : null,
              child: widget.otherPartyPhoto.isEmpty
                  ? Text(
                      _initials(widget.otherPartyName),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherPartyName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_otherUserTyping)
                    const Text(
                      'typing...',
                      style: TextStyle(fontSize: 11, color: AppColors.accentBlue),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_errorMessage!, textAlign: TextAlign.center),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: _messages.isEmpty
                            ? Center(
                                child: Text(
                                  'Say hello to ${widget.otherPartyName}!',
                                  style: AppTextStyles.bodySmall,
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: _messages.length,
                                itemBuilder: (context, i) =>
                                    _messageBubble(_messages[i]),
                              ),
                      ),
                      if (_quickReplies.isNotEmpty) _buildQuickReplies(),
                      _buildInputBar(),
                    ],
                  ),
      ),
    );
  }

  Widget _messageBubble(ChatMessage message) {
    final mine = _isMine(message);

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: mine ? AppColors.primaryNavy : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 13.5,
                color: mine ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                fontSize: 9.5,
                color: mine ? Colors.white70 : AppColors.hintText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickReplies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final reply = _quickReplies[i];
          return ActionChip(
            label: Text(reply, style: const TextStyle(fontSize: 12)),
            backgroundColor: AppColors.verifiedPillBg,
            labelStyle: const TextStyle(color: AppColors.primaryNavy),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
            onPressed: () => _send(reply),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 4,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _socketService.sendTyping(widget.bookingId);
                } else {
                  _socketService.sendStopTyping(widget.bookingId);
                }
              },
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTextStyles.hint,
                filled: true,
                fillColor: AppColors.lightInputBg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isSending ? null : () => _send(),
            icon: _isSending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded, color: AppColors.primaryNavy),
          ),
        ],
      ),
    );
  }
}