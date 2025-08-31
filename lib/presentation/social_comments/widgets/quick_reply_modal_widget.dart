import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/comment_service.dart';

class QuickReplyModalWidget extends StatefulWidget {
  final Map<String, dynamic> comment;
  final Function(String) onReply;

  const QuickReplyModalWidget({
    Key? key,
    required this.comment,
    required this.onReply,
  });

  @override
  State<QuickReplyModalWidget> createState() => _QuickReplyModalWidgetState();
}

class _QuickReplyModalWidgetState extends State<QuickReplyModalWidget> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();
  List<dynamic> _templates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
    // Auto focus when modal opens
    Future.delayed(const Duration(milliseconds: 300), () {
      _replyFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    try {
      final templates = await CommentService.getCommentTemplates();
      setState(() => _templates = templates);
    } catch (e) {
      // Silently handle error, templates are optional
    }
  }

  void _useTemplate(String templateContent) {
    setState(() {
      _replyController.text = templateContent;
    });
  }

  void _sendReply() {
    if (_replyController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a reply',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    widget.onReply(_replyController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Quick Reply',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1D29),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),

          // Original Comment
          Container(
            margin: EdgeInsets.all(4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12.sp,
                      backgroundImage:
                          widget.comment['commenter_avatar_url'] != null
                              ? CachedNetworkImageProvider(
                                  widget.comment['commenter_avatar_url'])
                              : null,
                      backgroundColor: Colors.grey[300],
                      child: widget.comment['commenter_avatar_url'] == null
                          ? Icon(Icons.person,
                              color: Colors.grey[600], size: 12.sp)
                          : null,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.comment['commenter_name'] ?? 'Unknown User',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1D29),
                            ),
                          ),
                          Text(
                            'Replying to this comment',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.comment['content'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: const Color(0xFF1A1D29),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Templates (if available)
          if (_templates.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Response Templates',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1D29),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              height: 10.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  final template = _templates[index];
                  return Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: _buildTemplateChip(template),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Reply Input
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Reply',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1D29),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _replyController,
                        focusNode: _replyFocusNode,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1D29),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Type your reply here...\n\nTip: Be professional, helpful, and on-brand with your response.',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: Colors.grey[500],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendReply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E3192),
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20.sp,
                            width: 20.sp,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send,
                                  size: 16.sp, color: Colors.white),
                              SizedBox(width: 2.w),
                              Text(
                                'Send Reply',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateChip(Map<String, dynamic> template) {
    return GestureDetector(
      onTap: () => _useTemplate(template['template_content'] ?? ''),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: const Color(0xFF2E3192).withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF2E3192).withAlpha(77),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app,
              size: 14.sp,
              color: const Color(0xFF2E3192),
            ),
            SizedBox(width: 1.w),
            Text(
              template['template_name'] ?? 'Template',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2E3192),
              ),
            ),
          ],
        ),
      ),
    );
  }
}