import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/contact_tile.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final String? initialDoctorId;

  const ChatPage({super.key, this.initialDoctorId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatContactEntity? _selectedContact;
  bool _isMobileView = true;
  bool _showMobileChatBox = false;

  final List<String> _quickActions = [
    'How to upload an X-ray?',
    'How to book an appointment?',
    'What diseases do you diagnose?',
  ];

  @override
  void initState() {
    super.initState();
    // Load contacts initially
    context.read<ChatCubit>().fetchContacts();

    // Check if initial doctor was passed
    if (widget.initialDoctorId != null) {
      // Find the doctor and trigger selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectDoctorById(widget.initialDoctorId!);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectDoctorById(String docId) {
    final chatCubit = context.read<ChatCubit>();
    final found = chatCubit.contacts.firstWhere(
      (c) => c.id == docId,
      orElse: () => ChatContactEntity(id: docId, name: 'Doctor', type: 'doctor', online: false),
    );
    _onContactSelected(found);
  }

  void _onContactSelected(ChatContactEntity contact) {
    setState(() {
      _selectedContact = contact;
      _showMobileChatBox = true;
    });
    context.read<ChatCubit>().fetchChatHistory(contact.id);
    _scrollToBottom();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _selectedContact == null) return;

    context.read<ChatCubit>().sendMessage(
          receiverId: _selectedContact!.id,
          content: text,
        );
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSummaryDialog(String summary) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = context.isDark;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.stars, color: AppColors.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      context.isArabic ? 'ملخص ذكي بالذكاء الاصطناعي' : 'AI Intelligent Summary',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: MarkdownBody(
                      data: summary,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: isDark ? Colors.white70 : AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton(
                    label: context.translate('ok'),
                    onPressed: () => context.pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _isMobileView = context.screenWidth < 750;
    final isDark = context.isDark;

    final contactsListWidget = BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final contacts = context.read<ChatCubit>().contacts;
        if (state is ChatLoading && contacts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (contacts.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.chat_bubble_outline,
            title: context.translate('contacts'),
            subtitle: context.translate('noMessages'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final c = contacts[index];
            return ContactTile(
              contact: c,
              isActive: _selectedContact?.id == c.id,
              onTap: () => _onContactSelected(c),
            );
          },
        );
      },
    );

    final chatBoxWidget = _selectedContact == null
        ? Center(
            child: Text(
              context.isArabic ? 'اختر محادثة لبدء الدردشة' : 'Select a conversation to start chatting',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          )
        : Column(
            children: [
              // Chat Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF05281D) : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF093D2C) : AppColors.border,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (_isMobileView)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            _showMobileChatBox = false;
                            _selectedContact = null;
                          });
                        },
                      ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _selectedContact!.type == 'bot'
                              ? '🤖'
                              : (_selectedContact!.type == 'doctor' ? '👨‍⚕️' : '👤'),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedContact!.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedContact!.online
                                ? (context.isArabic ? 'متصل' : 'Online')
                                : (context.isArabic ? 'غير متصل' : 'Offline'),
                            style: TextStyle(
                              color: _selectedContact!.online ? AppColors.success : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Summarize Button for Peer Chats
                    if (_selectedContact!.type != 'bot')
                      BlocConsumer<ChatCubit, ChatState>(
                        listener: (context, state) {
                          if (state is ChatSummarySuccess) {
                            _showSummaryDialog(state.summary);
                          }
                        },
                        builder: (context, state) {
                          return TextButton.icon(
                            onPressed: () {
                              context.read<ChatCubit>().summarizeChat(_selectedContact!.id);
                            },
                            icon: const Icon(Icons.stars, size: 16),
                            label: Text(
                              context.isArabic ? 'ملخص الذكاء الاصطناعي' : 'AI Summary',
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              // Message Logs
              Expanded(
                child: Container(
                  color: isDark ? const Color(0xFF02140F) : const Color(0xFFF4FDF9),
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      final msgs = context.read<ChatCubit>().messages;

                      // Trigger scroll to bottom on message updates
                      _scrollToBottom();

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: msgs.length + (state is AiMessageStreaming ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < msgs.length) {
                            final m = msgs[index];
                            return MessageBubble(
                              message: m,
                              isMarkdown: _selectedContact!.type == 'bot',
                            );
                          } else {
                            // Render partial streaming AI response
                            final streamingText = (state as AiMessageStreaming).partialReply;
                            return MessageBubble(
                              message: ChatMessageEntity(
                                id: 'streaming',
                                senderId: 'bot',
                                content: streamingText.isEmpty ? 'Typing...' : streamingText,
                                timestamp: DateTime.now(),
                                isSentByMe: false,
                              ),
                              isMarkdown: true,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              // Quick Actions & Inputs Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF05281D) : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? const Color(0xFF093D2C) : AppColors.border,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedContact!.type == 'bot') ...[
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (context.isArabic
                              ? [
                                  'كيف يمكنني رفع أشعة سينية؟',
                                  'كيف يمكنني حجز موعد؟',
                                  'ما هي الأمراض التي يتم تشخيصها؟',
                                ]
                              : _quickActions).length,
                          itemBuilder: (context, index) {
                            final action = (context.isArabic
                                ? [
                                    'كيف يمكنني رفع أشعة سينية؟',
                                    'كيف يمكنني حجز موعد؟',
                                    'ما هي الأمراض التي يتم تشخيصها؟',
                                  ]
                                : _quickActions)[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ActionChip(
                                label: Text(
                                  action,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  _messageController.text = action;
                                  _sendMessage();
                                },
                                backgroundColor: isDark ? const Color(0xFF093D2C) : Colors.white,
                                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: context.translate('typeMessage'),
                              filled: true,
                              fillColor: isDark ? const Color(0xFF093D2C) : const Color(0xFFEBFDF5),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.pill,
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

    return Scaffold(
      body: _isMobileView
          ? (_showMobileChatBox ? chatBoxWidget : contactsListWidget)
          : Row(
              children: [
                // Sidebar Contacts
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: isDark ? const Color(0xFF093D2C) : AppColors.border,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Text(
                            context.translate('contacts'),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        Expanded(child: contactsListWidget),
                      ],
                    ),
                  ),
                ),
                // Chat Area
                Expanded(
                  flex: 5,
                  child: chatBoxWidget,
                ),
              ],
            ),
    );
  }
}
