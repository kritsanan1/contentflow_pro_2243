import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/connection_status_widget.dart';
import './widgets/platform_card_widget.dart';
import './widgets/security_indicator_widget.dart';
import './widgets/troubleshooting_widget.dart';

class ConnectSocials extends StatefulWidget {
  const ConnectSocials({Key? key}) : super(key: key);

  @override
  State<ConnectSocials> createState() => _ConnectSocialsState();
}

class _ConnectSocialsState extends State<ConnectSocials> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _socialPlatforms = [
    {
      'id': 'facebook',
      'name': 'Facebook',
      'iconName': 'facebook',
      'brandColor': 0xFF1877F2,
      'isConnected': true,
      'username': '@contentflow_thailand',
      'followers': '12,450',
      'avatar':
          'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=400&h=400&fit=crop&crop=face',
      'lastSync': '2 นาทีที่แล้ว',
      'permissions': ['โพสต์', 'อ่านความคิดเห็น', 'ดูสถิติ'],
    },
    {
      'id': 'instagram',
      'name': 'Instagram',
      'iconName': 'camera_alt',
      'brandColor': 0xFFE4405F,
      'isConnected': true,
      'username': '@contentflow.th',
      'followers': '8,920',
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face',
      'lastSync': '5 นาทีที่แล้ว',
      'permissions': ['โพสต์รูปภาพ', 'โพสต์ Stories', 'ดูสถิติ'],
    },
    {
      'id': 'twitter',
      'name': 'Twitter / X',
      'iconName': 'alternate_email',
      'brandColor': 0xFF1DA1F2,
      'isConnected': false,
      'username': null,
      'followers': null,
      'avatar': null,
      'lastSync': null,
      'permissions': [],
    },
    {
      'id': 'linkedin',
      'name': 'LinkedIn',
      'iconName': 'business',
      'brandColor': 0xFF0A66C2,
      'isConnected': true,
      'username': 'ContentFlow Pro Thailand',
      'followers': '2,340',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
      'lastSync': '1 ชั่วโมงที่แล้ว',
      'permissions': ['โพสต์', 'แชร์บทความ', 'ดูเครือข่าย'],
    },
    {
      'id': 'tiktok',
      'name': 'TikTok',
      'iconName': 'video_library',
      'brandColor': 0xFF000000,
      'isConnected': false,
      'username': null,
      'followers': null,
      'avatar': null,
      'lastSync': null,
      'permissions': [],
    },
    {
      'id': 'youtube',
      'name': 'YouTube',
      'iconName': 'play_circle_filled',
      'brandColor': 0xFFFF0000,
      'isConnected': false,
      'username': null,
      'followers': null,
      'avatar': null,
      'lastSync': null,
      'permissions': [],
    },
  ];

  int get _connectedCount => _socialPlatforms
      .where((platform) => platform['isConnected'] == true)
      .length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 6.w,
        ),
      ),
      title: Text(
        'เชื่อมต่อโซเชียลมีเดีย',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showHelpDialog,
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.textSecondary,
            size: 6.w,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentPrimary),
          ),
          SizedBox(height: 2.h),
          Text(
            'กำลังโหลดข้อมูลการเชื่อมต่อ...',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.accentPrimary,
      backgroundColor: AppTheme.secondaryBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            ConnectionStatusWidget(
              connectedCount: _connectedCount,
              totalCount: _socialPlatforms.length,
              onRefresh: _handleRefresh,
            ),
            SizedBox(height: 2.h),
            SecurityIndicatorWidget(
              isSecure: true,
              lastVerification: '31 สิงหาคม 2025, 17:12',
            ),
            SizedBox(height: 2.h),
            _buildPlatformsSection(),
            SizedBox(height: 2.h),
            const TroubleshootingWidget(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'แพลตฟอร์มที่รองรับ',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _socialPlatforms.length,
          itemBuilder: (context, index) {
            final platform = _socialPlatforms[index];
            return PlatformCardWidget(
              platform: platform,
              onConnect: () => _handleConnect(platform),
              onManage: platform['isConnected']
                  ? () => _handleManage(platform)
                  : null,
            );
          },
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call to refresh connection status
    await Future.delayed(const Duration(seconds: 2));

    // Update last sync times for connected platforms
    for (var platform in _socialPlatforms) {
      if (platform['isConnected'] == true) {
        platform['lastSync'] = 'เมื่อสักครู่';
      }
    }

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'อัปเดตสถานะการเชื่อมต่อเรียบร้อยแล้ว',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleConnect(Map<String, dynamic> platform) {
    _showConnectDialog(platform);
  }

  void _handleManage(Map<String, dynamic> platform) {
    _showManageDialog(platform);
  }

  void _showConnectDialog(Map<String, dynamic> platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: platform['iconName'],
                color: Color(platform['brandColor']),
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'เชื่อมต่อ ${platform['name']}',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'คุณจะถูกนำไปยังหน้าเว็บของ ${platform['name']} เพื่อยืนยันการเชื่อมต่อ',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentPrimary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.accentPrimary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'การเชื่อมต่อนี้ปลอดภัยและเข้ารหัส',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performConnect(platform);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(platform['brandColor']),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'เชื่อมต่อ',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showManageDialog(Map<String, dynamic> platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl:
                      platform['avatar'] ?? 'https://via.placeholder.com/40',
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'จัดการบัญชี',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      platform['username'] ?? '',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildManageOption(
                'refresh',
                'รีเฟรช Token',
                'อัปเดตการยืนยันตัวตน',
                () {
                  Navigator.pop(context);
                  _refreshToken(platform);
                },
              ),
              SizedBox(height: 1.h),
              _buildManageOption(
                'visibility',
                'ดูสิทธิ์การเข้าถึง',
                'ตรวจสอบสิทธิ์ที่ให้ไว้',
                () {
                  Navigator.pop(context);
                  _showPermissions(platform);
                },
              ),
              SizedBox(height: 1.h),
              _buildManageOption(
                'link_off',
                'ยกเลิกการเชื่อมต่อ',
                'ตัดการเชื่อมต่อบัญชีนี้',
                () {
                  Navigator.pop(context);
                  _showDisconnectConfirmation(platform);
                },
                isDestructive: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ปิด',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildManageOption(
      String iconName, String title, String subtitle, VoidCallback onTap,
      {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive
                ? AppTheme.error.withValues(alpha: 0.3)
                : AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isDestructive ? AppTheme.error : AppTheme.textSecondary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color:
                          isDestructive ? AppTheme.error : AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  void _performConnect(Map<String, dynamic> platform) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate OAuth flow
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      platform['isConnected'] = true;
      platform['username'] = '@contentflow_${platform['id']}';
      platform['followers'] = '1,234';
      platform['avatar'] =
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face';
      platform['lastSync'] = 'เมื่อสักครู่';
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'เชื่อมต่อ ${platform['name']} สำเร็จแล้ว!',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _refreshToken(Map<String, dynamic> platform) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'กำลังรีเฟรช Token สำหรับ ${platform['name']}...',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.accentPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      platform['lastSync'] = 'เมื่อสักครู่';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'รีเฟรช Token สำเร็จแล้ว',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showPermissions(Map<String, dynamic> platform) {
    final List<String> permissions =
        (platform['permissions'] as List).cast<String>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'สิทธิ์การเข้าถึง ${platform['name']}',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'สิทธิ์ที่ให้ไว้กับแอป:',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              ...permissions
                  .map((permission) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.success,
                              size: 4.w,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              permission,
                              style: AppTheme.darkTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ปิด',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDisconnectConfirmation(Map<String, dynamic> platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.warning,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'ยกเลิกการเชื่อมต่อ',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'คุณแน่ใจหรือไม่ที่จะยกเลิกการเชื่อมต่อกับ ${platform['name']}? คุณจะไม่สามารถโพสต์หรือจัดการเนื้อหาในแพลตฟอร์มนี้ได้อีก',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performDisconnect(platform);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'ยกเลิกการเชื่อมต่อ',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performDisconnect(Map<String, dynamic> platform) {
    setState(() {
      platform['isConnected'] = false;
      platform['username'] = null;
      platform['followers'] = null;
      platform['avatar'] = null;
      platform['lastSync'] = null;
      platform['permissions'] = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ยกเลิกการเชื่อมต่อ ${platform['name']} แล้ว',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'help',
                color: AppTheme.accentPrimary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'ช่วยเหลือ',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'วิธีการเชื่อมต่อโซเชียลมีเดีย:',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '1. กดปุ่ม "เชื่อมต่อบัญชี" ในแพลตฟอร์มที่ต้องการ\n'
                '2. คุณจะถูกนำไปยังหน้าเว็บของแพลตฟอร์มนั้น\n'
                '3. เข้าสู่ระบบและอนุญาตให้แอปเข้าถึงบัญชี\n'
                '4. กลับมาที่แอปเพื่อเริ่มใช้งาน',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentPrimary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.accentPrimary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'ข้อมูลของคุณปลอดภัยและเข้ารหัส เราไม่เก็บรหัสผ่านของคุณ',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'เข้าใจแล้ว',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.accentPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
