import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageWidget extends StatefulWidget {
  final String taskId;

  const ChatMessageWidget({super.key, required this.taskId});

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // Mock messages
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'author': 'Alice Johnson',
      'avatar': '👩‍💻',
      'message': 'Started working on the UI mockups',
      'timestamp': '10:30 AM',
      'isOwn': false,
    },
    {
      'id': '2',
      'author': 'You',
      'avatar': '👨‍💻',
      'message': 'Great! Can you share the Figma link?',
      'timestamp': '10:35 AM',
      'isOwn': true,
    },
    {
      'id': '3',
      'author': 'Alice Johnson',
      'avatar': '👩‍💻',
      'message': 'Sure, sent it in the workspace channel',
      'timestamp': '10:40 AM',
      'isOwn': false,
    },
    {
      'id': '4',
      'author': 'Bob Smith',
      'avatar': '👨‍🔧',
      'message': '@Alice Should we use Material 3 or custom design?',
      'timestamp': '11:00 AM',
      'isOwn': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().toString(),
        'author': 'You',
        'avatar': '👨‍💻',
        'message': _messageController.text,
        'timestamp': 'now',
        'isOwn': true,
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Discussion',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '3 participants',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.info_outline, size: 20.sp, color: Colors.grey),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Message Input
          Container(
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
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
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Icon(
                            Icons.emoji_emotions_outlined,
                            size: 20.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(Icons.send, size: 16.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isOwn = msg['isOwn'] as bool;

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
                  msg['author'] as String,
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
                msg['message'] as String,
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
                msg['timestamp'] as String,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
