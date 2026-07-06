import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../chat/domain/use_cases/get_chat_history_use_case.dart';

class FloatingDoctorBot extends StatefulWidget {
  const FloatingDoctorBot({super.key});

  @override
  State<FloatingDoctorBot> createState() => _FloatingDoctorBotState();
}

class _FloatingDoctorBotState extends State<FloatingDoctorBot> {
  bool _isOpen = false;
  bool _isLoading = false;
  final List<_BotMsg> _messages = [];
  final List<Map<String, String>> _rawHistory = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Pre-populate with initial greeting
    _messages.add(const _BotMsg(
      isDoctor: false,
      text: 'Hello! I am your Smart Care 360 Assistant. How can I help you today?',
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(_BotMsg(isDoctor: true, text: text));
      _isLoading = true;
    });
    _scrollToBottom();

    final sendAiMessage = sl<SendAiMessageUseCase>();
    final lang = context.isArabic ? 'ar' : 'en';

    final result = await sendAiMessage(
      message: text,
      history: _rawHistory,
      userRole: 'doctor',
      lang: lang,
    );

    result.fold(
      (failure) {
        setState(() {
          _messages.add(_BotMsg(
            isDoctor: false,
            text: context.isArabic
                ? 'فشل الاتصال بخادم الذكاء الاصطناعي.'
                : 'Failed to connect to the AI server.',
            isError: true,
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      },
      (reply) {
        setState(() {
          _messages.add(_BotMsg(isDoctor: false, text: reply));
          _rawHistory.add({'role': 'user', 'text': text});
          _rawHistory.add({'role': 'model', 'text': reply});
          if (_rawHistory.length > 8) {
            _rawHistory.removeRange(0, 2);
          }
          _isLoading = false;
        });
        _scrollToBottom();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_isOpen) _buildChatWindow(context, isDark),
        _buildFab(context),
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        onPressed: () => setState(() => _isOpen = !_isOpen),
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: const CircleBorder(),
        child: Icon(
          _isOpen ? Icons.close_rounded : Icons.smart_toy_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildChatWindow(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF071F17) : Colors.white;
    final borderColor = isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.only(bottom: 84, right: 16),
      width: 360,
      height: 480,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.isArabic ? 'المساعد الطبي الذكي' : 'Medical AI Assistant',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        context.isArabic ? 'متاح للاقتراحات والبروتوكولات' : 'Available for protocols & suggestions',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _isOpen = false),
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // Chat Viewport
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final m = _messages[idx];
                return _buildMessageBubble(context, isDark, m);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
              ),
            ),
          // Footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: context.isArabic ? 'اكتب رسالتك...' : 'Type your message...',
                      hintStyle: const TextStyle(fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppColors.textPrimary),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, bool isDark, _BotMsg m) {
    final isMe = m.isDoctor;
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleBg = isMe
        ? AppColors.primary
        : (isDark ? const Color(0xFF093D2C) : const Color(0xFFF1F5F9));
    final textStyle = TextStyle(
      fontSize: 13,
      color: isMe
          ? Colors.white
          : (m.isError
              ? Colors.red
              : (isDark ? Colors.white70 : AppColors.textPrimary)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        constraints: BoxConstraints(maxWidth: context.screenWidth * 0.6),
        child: isMe
            ? Text(m.text, style: textStyle)
            : MarkdownBody(
                data: m.text,
                styleSheet: MarkdownStyleSheet(
                  p: textStyle,
                  strong: textStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}

class _BotMsg {
  final bool isDoctor;
  final String text;
  final bool isError;

  const _BotMsg({
    required this.isDoctor,
    required this.text,
    this.isError = false,
  });
}
