import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AiResponseSuggestions extends StatefulWidget {
  final Map<String, dynamic> message;
  final Function(String) onSuggestionTap;

  const AiResponseSuggestions({
    Key? key,
    required this.message,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  State<AiResponseSuggestions> createState() => _AiResponseSuggestionsState();
}

class _AiResponseSuggestionsState extends State<AiResponseSuggestions> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isVisible = false;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _generateSuggestions();
    _showSuggestions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateSuggestions() {
    final content = widget.message['content']?.toString().toLowerCase() ?? '';
    final platform = widget.message['platform']?.toString().toLowerCase() ?? '';
    
    // Simulate AI-powered response generation based on message content and context
    List<String> suggestions = [];
    
    // Content-based suggestions
    if (content.contains('thank') || content.contains('thanks')) {
      suggestions.addAll([
        'You\'re welcome! Happy to help! 😊',
        'My pleasure! Let me know if you need anything else.',
        'Glad I could help!',
      ]);
    } else if (content.contains('help') || content.contains('support')) {
      suggestions.addAll([
        'I\'d be happy to help! What specific information do you need?',
        'Let me assist you with that. Could you provide more details?',
        'I\'m here to help! What can I do for you?',
      ]);
    } else if (content.contains('complain') || content.contains('problem') || content.contains('issue')) {
      suggestions.addAll([
        'I apologize for the inconvenience. Let me look into this right away.',
        'I understand your concern. I\'ll make sure this is resolved quickly.',
        'Thank you for bringing this to our attention. We\'ll fix this immediately.',
      ]);
    } else if (content.contains('question') || content.contains('?')) {
      suggestions.addAll([
        'Great question! Here\'s what I can tell you...',
        'Thanks for asking! Let me provide you with the information.',
        'I\'d be happy to answer that for you.',
      ]);
    } else if (content.contains('love') || content.contains('great') || content.contains('awesome')) {
      suggestions.addAll([
        'Thank you so much! Your support means everything to us! ❤️',
        'We\'re thrilled you love it! Thanks for the feedback! 🙌',
        'Your kind words made our day! Thank you! ✨',
      ]);
    } else {
      // Generic suggestions
      suggestions.addAll([
        'Thank you for your message! I\'ll get back to you shortly.',
        'Thanks for reaching out! How can I help you today?',
        'I appreciate you contacting us. What can I assist you with?',
      ]);
    }
    
    // Platform-specific adjustments
    switch (platform) {
      case 'instagram':
        suggestions = suggestions.map((s) => s + ' #InstaLove').take(3).toList();
        break;
      case 'twitter':
        suggestions = suggestions.map((s) => s.length > 200 ? s.substring(0, 200) + '...' : s).take(3).toList();
        break;
      case 'linkedin':
        suggestions = suggestions.map((s) => s.replaceAll('😊', '').replaceAll('❤️', '').replaceAll('🙌', '').replaceAll('✨', '')).take(3).toList();
        break;
    }
    
    setState(() {
      _suggestions = suggestions.take(3).toList();
    });
  }

  void _showSuggestions() {
    setState(() => _isVisible = true);
    _animationController.forward();
    
    // Auto-hide after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _hideSuggestions();
      }
    });
  }

  void _hideSuggestions() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || _suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100.h),
          child: Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: AppTheme.getElevationShadow(4),
              border: Border.all(
                color: AppTheme.accentPrimary.withAlpha(51),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPrimary.withAlpha(26),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.psychology,
                        color: AppTheme.accentPrimary,
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'AI Suggestions',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _hideSuggestions,
                      child: Icon(
                        Icons.close,
                        color: AppTheme.textSecondary,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                Text(
                  'Quick response suggestions based on the message content:',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                SizedBox(height: 12.h),
                
                // Suggestions List
                ..._suggestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final suggestion = entry.value;
                  
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: _SuggestionCard(
                      suggestion: suggestion,
                      index: index + 1,
                      onTap: () {
                        widget.onSuggestionTap(suggestion);
                        _hideSuggestions();
                      },
                    ),
                  );
                }).toList(),
                
                SizedBox(height: 8.h),
                
                // Footer
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.warning,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Tap any suggestion to use it as your response',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String suggestion;
  final int index;
  final VoidCallback onTap;

  const _SuggestionCard({
    required this.suggestion,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppTheme.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            // Index Number
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppTheme.accentPrimary.withAlpha(26),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  index.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppTheme.accentPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Suggestion Text
            Expanded(
              child: Text(
                suggestion,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
            
            // Action Icon
            Icon(
              Icons.send,
              color: AppTheme.accentPrimary,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}