import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ConversationView extends StatefulWidget {
  final Map<String, dynamic> message;
  final Function(String) onSendReply;
  final VoidCallback onClose;

  const ConversationView({
    super.key,
    required this.message,
    required this.onSendReply,
    required this.onClose,
  });

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendReply() async {
    final replyText = _replyController.text.trim();
    if (replyText.isEmpty) return;

    setState(() => _isSending = true);

    try {
      await widget.onSendReply(replyText);
      _replyController.clear();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to send reply",
        backgroundColor: AppTheme.error,
        textColor: AppTheme.textPrimary,
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final senderName = widget.message['sender_name'] ?? 'Unknown';
    final senderAvatar = widget.message['sender_avatar'] ?? '';
    final content = widget.message['content'] ?? '';
    final platform = widget.message['platform'] ?? '';
    final createdAt = widget.message['created_at'];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Sender Avatar
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: _getPlatformColor(platform).withAlpha(26),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _getPlatformColor(platform).withAlpha(77),
                      width: 2,
                    ),
                  ),
                  child: senderAvatar.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18.r),
                          child: CachedNetworkImage(
                            imageUrl: senderAvatar,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              color: _getPlatformColor(platform),
                              size: 20.sp,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: _getPlatformColor(platform),
                          size: 20.sp,
                        ),
                ),

                SizedBox(width: 12.w),

                // Sender Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        senderName,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            _getPlatformIcon(platform),
                            size: 12.sp,
                            color: _getPlatformColor(platform),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatPlatformName(platform),
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _formatTimestamp(createdAt),
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Close Button
                IconButton(
                  onPressed: widget.onClose,
                  icon: Icon(
                    Icons.close,
                    color: AppTheme.textSecondary,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),

          // Conversation Messages
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Message
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryBackground,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppTheme.borderSubtle,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Example previous replies (in real app, load from thread_id)
                  _buildPreviousReplies(),
                ],
              ),
            ),
          ),

          // Reply Input
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // AI Suggestions (optional)
                _buildAISuggestions(),

                SizedBox(height: 12.h),

                // Reply Input Field
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBackground,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppTheme.borderSubtle,
                          ),
                        ),
                        child: TextField(
                          controller: _replyController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: 'Type your reply...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppTheme.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.w),
                          ),
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Send Button
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppTheme.accentPrimary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        onPressed: _isSending ? null : _sendReply,
                        icon: _isSending
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousReplies() {
    // In a real app, this would load actual conversation history
    return Column(
      children: [
        Text(
          'Previous replies would appear here',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildAISuggestions() {
    final suggestions = [
      'Thank you for your message!',
      'I\'ll look into this for you.',
      'Thanks for reaching out.',
    ];

    return Container(
      height: 32.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return GestureDetector(
            onTap: () {
              _replyController.text = suggestion;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppTheme.accentPrimary.withAlpha(26),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppTheme.accentPrimary.withAlpha(77),
                ),
              ),
              child: Text(
                suggestion,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppTheme.accentPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
        return Icons.alternate_email;
      case 'linkedin':
        return Icons.business;
      case 'tiktok':
        return Icons.music_video;
      case 'youtube':
        return Icons.video_library;
      default:
        return Icons.share;
    }
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return AppTheme.accentPrimary;
    }
  }

  String _formatPlatformName(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return 'Facebook';
      case 'instagram':
        return 'Instagram';
      case 'twitter':
        return 'Twitter';
      case 'linkedin':
        return 'LinkedIn';
      case 'tiktok':
        return 'TikTok';
      case 'youtube':
        return 'YouTube';
      default:
        return platform.toUpperCase();
    }
  }

  String _formatTimestamp(String? createdAt) {
    if (createdAt == null) return '';

    try {
      final messageTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(messageTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Now';
      }
    } catch (e) {
      return '';
    }
  }
}