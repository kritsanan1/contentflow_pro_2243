import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MessageSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;

  const MessageSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search messages...',
  }) : super(key: key);

  @override
  State<MessageSearchBar> createState() => _MessageSearchBarState();
}

class _MessageSearchBarState extends State<MessageSearchBar> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _hasFocus ? AppTheme.accentPrimary : AppTheme.borderSubtle,
          width: _hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _hasFocus ? AppTheme.accentPrimary : AppTheme.textSecondary,
            size: 20.sp,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.textSecondary,
                    size: 20.sp,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w400,
        ),
        onTap: () => setState(() => _hasFocus = true),
        onEditingComplete: () => setState(() => _hasFocus = false),
        onSubmitted: (_) => setState(() => _hasFocus = false),
      ),
    );
  }
}