import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/chat_message_entity.dart';

/// Styled message bubble bubble. Renders text or markdown for AI replies.
class MessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMarkdown;

  const MessageBubble({
    super.key,
    required this.message,
    this.isMarkdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMe = message.isSentByMe;

    final bubbleBg = isMe
        ? AppColors.primary
        : (isDark ? const Color(0xFF093D2C) : Colors.white);

    final bubbleText = isMe
        ? Colors.white
        : (isDark ? Colors.white70 : AppColors.textPrimary);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: context.screenWidth * 0.75),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: isMe
                    ? null
                    : Border.all(
                        color: isDark ? const Color(0xFF114C39) : AppColors.border,
                      ),
              ),
              child: isMarkdown
                  ? MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: bubbleText, height: 1.4, fontSize: 14),
                        strong: TextStyle(color: bubbleText, fontWeight: FontWeight.bold),
                        listBullet: TextStyle(color: bubbleText),
                      ),
                    )
                  : Text(
                      message.content,
                      style: TextStyle(
                        color: bubbleText,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                DateFormat('hh:mm a').format(message.timestamp),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
