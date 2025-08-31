import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuickActionsFab extends StatefulWidget {
  final VoidCallback onCreatePost;
  final VoidCallback onViewMessages;
  final VoidCallback onViewCalendar;

  const QuickActionsFab({
    Key? key,
    required this.onCreatePost,
    required this.onViewMessages,
    required this.onViewCalendar,
  }) : super(key: key);

  @override
  State<QuickActionsFab> createState() => _QuickActionsFabState();
}

class _QuickActionsFabState extends State<QuickActionsFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Action Buttons (animated)
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // View Calendar Button
                    _QuickActionButton(
                      icon: Icons.calendar_today,
                      label: 'Calendar',
                      backgroundColor: AppTheme.warning,
                      onPressed: () {
                        _toggleExpanded();
                        widget.onViewCalendar();
                      },
                    ),

                    SizedBox(height: 16.h),

                    // View Messages Button
                    _QuickActionButton(
                      icon: Icons.message,
                      label: 'Messages',
                      backgroundColor: AppTheme.accentSecondary,
                      onPressed: () {
                        _toggleExpanded();
                        widget.onViewMessages();
                      },
                    ),

                    SizedBox(height: 16.h),

                    // Create Post Button
                    _QuickActionButton(
                      icon: Icons.add,
                      label: 'Create Post',
                      backgroundColor: AppTheme.success,
                      onPressed: () {
                        _toggleExpanded();
                        widget.onCreatePost();
                      },
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        ),

        // Main FAB
        FloatingActionButton(
          onPressed: _toggleExpanded,
          backgroundColor: AppTheme.accentPrimary,
          foregroundColor: AppTheme.textPrimary,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: _isExpanded ? 0.125 : 0, // 45 degrees rotation
            child: Icon(
              _isExpanded ? Icons.close : Icons.speed,
              size: 28.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: AppTheme.getElevationShadow(2),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Action Button
        FloatingActionButton.small(
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          heroTag: label, // Unique tag for each FAB
          child: Icon(
            icon,
            size: 20.sp,
          ),
        ),
      ],
    );
  }
}