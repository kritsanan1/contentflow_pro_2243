import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MessageListItem extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onArchive;

  const MessageListItem({
    Key? key,
    required this.message,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = message['content'] ?? '';
    final senderName = message['sender_name'] ?? 'Unknown';
    final senderAvatar = message['sender_avatar'] ?? '';
    final platform = message['platform'] ?? '';
    final status = message['status'] ?? 'read';
    final createdAt = message['created_at'];
    final isUnread = status == 'unread';

    return Slidable(
      key: Key(message['id'] ?? ''),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (isUnread)
            SlidableAction(
              onPressed: (_) => onMarkAsRead(),
              backgroundColor: AppTheme.accentPrimary,
              foregroundColor: Colors.white,
              icon: Icons.mark_email_read,
              label: 'Mark Read',
            ),
          SlidableAction(
            onPressed: (_) => onArchive(),
            backgroundColor: AppTheme.warning,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isUnread
                ? AppTheme.accentPrimary.withAlpha(8)
                : AppTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isUnread
                  ? AppTheme.accentPrimary.withAlpha(51)
                  : AppTheme.borderSubtle,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender Avatar
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: _getPlatformColor(platform).withAlpha(26),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: _getPlatformColor(platform).withAlpha(77),
                    width: 2,
                  ),
                ),
                child: senderAvatar.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(22.0),
                        child: CachedNetworkImage(
                          imageUrl: senderAvatar,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            color: _getPlatformColor(platform),
                            size: 24.sp,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: _getPlatformColor(platform),
                        size: 24.sp,
                      ),
              ),

              SizedBox(width: 12.w),

              // Message Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender Info and Platform
                    Row(
                      children: [
                        Text(
                          senderName,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppTheme.textPrimary,
                            fontWeight:
                                isUnread ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),

                        // Platform Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _getPlatformColor(platform).withAlpha(26),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getPlatformIcon(platform),
                                size: 10.sp,
                                color: _getPlatformColor(platform),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                _formatPlatformName(platform),
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  color: _getPlatformColor(platform),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Timestamp
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

                    SizedBox(height: 6.h),

                    // Message Preview
                    Text(
                      content,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: isUnread
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontWeight:
                            isUnread ? FontWeight.w500 : FontWeight.w400,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8.h),

                    // Status and Actions
                    Row(
                      children: [
                        // Status Indicator
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withAlpha(26),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            _formatStatus(status),
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Quick Actions
                        if (isUnread) ...[
                          GestureDetector(
                            onTap: onMarkAsRead,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: AppTheme.accentPrimary.withAlpha(26),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Icon(
                                Icons.mark_email_read,
                                size: 14.sp,
                                color: AppTheme.accentPrimary,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],

                        // Priority Indicator (simulated)
                        if (_isPriorityMessage(content))
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.warning.withAlpha(26),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Icon(
                              Icons.priority_high,
                              size: 12.sp,
                              color: AppTheme.warning,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Unread Indicator
              if (isUnread)
                Container(
                  width: 8.w,
                  height: 8.h,
                  margin: EdgeInsets.only(top: 4.h, left: 8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
            ],
          ),
        ),
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
        return 'FB';
      case 'instagram':
        return 'IG';
      case 'twitter':
        return 'TW';
      case 'linkedin':
        return 'LI';
      case 'tiktok':
        return 'TT';
      case 'youtube':
        return 'YT';
      default:
        return platform.toUpperCase().substring(0, 2);
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'unread':
        return AppTheme.accentPrimary;
      case 'read':
        return AppTheme.textSecondary;
      case 'replied':
        return AppTheme.success;
      case 'archived':
        return AppTheme.warning;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'unread':
        return 'New';
      case 'read':
        return 'Read';
      case 'replied':
        return 'Replied';
      case 'archived':
        return 'Archived';
      default:
        return status.toUpperCase();
    }
  }

  bool _isPriorityMessage(String content) {
    // Simulate priority detection based on keywords
    final priorityKeywords = [
      'urgent',
      'important',
      'asap',
      'emergency',
      'complaint'
    ];
    return priorityKeywords
        .any((keyword) => content.toLowerCase().contains(keyword));
  }
}