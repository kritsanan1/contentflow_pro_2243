import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ActivityFeedCard extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final Function(Map<String, dynamic>) onActivityTap;

  const ActivityFeedCard({
    super.key,
    required this.activities,
    required this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return _EmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: activities.length,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Divider(
          color: AppTheme.borderSubtle,
          height: 1,
        ),
      ),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _ActivityItem(
          activity: activity,
          onTap: () => onActivityTap(activity),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.borderSubtle,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 48.sp,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Recent Activity',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your social media activity will appear here',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback onTap;

  const _ActivityItem({
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final metricType = activity['metric_type'] ?? 'unknown';
    final metricValue = activity['metric_value'] ?? 0;
    final createdAt = activity['created_at'];
    final platform = activity['connected_accounts']?['platform'] ?? '';
    final accountName =
        activity['connected_accounts']?['account_name'] ?? 'Unknown';

    final activityData = _getActivityData(metricType, metricValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Activity Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: activityData.color.withAlpha(26),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(
                activityData.icon,
                color: activityData.color,
                size: 20.sp,
              ),
            ),

            SizedBox(width: 16.w),

            // Activity Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityData.title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${activityData.description} on $accountName',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      // Platform Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: _getPlatformColor(platform).withAlpha(26),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          _formatPlatformName(platform),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: _getPlatformColor(platform),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Timestamp
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: AppTheme.textSecondary,
                      ),
                      SizedBox(width: 4.w),
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

            // Value Badge
            if (metricValue > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: activityData.color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _formatMetricValue(metricValue),
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: activityData.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _ActivityData _getActivityData(String metricType, int metricValue) {
    switch (metricType.toLowerCase()) {
      case 'followers':
      case 'follower_count':
        return _ActivityData(
          icon: Icons.person_add,
          color: AppTheme.accentPrimary,
          title: 'New Followers',
          description: '+$metricValue followers gained',
        );

      case 'likes':
      case 'like_count':
        return _ActivityData(
          icon: Icons.favorite,
          color: AppTheme.error,
          title: 'Post Engagement',
          description: '+$metricValue likes received',
        );

      case 'comments':
      case 'comment_count':
        return _ActivityData(
          icon: Icons.chat_bubble,
          color: AppTheme.accentPrimary,
          title: 'New Comments',
          description: '+$metricValue comments received',
        );

      case 'shares':
      case 'share_count':
        return _ActivityData(
          icon: Icons.share,
          color: AppTheme.success,
          title: 'Content Shared',
          description: '+$metricValue shares received',
        );

      case 'engagement_rate':
        return _ActivityData(
          icon: Icons.trending_up,
          color: AppTheme.warning,
          title: 'Engagement Update',
          description: '$metricValue% engagement rate',
        );

      case 'reach':
      case 'impressions':
        return _ActivityData(
          icon: Icons.visibility,
          color: AppTheme.success,
          title: 'Post Reach',
          description: '$metricValue impressions recorded',
        );

      default:
        return _ActivityData(
          icon: Icons.analytics,
          color: AppTheme.accentPrimary,
          title: 'Analytics Update',
          description: 'New metric: $metricValue',
        );
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
    if (createdAt == null) return 'Unknown';

    try {
      final time = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(time);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatMetricValue(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

class _ActivityData {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _ActivityData({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
}