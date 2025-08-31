import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TroubleshootingWidget extends StatefulWidget {
  const TroubleshootingWidget({Key? key}) : super(key: key);

  @override
  State<TroubleshootingWidget> createState() => _TroubleshootingWidgetState();
}

class _TroubleshootingWidgetState extends State<TroubleshootingWidget> {
  final List<Map<String, dynamic>> troubleshootingItems = [
    {
      'title': 'ไม่สามารถเชื่อมต่อ Facebook ได้',
      'content':
          '''• ตรวจสอบว่าคุณได้เข้าสู่ระบบ Facebook ในเบราว์เซอร์แล้ว • ลองล้างข้อมูล cache และ cookies ของเบราว์เซอร์ • ตรวจสอบการตั้งค่าความเป็นส่วนตัวของ Facebook • หากยังไม่ได้ ลองใช้เบราว์เซอร์อื่น''',
      'isExpanded': false,
    },
    {
      'title': 'Instagram ขึ้นข้อผิดพลาด "Token หมดอายุ"',
      'content':
          '''• กดปุ่ม "เชื่อมต่อใหม่" ในการ์ด Instagram • ตรวจสอบว่าบัญชี Instagram เป็นบัญชีธุรกิจ • ลองออกจากระบบ Instagram แล้วเข้าใหม่ • รอสักครู่แล้วลองใหม่อีกครั้ง''',
      'isExpanded': false,
    },
    {
      'title': 'Twitter/X ไม่แสดงข้อมูลที่ถูกต้อง',
      'content':
          '''• รอให้ระบบซิงค์ข้อมูลประมาณ 2-3 นาที • กดปุ่มรีเฟรชที่มุมขวาบน • ตรวจสอบว่าบัญชี Twitter/X ไม่ถูกระงับ • ลองยกเลิกการเชื่อมต่อแล้วเชื่อมต่อใหม่''',
      'isExpanded': false,
    },
    {
      'title': 'LinkedIn ไม่อนุญาตให้โพสต์',
      'content':
          '''• ตรวจสอบสิทธิ์การเข้าถึงที่ให้กับแอป • บัญชี LinkedIn ต้องเป็นบัญชีที่ยืนยันแล้ว • ตรวจสอบว่าเนื้อหาไม่ขัดต่อนโยบาย LinkedIn • ลองเชื่อมต่อใหม่และให้สิทธิ์ครบถ้วน''',
      'isExpanded': false,
    },
    {
      'title': 'TikTok หรือ YouTube ไม่ปรากฏในรายการ',
      'content':
          '''• ตรวจสอบว่าแอปเป็นเวอร์ชันล่าสุด • บางแพลตฟอร์มอาจไม่รองรับในบางภูมิภาค • ลองรีสตาร์ทแอปแล้วลองใหม่ • ติดต่อทีมสนับสนุนหากปัญหายังคงอยู่''',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'help_outline',
                  color: AppTheme.warning,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'แก้ไขปัญหาการเชื่อมต่อ',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: troubleshootingItems.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.borderSubtle,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = troubleshootingItems[index];
              return ExpansionTile(
                title: Text(
                  item['title'],
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: CustomIconWidget(
                  iconName: item['isExpanded'] ? 'expand_less' : 'expand_more',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
                trailing: const SizedBox.shrink(),
                tilePadding: EdgeInsets.symmetric(horizontal: 4.w),
                childrenPadding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
                onExpansionChanged: (expanded) {
                  setState(() {
                    troubleshootingItems[index]['isExpanded'] = expanded;
                  });
                },
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.warning.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      item['content'],
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Container(
              width: double.infinity,
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
                    iconName: 'info',
                    color: AppTheme.accentPrimary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'หากยังคงมีปัญหา กรุณาติดต่อทีมสนับสนุนผ่านเมนู "ช่วยเหลือ"',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
