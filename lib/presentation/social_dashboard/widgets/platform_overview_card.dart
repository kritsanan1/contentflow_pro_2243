import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';

class PlatformOverviewCard extends StatelessWidget {
  final List<Map<String, dynamic>> connectedAccounts;
  final Function(Map<String, dynamic>) onAccountTap;

  const PlatformOverviewCard({
    super.key,
    required this.connectedAccounts,
    required this.onAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    if (connectedAccounts.isEmpty) {
      return _EmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: connectedAccounts.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final account = connectedAccounts[index];
        return _PlatformAccountCard(
          account: account,
          onTap: () => onAccountTap(account),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off,
            size: 48.sp,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Connected Accounts',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Connect your social media accounts to start managing your content',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.connectSocials);
            },
            icon: Icon(Icons.add_link, size: 20.sp),
            label: Text('Connect Account'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformAccountCard extends StatelessWidget {
  final Map<String, dynamic> account;
  final VoidCallback onTap;

  const _PlatformAccountCard({
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final platform = account['platform'] ?? '';
    final accountName = account['account_name'] ?? 'Unknown';
    final followerCount = account['follower_count'] ?? 0;
    final status = account['status'] ?? 'disconnected';
    final lastSync = account['last_sync_at'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            // Platform Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: _getPlatformColor(platform).withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getPlatformIcon(platform),
                color: _getPlatformColor(platform),
                size: 24.sp,
              ),
            ),

            SizedBox(width: 16.w),

            // Account Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _formatPlatformName(platform),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _StatusIndicator(status: status),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    accountName,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16.sp,
                        color: AppTheme.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatNumber(followerCount),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (lastSync != null) ...[
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.sync,
                          size: 16.sp,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _formatLastSync(lastSync),
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Action Button
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
              size: 24.sp,
            ),
          ],
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

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M followers';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K followers';
    }
    return '$number followers';
  }

  String _formatLastSync(String lastSync) {
    try {
      final syncTime = DateTime.parse(lastSync);
      final now = DateTime.now();
      final difference = now.difference(syncTime);

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
}

class _StatusIndicator extends StatelessWidget {
  final String status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'connected':
        statusColor = AppTheme.success;
        statusText = 'Connected';
        break;
      case 'error':
        statusColor = AppTheme.error;
        statusText = 'Error';
        break;
      case 'pending':
        statusColor = AppTheme.warning;
        statusText = 'Pending';
        break;
      default:
        statusColor = AppTheme.textSecondary;
        statusText = 'Disconnected';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusText,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          color: statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}