import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';
import '../../../services/supabase_service.dart';
import '../../../theme/app_theme.dart';

class DashboardHeader extends StatefulWidget {
  final VoidCallback onNotificationTap;
  final VoidCallback onRefresh;

  const DashboardHeader({
    Key? key,
    required this.onNotificationTap,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String _userName = 'User';
  String _userAvatar = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = SupabaseService.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.userMetadata?['full_name'] ??
            user.email?.split('@')[0] ??
            'User';
        _userAvatar = user.userMetadata?['avatar_url'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = 'Good Evening';

    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    }

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppTheme.accentPrimary.withAlpha(26),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.accentPrimary.withAlpha(77),
                width: 2,
              ),
            ),
            child: _userAvatar.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: CachedNetworkImage(
                      imageUrl: _userAvatar,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        color: AppTheme.accentPrimary,
                        size: 24.sp,
                      ),
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: AppTheme.accentPrimary,
                    size: 24.sp,
                  ),
          ),

          SizedBox(width: 12.w),

          // Greeting and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _userName,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              // Refresh Button
              IconButton(
                onPressed: widget.onRefresh,
                icon: Icon(
                  Icons.refresh,
                  color: AppTheme.textSecondary,
                  size: 24.sp,
                ),
                tooltip: 'Refresh Dashboard',
              ),

              // Notifications Button
              Stack(
                children: [
                  IconButton(
                    onPressed: widget.onNotificationTap,
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.textSecondary,
                      size: 24.sp,
                    ),
                    tooltip: 'Messages & Notifications',
                  ),

                  // Notification Badge
                  Positioned(
                    right: 8.w,
                    top: 8.h,
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),

              // Account Switcher
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textSecondary,
                  size: 24.sp,
                ),
                color: AppTheme.secondaryBackground,
                tooltip: 'Account Options',
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: AppTheme.textSecondary, size: 20.sp),
                        SizedBox(width: 12.w),
                        Text('Profile Settings',
                            style:
                                GoogleFonts.inter(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'accounts',
                    child: Row(
                      children: [
                        Icon(Icons.account_circle_outlined,
                            color: AppTheme.textSecondary, size: 20.sp),
                        SizedBox(width: 12.w),
                        Text('Connected Accounts',
                            style:
                                GoogleFonts.inter(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined,
                            color: AppTheme.textSecondary, size: 20.sp),
                        SizedBox(width: 12.w),
                        Text('Settings',
                            style:
                                GoogleFonts.inter(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'accounts':
                      Navigator.pushNamed(context, AppRoutes.connectSocials);
                      break;
                    case 'settings':
                      Navigator.pushNamed(
                          context, AppRoutes.subscriptionManagement);
                      break;
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}