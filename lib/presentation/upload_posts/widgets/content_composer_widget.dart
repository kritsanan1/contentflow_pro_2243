import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContentComposerWidget extends StatefulWidget {
  final TextEditingController textController;
  final int characterLimit;
  final VoidCallback onAIAssistant;

  const ContentComposerWidget({
    Key? key,
    required this.textController,
    required this.characterLimit,
    required this.onAIAssistant,
  }) : super(key: key);

  @override
  State<ContentComposerWidget> createState() => _ContentComposerWidgetState();
}

class _ContentComposerWidgetState extends State<ContentComposerWidget> {
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _currentLength = widget.textController.text.length;
    widget.textController.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_updateCharacterCount);
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _currentLength = widget.textController.text.length;
    });
  }

  Color _getCharacterCountColor() {
    final percentage = _currentLength / widget.characterLimit;
    if (percentage >= 1.0) return AppTheme.error;
    if (percentage >= 0.8) return AppTheme.warning;
    return AppTheme.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.accentPrimary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'เขียนเนื้อหา',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: widget.onAIAssistant,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.accentPrimary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'auto_awesome',
                        color: AppTheme.accentPrimary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'AI ช่วยเขียน',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
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
          SizedBox(height: 3.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderSubtle,
              ),
            ),
            child: TextField(
              controller: widget.textController,
              maxLines: 8,
              style: AppTheme.darkTheme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'เขียนเนื้อหาที่คุณต้องการโพสต์...',
                hintStyle: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add hashtag functionality
                      final currentText = widget.textController.text;
                      final cursorPosition =
                          widget.textController.selection.baseOffset;
                      final newText = currentText.substring(0, cursorPosition) +
                          '#' +
                          currentText.substring(cursorPosition);
                      widget.textController.text = newText;
                      widget.textController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: cursorPosition + 1),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.borderSubtle,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'tag',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () {
                      // Add mention functionality
                      final currentText = widget.textController.text;
                      final cursorPosition =
                          widget.textController.selection.baseOffset;
                      final newText = currentText.substring(0, cursorPosition) +
                          '@' +
                          currentText.substring(cursorPosition);
                      widget.textController.text = newText;
                      widget.textController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: cursorPosition + 1),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.borderSubtle,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'alternate_email',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _currentLength > widget.characterLimit
                      ? AppTheme.error.withValues(alpha: 0.1)
                      : AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getCharacterCountColor(),
                  ),
                ),
                child: Text(
                  '$_currentLength/${widget.characterLimit}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: _getCharacterCountColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (_currentLength > widget.characterLimit) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'error_outline',
                    color: AppTheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'เนื้อหายาวเกินขีดจำกัด กรุณาลดจำนวนตัวอักษร',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
