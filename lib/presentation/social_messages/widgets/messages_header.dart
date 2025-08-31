import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MessagesHeader extends StatelessWidget implements PreferredSizeWidget {
  final int unreadCount;
  final VoidCallback onBackPressed;
  final VoidCallback onPriorityToggle;
  final bool showPriorityOnly;

  const MessagesHeader({
    super.key,
    required this.unreadCount,
    required this.onBackPressed,
    required this.onPriorityToggle,
    this.showPriorityOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: IconButton(
        onPressed: onBackPressed,
        icon: Icon(
          Icons.arrow_back,
          color: AppTheme.textPrimary,
          size: 24.sp,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Messages',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (unreadCount > 0)
            Text(
              '$unreadCount unread messages',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
      actions: [
        // Priority Filter Toggle
        Container(
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            color: showPriorityOnly
                ? AppTheme.warning.withAlpha(26)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: showPriorityOnly
                ? Border.all(color: AppTheme.warning, width: 1)
                : null,
          ),
          child: IconButton(
            onPressed: onPriorityToggle,
            icon: Icon(
              showPriorityOnly ? Icons.priority_high : Icons.low_priority,
              color:
                  showPriorityOnly ? AppTheme.warning : AppTheme.textSecondary,
              size: 24.sp,
            ),
            tooltip:
                showPriorityOnly ? 'Show All Messages' : 'Show Priority Only',
          ),
        ),

        // Unread Count Badge
        if (unreadCount > 0)
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // Handle filter by unread
                  },
                  icon: Icon(
                    Icons.mark_email_unread,
                    color: AppTheme.accentPrimary,
                    size: 24.sp,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20.w,
                      minHeight: 20.h,
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}