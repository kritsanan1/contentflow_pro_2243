import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PlatformFilterChips extends StatelessWidget {
  final List<String> platforms;
  final String selectedPlatform;
  final Function(String) onPlatformChanged;

  const PlatformFilterChips({
    Key? key,
    required this.platforms,
    required this.selectedPlatform,
    required this.onPlatformChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: platforms.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final platform = platforms[index];
          final isSelected = platform == selectedPlatform;

          return _PlatformChip(
            platform: platform,
            isSelected: isSelected,
            onTap: () => onPlatformChanged(platform),
          );
        },
      ),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final String platform;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlatformChip({
    required this.platform,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final platformData = _getPlatformData(platform);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? platformData.color.withAlpha(26)
              : AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? platformData.color : AppTheme.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (platform != 'all') ...[
              Icon(
                platformData.icon,
                size: 16.sp,
                color: isSelected ? platformData.color : AppTheme.textSecondary,
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              platformData.name,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: isSelected ? platformData.color : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _PlatformData _getPlatformData(String platform) {
    switch (platform.toLowerCase()) {
      case 'all':
        return _PlatformData(
          name: 'All Platforms',
          icon: Icons.select_all,
          color: AppTheme.accentPrimary,
        );
      case 'facebook':
        return _PlatformData(
          name: 'Facebook',
          icon: Icons.facebook,
          color: const Color(0xFF1877F2),
        );
      case 'instagram':
        return _PlatformData(
          name: 'Instagram',
          icon: Icons.camera_alt,
          color: const Color(0xFFE4405F),
        );
      case 'twitter':
        return _PlatformData(
          name: 'Twitter',
          icon: Icons.alternate_email,
          color: const Color(0xFF1DA1F2),
        );
      case 'linkedin':
        return _PlatformData(
          name: 'LinkedIn',
          icon: Icons.business,
          color: const Color(0xFF0A66C2),
        );
      case 'tiktok':
        return _PlatformData(
          name: 'TikTok',
          icon: Icons.music_video,
          color: const Color(0xFF000000),
        );
      case 'youtube':
        return _PlatformData(
          name: 'YouTube',
          icon: Icons.video_library,
          color: const Color(0xFFFF0000),
        );
      default:
        return _PlatformData(
          name: platform.toUpperCase(),
          icon: Icons.share,
          color: AppTheme.accentPrimary,
        );
    }
  }
}

class _PlatformData {
  final String name;
  final IconData icon;
  final Color color;

  const _PlatformData({
    required this.name,
    required this.icon,
    required this.color,
  });
}