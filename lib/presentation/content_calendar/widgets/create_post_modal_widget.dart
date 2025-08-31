import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreatePostModalWidget extends StatefulWidget {
  final DateTime? preSelectedDateTime;
  final Function(Map<String, dynamic>) onCreatePost;

  const CreatePostModalWidget({
    Key? key,
    this.preSelectedDateTime,
    required this.onCreatePost,
  }) : super(key: key);

  @override
  State<CreatePostModalWidget> createState() => _CreatePostModalWidgetState();
}

class _CreatePostModalWidgetState extends State<CreatePostModalWidget> {
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  List<String> _selectedPlatforms = [];
  String? _selectedImage;

  final List<Map<String, dynamic>> _availablePlatforms = [
    {'name': 'Facebook', 'icon': 'facebook', 'color': Color(0xFF1877F2)},
    {'name': 'Instagram', 'icon': 'camera_alt', 'color': Color(0xFFE4405F)},
    {'name': 'Twitter', 'icon': 'alternate_email', 'color': Color(0xFF1DA1F2)},
    {'name': 'LinkedIn', 'icon': 'business', 'color': Color(0xFF0A66C2)},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedDateTime != null) {
      _selectedDateTime = widget.preSelectedDateTime!;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentSection(),
                  SizedBox(height: 3.h),
                  _buildImageSection(),
                  SizedBox(height: 3.h),
                  _buildPlatformSection(),
                  SizedBox(height: 3.h),
                  _buildScheduleSection(),
                  SizedBox(height: 4.h),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderSubtle,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'สร้างโพสต์ใหม่',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เนื้อหาโพสต์',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _contentController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'เขียนเนื้อหาโพสต์ของคุณที่นี่...',
            hintStyle: AppTheme.darkTheme.inputDecorationTheme.hintStyle,
            filled: true,
            fillColor: AppTheme.primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppTheme.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppTheme.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppTheme.accentPrimary, width: 2.0),
            ),
          ),
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รูปภาพ',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: _selectImage,
          child: Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 1.0,
              ),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CustomImageWidget(
                      imageUrl: _selectedImage!,
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'add_photo_alternate',
                        color: AppTheme.textSecondary,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'เพิ่มรูปภาพ',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เลือกแพลตฟอร์ม',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _availablePlatforms.map((platform) {
            final isSelected = _selectedPlatforms.contains(platform['name']);
            return GestureDetector(
              onTap: () => _togglePlatform(platform['name'] as String),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (platform['color'] as Color).withValues(alpha: 0.1)
                      : AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isSelected
                        ? platform['color'] as Color
                        : AppTheme.borderSubtle,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: platform['icon'] as String,
                      color: isSelected
                          ? platform['color'] as Color
                          : AppTheme.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      platform['name'] as String,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? platform['color'] as Color
                            : AppTheme.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'กำหนดเวลาเผยแพร่',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: _selectDateTime,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.accentPrimary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(_selectedDateTime),
                      style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatTime(_selectedDateTime),
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_right',
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _canCreatePost() ? _createPost : null,
            child: Text('สร้างโพสต์'),
          ),
        ),
      ],
    );
  }

  void _selectImage() {
    // Mock image selection
    setState(() {
      _selectedImage =
          'https://images.unsplash.com/photo-1611224923853-80b023f02d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3';
    });
  }

  void _togglePlatform(String platform) {
    setState(() {
      if (_selectedPlatforms.contains(platform)) {
        _selectedPlatforms.remove(platform);
      } else {
        _selectedPlatforms.add(platform);
      }
    });
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme,
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: AppTheme.darkTheme,
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  bool _canCreatePost() {
    return _contentController.text.trim().isNotEmpty &&
        _selectedPlatforms.isNotEmpty;
  }

  void _createPost() {
    final post = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'content': _contentController.text.trim(),
      'image': _selectedImage,
      'platforms': _selectedPlatforms,
      'scheduledTime': _selectedDateTime,
      'status': 'scheduled',
      'createdAt': DateTime.now(),
    };

    widget.onCreatePost(post);
    Navigator.pop(context);
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year + 543}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} น.';
  }
}
