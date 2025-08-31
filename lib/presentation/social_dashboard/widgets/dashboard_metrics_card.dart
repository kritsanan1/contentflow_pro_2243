import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DashboardMetricsCard extends StatelessWidget {
  final Map<String, dynamic> metrics;
  final bool isRefreshing;

  const DashboardMetricsCard({
    super.key,
    required this.metrics,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.getElevationShadow(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.dashboard,
                color: AppTheme.accentPrimary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Today\'s Overview',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isRefreshing)
                SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.accentPrimary,
                  ),
                ),
            ],
          ),

          SizedBox(height: 20.h),

          // Metrics Grid
          Row(
            children: [
              // Posts Published
              Expanded(
                child: _MetricItem(
                  icon: Icons.post_add,
                  label: 'Posts Published',
                  value: '${metrics['posts_published'] ?? 0}',
                  trend: '+${metrics['posts_published'] ?? 0}',
                  trendColor: AppTheme.success,
                  backgroundColor: AppTheme.success.withAlpha(26),
                ),
              ),

              SizedBox(width: 12.w),

              // Engagement Rate
              Expanded(
                child: _MetricItem(
                  icon: Icons.trending_up,
                  label: 'Engagement Rate',
                  value:
                      '${(metrics['engagement_rate'] ?? 0.0).toStringAsFixed(1)}%',
                  trend:
                      '+${(metrics['engagement_rate'] ?? 0.0).toStringAsFixed(1)}%',
                  trendColor: AppTheme.accentPrimary,
                  backgroundColor: AppTheme.accentPrimary.withAlpha(26),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              // Follower Growth
              Expanded(
                child: _MetricItem(
                  icon: Icons.people,
                  label: 'Total Followers',
                  value: _formatNumber(metrics['total_followers'] ?? 0),
                  trend: '+${metrics['follower_growth'] ?? 0}',
                  trendColor: AppTheme.warning,
                  backgroundColor: AppTheme.warning.withAlpha(26),
                ),
              ),

              SizedBox(width: 12.w),

              // Reach
              Expanded(
                child: _MetricItem(
                  icon: Icons.visibility,
                  label: 'Today\'s Reach',
                  value: _formatNumber((metrics['total_followers'] ?? 0) *
                      0.1), // Estimated reach
                  trend: '+${(metrics['total_followers'] ?? 0) * 0.05}',
                  trendColor: AppTheme.success,
                  backgroundColor: AppTheme.success.withAlpha(26),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(dynamic number) {
    final num = (number is int)
        ? number
        : (number is double)
            ? number.round()
            : 0;
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toString();
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final Color trendColor;
  final Color backgroundColor;

  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: trendColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: trendColor,
                  size: 16.sp,
                ),
              ),
              const Spacer(),
              Text(
                trend,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: trendColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}