import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class BulkActionsBarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onApprove;
  final VoidCallback onHide;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const BulkActionsBarWidget({
    Key? key,
    required this.selectedCount,
    required this.onApprove,
    required this.onHide,
    required this.onDelete,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection Counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2E3192).withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2E3192).withAlpha(77),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF2E3192),
                  size: 16.sp,
                ),
                SizedBox(width: 1.w),
                Text(
                  '$selectedCount Selected',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E3192),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Action Buttons
          Row(
            children: [
              // Approve Button
              _buildActionButton(
                'Approve',
                Icons.check,
                Colors.green,
                onApprove,
              ),

              SizedBox(width: 2.w),

              // Hide Button
              _buildActionButton(
                'Hide',
                Icons.visibility_off,
                Colors.orange,
                onHide,
              ),

              SizedBox(width: 2.w),

              // Delete Button
              _buildActionButton(
                'Delete',
                Icons.delete_outline,
                Colors.red,
                () => _showBulkDeleteConfirmation(context),
              ),

              SizedBox(width: 3.w),

              // Cancel Button
              _buildActionButton(
                'Cancel',
                Icons.close,
                Colors.grey[600]!,
                onCancel,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(26),
        foregroundColor: color,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withAlpha(77)),
        ),
        minimumSize: Size(0, 5.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp),
          SizedBox(width: 1.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showBulkDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Bulk Delete Comments',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to delete $selectedCount comment${selectedCount > 1 ? 's' : ''}? This action cannot be undone.',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(
                'Delete All',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}