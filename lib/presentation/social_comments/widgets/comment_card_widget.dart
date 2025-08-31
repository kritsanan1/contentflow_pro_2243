import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class CommentCardWidget extends StatelessWidget {
  final Map<String, dynamic> comment;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onReply;
  final Function(String) onModerate;

  const CommentCardWidget({
    Key? key,
    required this.comment,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onReply,
    required this.onModerate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sentiment = comment['sentiment'] ?? 'neutral';
    final moderationStatus = comment['moderation_status'] ?? 'pending';
    final platform = comment['platform'] ?? '';
    final isReplied = comment['is_replied'] ?? false;
    final createdAt =
        DateTime.tryParse(comment['created_at'] ?? '') ?? DateTime.now();

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: const Color(0xFF2E3192), width: 2)
            : Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: isSelectionMode ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Selection Checkbox
                  if (isSelectionMode)
                    Container(
                      margin: EdgeInsets.only(right: 3.w),
                      child: Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? const Color(0xFF2E3192)
                            : Colors.grey[400],
                        size: 20.sp,
                      ),
                    ),

                  // Commenter Avatar
                  CircleAvatar(
                    radius: 16.sp,
                    backgroundImage: comment['commenter_avatar_url'] != null
                        ? CachedNetworkImageProvider(
                            comment['commenter_avatar_url'])
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: comment['commenter_avatar_url'] == null
                        ? Icon(Icons.person,
                            color: Colors.grey[600], size: 16.sp)
                        : null,
                  ),

                  SizedBox(width: 3.w),

                  // Commenter Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                comment['commenter_name'] ?? 'Unknown User',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1D29),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildPlatformIcon(platform),
                          ],
                        ),
                        Text(
                          timeago.format(createdAt),
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sentiment Indicator
                  _buildSentimentIndicator(sentiment),
                ],
              ),

              SizedBox(height: 2.h),

              // Comment Content
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  comment['content'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF1A1D29),
                    height: 1.4,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Engagement Stats
              Row(
                children: [
                  Icon(Icons.favorite_border,
                      size: 16.sp, color: Colors.grey[600]),
                  SizedBox(width: 1.w),
                  Text(
                    '${comment['likes_count'] ?? 0}',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.trending_up, size: 16.sp, color: Colors.grey[600]),
                  SizedBox(width: 1.w),
                  Text(
                    '${comment['engagement_count'] ?? 0}',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  _buildModerationStatus(moderationStatus),
                ],
              ),

              // Reply Section (if replied)
              if (isReplied && comment['reply_content'] != null)
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192).withAlpha(13),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF2E3192).withAlpha(51),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.reply,
                            size: 16.sp,
                            color: const Color(0xFF2E3192),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Your Reply',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E3192),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        comment['reply_content'],
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF1A1D29),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 2.h),

              // Action Buttons
              if (!isSelectionMode)
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Reply',
                        Icons.reply,
                        const Color(0xFF2E3192),
                        onReply,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildActionButton(
                        'Approve',
                        Icons.check,
                        Colors.green,
                        () => onModerate('approved'),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildActionButton(
                        'Hide',
                        Icons.visibility_off,
                        Colors.orange,
                        () => onModerate('hidden'),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildActionButton(
                        'Delete',
                        Icons.delete_outline,
                        Colors.red,
                        () => _showDeleteConfirmation(context),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(String platform) {
    IconData iconData;
    Color iconColor;

    switch (platform.toLowerCase()) {
      case 'facebook':
        iconData = Icons.facebook;
        iconColor = const Color(0xFF1877F2);
        break;
      case 'instagram':
        iconData = Icons.camera_alt;
        iconColor = const Color(0xFFE4405F);
        break;
      case 'twitter':
        iconData = Icons.chat_bubble_outline;
        iconColor = const Color(0xFF1DA1F2);
        break;
      case 'linkedin':
        iconData = Icons.business;
        iconColor = const Color(0xFF0A66C2);
        break;
      case 'tiktok':
        iconData = Icons.music_note;
        iconColor = Colors.black;
        break;
      case 'youtube':
        iconData = Icons.play_circle_outline;
        iconColor = const Color(0xFFFF0000);
        break;
      default:
        iconData = Icons.public;
        iconColor = Colors.grey[600]!;
    }

    return Container(
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        color: iconColor.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        iconData,
        size: 14.sp,
        color: iconColor,
      ),
    );
  }

  Widget _buildSentimentIndicator(String sentiment) {
    Color color;
    IconData icon;

    switch (sentiment.toLowerCase()) {
      case 'positive':
        color = Colors.green;
        icon = Icons.sentiment_satisfied;
        break;
      case 'negative':
        color = Colors.red;
        icon = Icons.sentiment_dissatisfied;
        break;
      case 'spam':
        color = Colors.orange;
        icon = Icons.report;
        break;
      default:
        color = Colors.grey[600]!;
        icon = Icons.sentiment_neutral;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 1.w),
          Text(
            sentiment.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationStatus(String status) {
    Color color;
    String displayText;

    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        displayText = 'APPROVED';
        break;
      case 'hidden':
        color = Colors.orange;
        displayText = 'HIDDEN';
        break;
      case 'deleted':
        color = Colors.red;
        displayText = 'DELETED';
        break;
      case 'flagged':
        color = Colors.purple;
        displayText = 'FLAGGED';
        break;
      default:
        color = Colors.grey[600]!;
        displayText = 'PENDING';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Text(
        displayText,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(26),
        foregroundColor: color,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withAlpha(77)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14.sp),
          SizedBox(width: 1.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Comment',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to delete this comment? This action cannot be undone.',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onModerate('deleted');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(
                'Delete',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}