import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScheduledPostCardWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isDragging;

  const ScheduledPostCardWidget({
    Key? key,
    required this.post,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onDelete,
    this.isSelected = false,
    this.isDragging = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        // Trigger drag mode
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isDragging
              ? AppTheme.accentPrimary.withValues(alpha: 0.3)
              : isSelected
                  ? AppTheme.accentPrimary.withValues(alpha: 0.1)
                  : AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppTheme.accentPrimary : AppTheme.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          _buildPlatformIcons(),
          const Spacer(),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildPlatformIcons() {
    final platforms = (post['platforms'] as List<String>?) ?? [];
    return Row(
      children: platforms.take(3).map((platform) {
        return Container(
          margin: EdgeInsets.only(right: 1.w),
          child: _getPlatformIcon(platform),
        );
      }).toList(),
    );
  }

  Widget _getPlatformIcon(String platform) {
    String iconName;
    Color iconColor;

    switch (platform.toLowerCase()) {
      case 'facebook':
        iconName = 'facebook';
        iconColor = const Color(0xFF1877F2);
        break;
      case 'instagram':
        iconName = 'camera_alt';
        iconColor = const Color(0xFFE4405F);
        break;
      case 'twitter':
        iconName = 'alternate_email';
        iconColor = const Color(0xFF1DA1F2);
        break;
      case 'linkedin':
        iconName = 'business';
        iconColor = const Color(0xFF0A66C2);
        break;
      default:
        iconName = 'share';
        iconColor = AppTheme.textSecondary;
    }

    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: iconColor,
        size: 16,
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = post['status'] as String? ?? 'scheduled';
    Color badgeColor;
    String statusText;

    switch (status) {
      case 'published':
        badgeColor = AppTheme.success;
        statusText = 'เผยแพร่แล้ว';
        break;
      case 'failed':
        badgeColor = AppTheme.error;
        statusText = 'ล้มเหลว';
        break;
      case 'pending':
        badgeColor = AppTheme.warning;
        statusText = 'รอดำเนินการ';
        break;
      default:
        badgeColor = AppTheme.accentPrimary;
        statusText = 'กำหนดการ';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Text(
        statusText,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post['image'] != null) _buildImagePreview(),
          SizedBox(height: 1.h),
          _buildTextContent(),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 15.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppTheme.primaryBackground,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CustomImageWidget(
          imageUrl: post['image'] as String,
          width: double.infinity,
          height: 15.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    final content = post['content'] as String? ?? '';
    return Text(
      content,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.textPrimary,
        height: 1.4,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'schedule',
            color: AppTheme.textSecondary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            _formatScheduledTime(),
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          if (post['engagement'] != null) _buildEngagementStats(),
        ],
      ),
    );
  }

  Widget _buildEngagementStats() {
    final engagement = post['engagement'] as Map<String, dynamic>;
    final likes = engagement['likes'] as int? ?? 0;
    final comments = engagement['comments'] as int? ?? 0;

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'favorite',
          color: AppTheme.textSecondary,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          likes.toString(),
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(width: 2.w),
        CustomIconWidget(
          iconName: 'comment',
          color: AppTheme.textSecondary,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          comments.toString(),
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatScheduledTime() {
    final scheduledTime = post['scheduledTime'] as DateTime?;
    if (scheduledTime == null) return '';

    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} วันข้างหน้า';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ชั่วโมงข้างหน้า';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} นาทีข้างหน้า';
    } else if (difference.inSeconds > 0) {
      return 'ในไม่กี่วินาที';
    } else {
      return 'เลยเวลาแล้ว';
    }
  }
}
