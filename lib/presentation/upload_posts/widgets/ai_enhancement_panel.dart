import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AIEnhancementPanel extends StatefulWidget {
  final Function(String) onContentGenerated;
  final VoidCallback onClose;

  const AIEnhancementPanel({
    Key? key,
    required this.onContentGenerated,
    required this.onClose,
  }) : super(key: key);

  @override
  State<AIEnhancementPanel> createState() => _AIEnhancementPanelState();
}

class _AIEnhancementPanelState extends State<AIEnhancementPanel> {
  String _selectedTone = 'professional';
  bool _isGenerating = false;

  final List<Map<String, dynamic>> _toneOptions = [
    {
      'id': 'professional',
      'name': 'มืออาชีพ',
      'description': 'เหมาะสำหรับธุรกิจและการทำงาน',
      'icon': 'business_center',
    },
    {
      'id': 'casual',
      'name': 'สบายๆ',
      'description': 'เป็นกันเองและใกล้ชิด',
      'icon': 'sentiment_satisfied',
    },
    {
      'id': 'engaging',
      'name': 'น่าสนใจ',
      'description': 'ดึงดูดความสนใจและมีส่วนร่วม',
      'icon': 'favorite',
    },
  ];

  final List<String> _hashtagSuggestions = [
    '#ธุรกิจออนไลน์',
    '#การตลาดดิจิทัล',
    '#เทคโนโลยี',
    '#นวัตกรรม',
    '#ความสำเร็จ',
    '#แรงบันดาลใจ',
    '#ชีวิตดีๆ',
    '#ทำงานจากบ้าน',
    '#ผู้ประกอบการ',
    '#การเรียนรู้',
  ];

  final List<Map<String, dynamic>> _optimalTimes = [
    {
      'time': '09:00',
      'platform': 'Facebook',
      'engagement': 'สูง',
      'reason': 'เวลาเช้าที่คนเริ่มใช้โซเชียล',
    },
    {
      'time': '12:00',
      'platform': 'Instagram',
      'engagement': 'สูงมาก',
      'reason': 'เวลาพักกลางวันที่มีการใช้งานมาก',
    },
    {
      'time': '19:00',
      'platform': 'Twitter',
      'engagement': 'สูง',
      'reason': 'เวลาหลังเลิกงานที่มีการแชร์ข้อมูล',
    },
  ];

  Future<void> _generateContent() async {
    setState(() {
      _isGenerating = true;
    });

    // Simulate AI content generation
    await Future.delayed(Duration(seconds: 2));

    final Map<String, String> contentTemplates = {
      'professional':
          'ในยุคดิจิทัลนี้ การปรับตัวและการเรียนรู้สิ่งใหม่ๆ เป็นกุญแจสำคัญของความสำเร็จ เราต้องมองหาโอกาสในทุกความท้าทายและพัฒนาตนเองอย่างต่อเนื่อง #ความสำเร็จ #การเรียนรู้ #นวัตกรรม',
      'casual':
          'วันนี้เป็นวันที่ดีมากเลย! 😊 ได้เรียนรู้สิ่งใหม่ๆ และพบเจอประสบการณ์ที่น่าสนใจ อยากแชร์ความสุขเล็กๆ น้อยๆ ให้ทุกคนได้รู้สึกดีไปด้วยกัน ✨ #ชีวิตดีๆ #ความสุข #แรงบันดาลใจ',
      'engaging':
          '🚀 คุณรู้ไหมว่าสิ่งที่ทำให้เราแตกต่างคืออะไร? คือการกล้าที่จะเริ่มต้นสิ่งใหม่! มาร่วมแชร์ประสบการณ์และเรียนรู้ไปด้วยกัน คอมเมนต์บอกเราหน่อยว่าคุณกำลังทำอะไรใหม่ๆ อยู่? 💪 #ผู้ประกอบการ #ความท้าทาย #การเปลี่ยนแปลง',
    };

    final generatedContent =
        contentTemplates[_selectedTone] ?? contentTemplates['professional']!;

    setState(() {
      _isGenerating = false;
    });

    widget.onContentGenerated(generatedContent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'auto_awesome',
                  color: AppTheme.accentPrimary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'AI ช่วยเขียนเนื้อหา',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: widget.onClose,
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tone Selection
                  Text(
                    'เลือกโทนเสียง',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Column(
                    children: _toneOptions.map((tone) {
                      final isSelected = _selectedTone == tone['id'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTone = tone['id']),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.accentPrimary.withValues(alpha: 0.1)
                                : AppTheme.primaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.accentPrimary
                                  : AppTheme.borderSubtle,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.accentPrimary
                                      : AppTheme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: tone['icon'],
                                  color: isSelected
                                      ? AppTheme.textPrimary
                                      : AppTheme.textSecondary,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tone['name'],
                                      style: AppTheme
                                          .darkTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppTheme.accentPrimary
                                            : AppTheme.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      tone['description'],
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: AppTheme.accentPrimary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Hashtag Suggestions
                  Text(
                    'แฮชแท็กแนะนำ',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _hashtagSuggestions.map((hashtag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                AppTheme.accentPrimary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          hashtag,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Optimal Posting Times
                  Text(
                    'เวลาโพสต์ที่เหมาะสม',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Column(
                    children: _optimalTimes.map((timeData) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 2.h),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.borderSubtle,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme.success,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        timeData['time'],
                                        style: AppTheme
                                            .darkTheme.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme.success
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          timeData['engagement'],
                                          style: AppTheme
                                              .darkTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.success,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    '${timeData['platform']} - ${timeData['reason']}',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Generate Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateContent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPrimary,
                  foregroundColor: AppTheme.textPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isGenerating
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
                            'กำลังสร้างเนื้อหา...',
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
                            iconName: 'auto_awesome',
                            color: AppTheme.textPrimary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'สร้างเนื้อหา',
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
        ],
      ),
    );
  }
}
