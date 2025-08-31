import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_enhancement_panel.dart';
import './widgets/content_composer_widget.dart';
import './widgets/media_selection_widget.dart';
import './widgets/platform_selection_widget.dart';
import './widgets/scheduling_widget.dart';

class UploadPosts extends StatefulWidget {
  const UploadPosts({Key? key}) : super(key: key);

  @override
  State<UploadPosts> createState() => _UploadPostsState();
}

class _UploadPostsState extends State<UploadPosts> {
  final TextEditingController _contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<XFile> _selectedMedia = [];
  List<String> _selectedPlatforms = [];
  DateTime? _scheduledDateTime;
  bool _showAIPanel = false;
  bool _isPosting = false;
  bool _showAdvancedOptions = false;

  // Mock data for connected platforms
  final List<Map<String, dynamic>> _platforms = [
    {
      'id': 'facebook',
      'name': 'Facebook',
      'icon': 'facebook',
      'color': 0xFF1877F2,
      'isConnected': true,
      'characterLimit': 63206,
    },
    {
      'id': 'instagram',
      'name': 'Instagram',
      'icon': 'camera_alt',
      'color': 0xFFE4405F,
      'isConnected': true,
      'characterLimit': 2200,
    },
    {
      'id': 'twitter',
      'name': 'Twitter',
      'icon': 'alternate_email',
      'color': 0xFF1DA1F2,
      'isConnected': false,
      'characterLimit': 280,
    },
    {
      'id': 'linkedin',
      'name': 'LinkedIn',
      'icon': 'business_center',
      'color': 0xFF0A66C2,
      'isConnected': true,
      'characterLimit': 3000,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDraft() {
    // Simulate loading draft from local storage
    // In real implementation, this would load from SharedPreferences or local database
  }

  void _saveDraft() {
    // Simulate saving draft to local storage
    // In real implementation, this would save to SharedPreferences or local database
    if (_contentController.text.isNotEmpty || _selectedMedia.isNotEmpty) {
      // Auto-save functionality
    }
  }

  int _getCharacterLimit() {
    if (_selectedPlatforms.isEmpty) return 280;

    int minLimit = 280;
    for (String platformId in _selectedPlatforms) {
      final platform = _platforms.firstWhere(
        (p) => p['id'] == platformId,
        orElse: () => {'characterLimit': 280},
      );
      final limit = platform['characterLimit'] as int;
      if (limit < minLimit) {
        minLimit = limit;
      }
    }
    return minLimit;
  }

  bool _canPost() {
    return _selectedPlatforms.isNotEmpty &&
        (_contentController.text.isNotEmpty || _selectedMedia.isNotEmpty) &&
        _contentController.text.length <= _getCharacterLimit();
  }

  Future<void> _handlePost() async {
    if (!_canPost()) return;

    setState(() {
      _isPosting = true;
    });

    try {
      // Simulate API call to post content
      await Future.delayed(Duration(seconds: 2));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _scheduledDateTime != null
                ? 'โพสต์ถูกกำหนดเวลาเรียบร้อยแล้ว'
                : 'โพสต์สำเร็จแล้ว',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      // Clear form and navigate back
      _contentController.clear();
      setState(() {
        _selectedMedia.clear();
        _selectedPlatforms.clear();
        _scheduledDateTime = null;
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  void _showAIEnhancementPanel() {
    setState(() {
      _showAIPanel = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AIEnhancementPanel(
        onContentGenerated: (content) {
          _contentController.text = content;
          Navigator.pop(context);
          setState(() {
            _showAIPanel = false;
          });
        },
        onClose: () {
          Navigator.pop(context);
          setState(() {
            _showAIPanel = false;
          });
        },
      ),
    );
  }

  void _showPreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.secondaryBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'preview',
                    color: AppTheme.accentPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'ตัวอย่างโพสต์',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _selectedPlatforms.length,
                itemBuilder: (context, index) {
                  final platformId = _selectedPlatforms[index];
                  final platform =
                      _platforms.firstWhere((p) => p['id'] == platformId);

                  return Container(
                    margin: EdgeInsets.only(bottom: 3.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.borderSubtle,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: Color(platform['color']),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: platform['icon'],
                                  color: AppTheme.textPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              platform['name'],
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (_selectedMedia.isNotEmpty) ...[
                          SizedBox(height: 3.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl: _selectedMedia.first.path,
                              width: double.infinity,
                              height: 30.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        if (_contentController.text.isNotEmpty) ...[
                          SizedBox(height: 3.h),
                          Text(
                            _contentController.text,
                            style: AppTheme.darkTheme.textTheme.bodyLarge,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            _saveDraft();
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'สร้างโพสต์',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_selectedPlatforms.isNotEmpty)
            GestureDetector(
              onTap: _showPreview,
              child: Container(
                margin: EdgeInsets.only(right: 2.w),
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'preview',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Media Selection
                  MediaSelectionWidget(
                    selectedMedia: _selectedMedia,
                    onMediaChanged: (media) {
                      setState(() {
                        _selectedMedia = media;
                      });
                      _saveDraft();
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Platform Selection
                  PlatformSelectionWidget(
                    platforms: _platforms,
                    selectedPlatforms: _selectedPlatforms,
                    onPlatformsChanged: (platforms) {
                      setState(() {
                        _selectedPlatforms = platforms;
                      });
                      _saveDraft();
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Content Composer
                  ContentComposerWidget(
                    textController: _contentController,
                    characterLimit: _getCharacterLimit(),
                    onAIAssistant: _showAIEnhancementPanel,
                  ),

                  SizedBox(height: 4.h),

                  // Scheduling
                  SchedulingWidget(
                    scheduledDateTime: _scheduledDateTime,
                    onScheduleChanged: (dateTime) {
                      setState(() {
                        _scheduledDateTime = dateTime;
                      });
                      _saveDraft();
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Advanced Options
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showAdvancedOptions = !_showAdvancedOptions;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'tune',
                                  color: AppTheme.accentPrimary,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'ตัวเลือกขั้นสูง',
                                  style: AppTheme
                                      .darkTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                CustomIconWidget(
                                  iconName: _showAdvancedOptions
                                      ? 'keyboard_arrow_up'
                                      : 'keyboard_arrow_down',
                                  color: AppTheme.textSecondary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_showAdvancedOptions) ...[
                          Divider(
                            color: AppTheme.borderSubtle,
                            height: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              children: [
                                // Geo-tagging option
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'location_on',
                                      color: AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        'เพิ่มตำแหน่งที่ตั้ง',
                                        style: AppTheme
                                            .darkTheme.textTheme.bodyLarge,
                                      ),
                                    ),
                                    Switch(
                                      value: false,
                                      onChanged: (value) {
                                        // Handle geo-tagging toggle
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),

                                // Cross-posting option
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'sync',
                                      color: AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        'ซิงค์ข้ามแพลตฟอร์ม',
                                        style: AppTheme
                                            .darkTheme.textTheme.bodyLarge,
                                      ),
                                    ),
                                    Switch(
                                      value: true,
                                      onChanged: (value) {
                                        // Handle cross-posting toggle
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h), // Extra space for bottom button
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canPost() && !_isPosting ? _handlePost : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canPost()
                        ? AppTheme.accentPrimary
                        : AppTheme.borderSubtle,
                    foregroundColor: _canPost()
                        ? AppTheme.textPrimary
                        : AppTheme.textDisabled,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isPosting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.textPrimary),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              _scheduledDateTime != null
                                  ? 'กำลังกำหนดเวลา...'
                                  : 'กำลังโพสต์...',
                              style: AppTheme.darkTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: _scheduledDateTime != null
                                  ? 'schedule_send'
                                  : 'send',
                              color: _canPost()
                                  ? AppTheme.textPrimary
                                  : AppTheme.textDisabled,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _scheduledDateTime != null
                                  ? 'กำหนดเวลาโพสต์'
                                  : 'โพสต์เลย',
                              style: AppTheme.darkTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
