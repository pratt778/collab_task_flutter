import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_task/core/error/failure_messages.dart';
import 'package:collab_task/features/chat/domain/entities/chat_message_entity.dart';
import 'package:collab_task/features/chat/presentation/cubit/task_chat_cubit.dart';
import 'package:collab_task/features/chat/presentation/cubit/task_chat_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMessageWidget extends StatefulWidget {
  final String taskId;

  const ChatMessageWidget({super.key, required this.taskId});

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    context.read<TaskChatCubit>().sendMessage(message);
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

  Widget _buildThread(
    BuildContext context,
    List<ChatMessageEntity> messages, {
    String? bannerMessage,
    bool isSubmitting = false,
  }) {
    return Column(
      children: [
        if (bannerMessage != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            color: Colors.amber.withValues(alpha: 0.12),
            child: Text(
              bannerMessage,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.brown.shade700,
              ),
            ),
          ),
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Text(
                      'No messages yet. Start the discussion below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
        ),
        _buildInput(isSubmitting: isSubmitting),
      ],
    );
  }

  Widget _buildInput({required bool isSubmitting}) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (!isSubmitting) {
                    _sendMessage();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                style: TextStyle(fontSize: 13.sp),
                maxLines: 3,
                minLines: 1,
                enabled: !isSubmitting,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: isSubmitting ? null : _sendMessage,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isSubmitting ? Colors.blueGrey : Colors.blue,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(Icons.send, size: 16.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageEntity msg) {
    final isOwn = msg.authorId == _currentUserId;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Align(
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isOwn
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isOwn)
              Padding(
                padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
                child: Text(
                  msg.authorName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: 280.w),
              decoration: BoxDecoration(
                color: isOwn ? Colors.blue : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isOwn ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.h, left: 8.w, right: 8.w),
              child: Text(
                _formatTimestamp(msg.createdAt),
                style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final hours = timestamp.hour.toString().padLeft(2, '0');
    final minutes = timestamp.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskChatCubit, TaskChatState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (messages) {
            if (_isSending) {
              _messageController.clear();
              _isSending = false;
            }
            _scrollToBottom();
          },
          submitting: (_) => _scrollToBottom(),
          error: (failure, messages) {
            final wasSending = _isSending;
            _isSending = false;
            if (wasSending && messages.isNotEmpty) {
              _scrollToBottom();
            }
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (messages) => _buildThread(context, messages),
          submitting: (messages) =>
              _buildThread(context, messages, isSubmitting: true),
          error: (failure, messages) {
            if (messages.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                        size: 40.r,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        localizedFailureMessage(context, failure),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FilledButton.icon(
                        onPressed: () => context
                            .read<TaskChatCubit>()
                            .loadTaskMessages(widget.taskId),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return _buildThread(
              context,
              messages,
              bannerMessage: localizedFailureMessage(context, failure),
            );
          },
        );
      },
    );
  }
}
