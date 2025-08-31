import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';

class RecentPostsCard extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final Function(Map<String, dynamic>) onPostTap;

  const RecentPostsCard({
    Key? key,
    required this.posts,
    required this.onPostTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return _EmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final post = posts[index];
        return _PostCard(
          post: post,
          onTap: () => onPostTap(post),
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.borderSubtle,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.post_add,
            size: 48.sp,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Recent Posts',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first post to see performance metrics here',
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
              Navigator.pushNamed(context, AppRoutes.uploadPosts);
            },
            icon: Icon(Icons.add, size: 20.sp),
            label: Text('Create Post'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onTap;

  const _PostCard({
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = post['content'] ?? '';
    final likesCount = post['likes_count'] ?? 0;
    final commentsCount = post['comments_count'] ?? 0;
    final sharesCount = post['shares_count'] ?? 0;
    final publishedAt = post['published_at'];
    final mediaUrls = List<String>.from(post['media_urls'] ?? []);
    final platform = post['connected_accounts']?['platform'] ?? '';
    final accountName =
        post['connected_accounts']?['account_name'] ?? 'Unknown';

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Post Header
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: _getPlatformColor(platform).withAlpha(26),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    _getPlatformIcon(platform),
                    color: _getPlatformColor(platform),
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountName,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatPublishedTime(publishedAt),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Actions
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppTheme.textSecondary,
                    size: 20.sp,
                  ),
                  color: AppTheme.secondaryBackground,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'boost',
                      child: Row(
                        children: [
                          Icon(Icons.rocket_launch,
                              color: AppTheme.accentPrimary, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text('Boost Post',
                              style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'analytics',
                      child: Row(
                        children: [
                          Icon(Icons.analytics,
                              color: AppTheme.success, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text('View Analytics',
                              style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'respond',
                      child: Row(
                        children: [
                          Icon(Icons.reply,
                              color: AppTheme.warning, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text('Respond to Comments',
                              style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'boost':
                        // Handle boost post
                        break;
                      case 'analytics':
                        // Handle view analytics
                        break;
                      case 'respond':
                        Navigator.pushNamed(context, AppRoutes.socialMessages);
                        break;
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Post Content
            if (content.isNotEmpty)
              Text(
                content,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

            if (content.isNotEmpty && mediaUrls.isNotEmpty)
              SizedBox(height: 12.h),

            // Media Preview
            if (mediaUrls.isNotEmpty)
              Container(
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppTheme.surfaceElevated,
                ),
                child: mediaUrls.length == 1
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: mediaUrls[0],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.surfaceElevated,
                            child: Icon(
                              Icons.image,
                              color: AppTheme.textSecondary,
                              size: 32.sp,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                bottomLeft: Radius.circular(8.r),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: mediaUrls[0],
                                fit: BoxFit.cover,
                                height: double.infinity,
                                errorWidget: (context, url, error) => Container(
                                  color: AppTheme.surfaceElevated,
                                  child: Icon(Icons.image,
                                      color: AppTheme.textSecondary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.r),
                                    bottomRight: Radius.circular(8.r),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: mediaUrls.length > 1
                                        ? mediaUrls[1]
                                        : mediaUrls[0],
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: AppTheme.surfaceElevated,
                                      child: Icon(Icons.image,
                                          color: AppTheme.textSecondary),
                                    ),
                                  ),
                                ),
                                if (mediaUrls.length > 2)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8.r),
                                          bottomRight: Radius.circular(8.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${mediaUrls.length - 2}',
                                          style: GoogleFonts.inter(
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),

            SizedBox(height: 16.h),

            // Engagement Metrics
            Row(
              children: [
                _MetricChip(
                  icon: Icons.favorite,
                  count: likesCount,
                  color: AppTheme.error,
                ),
                SizedBox(width: 12.w),
                _MetricChip(
                  icon: Icons.comment,
                  count: commentsCount,
                  color: AppTheme.accentPrimary,
                ),
                SizedBox(width: 12.w),
                _MetricChip(
                  icon: Icons.share,
                  count: sharesCount,
                  color: AppTheme.success,
                ),
                const Spacer(),

                // Engagement Rate
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${_calculateEngagementRate(likesCount, commentsCount, sharesCount).toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppTheme.accentPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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

  String _formatPublishedTime(String? publishedAt) {
    if (publishedAt == null) return 'Draft';

    try {
      final publishTime = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final difference = now.difference(publishTime);

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

  double _calculateEngagementRate(int likes, int comments, int shares) {
    final total = likes + comments + shares;
    // Simple engagement rate calculation (in real app, this would consider reach/impressions)
    return total > 0 ? (total * 0.1) : 0.0;
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _MetricChip({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: color,
        ),
        SizedBox(width: 4.w),
        Text(
          _formatCount(count),
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}