import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MediaSelectionWidget extends StatefulWidget {
  final List<XFile> selectedMedia;
  final Function(List<XFile>) onMediaChanged;

  const MediaSelectionWidget({
    Key? key,
    required this.selectedMedia,
    required this.onMediaChanged,
  }) : super(key: key);

  @override
  State<MediaSelectionWidget> createState() => _MediaSelectionWidgetState();
}

class _MediaSelectionWidgetState extends State<MediaSelectionWidget> {
  final ImagePicker _picker = ImagePicker();
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _showCamera = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final camera = kIsWeb
            ? _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras.first)
            : _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
                orElse: () => _cameras.first);

        _cameraController = CameraController(
            camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

        await _cameraController!.initialize();
        await _applySettings();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: $e');
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      final updatedMedia = List<XFile>.from(widget.selectedMedia)..add(photo);
      widget.onMediaChanged(updatedMedia);
      setState(() {
        _showCamera = false;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final updatedMedia = List<XFile>.from(widget.selectedMedia)
          ..addAll(images);
        widget.onMediaChanged(updatedMedia);
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  void _removeMedia(int index) {
    final updatedMedia = List<XFile>.from(widget.selectedMedia)
      ..removeAt(index);
    widget.onMediaChanged(updatedMedia);
  }

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'เลือกสื่อ',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.accentPrimary,
                size: 24,
              ),
              title: Text(
                'ถ่ายรูป',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () async {
                Navigator.pop(context);
                if (await _requestCameraPermission()) {
                  setState(() {
                    _showCamera = true;
                  });
                }
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.accentPrimary,
                size: 24,
              ),
              title: Text(
                'เลือกจากแกลเลอรี่',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCamera && _isCameraInitialized && _cameraController != null) {
      return Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CameraPreview(_cameraController!),
            ),
            Positioned(
              top: 2.h,
              left: 4.w,
              child: GestureDetector(
                onTap: () => setState(() => _showCamera = false),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _capturePhoto,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: AppTheme.textPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.accentPrimary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (widget.selectedMedia.isEmpty)
            GestureDetector(
              onTap: _showMediaOptions,
              child: Container(
                height: 40.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.borderSubtle,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add_photo_alternate',
                      color: AppTheme.textSecondary,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'แตะเพื่อเพิ่มรูปภาพหรือวิดีโอ',
                      style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'รองรับไฟล์ JPG, PNG, MP4',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                Container(
                  height: 40.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        CustomImageWidget(
                          imageUrl: widget.selectedMedia.first.path,
                          width: double.infinity,
                          height: 40.h,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 2.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () => _removeMedia(0),
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: AppTheme.error,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme.textPrimary,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.selectedMedia.length > 1) ...[
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 15.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.selectedMedia.length - 1,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 2.w),
                      itemBuilder: (context, index) {
                        final mediaIndex = index + 1;
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                imageUrl: widget.selectedMedia[mediaIndex].path,
                                width: 20.w,
                                height: 15.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 1.w,
                              right: 1.w,
                              child: GestureDetector(
                                onTap: () => _removeMedia(mediaIndex),
                                child: Container(
                                  padding: EdgeInsets.all(0.5.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'close',
                                    color: AppTheme.textPrimary,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: _showMediaOptions,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.accentPrimary,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.accentPrimary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'เพิ่มสื่อ',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
