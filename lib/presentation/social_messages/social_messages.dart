import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/social_messages_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_error_widget.dart';
import './widgets/ai_response_suggestions.dart';
import './widgets/conversation_view.dart';
import './widgets/message_list_item.dart';
import './widgets/message_search_bar.dart';
import './widgets/messages_header.dart';
import './widgets/platform_filter_chips.dart';
import 'widgets/ai_response_suggestions.dart';
import 'widgets/conversation_view.dart';
import 'widgets/message_list_item.dart';
import 'widgets/message_search_bar.dart';
import 'widgets/messages_header.dart';
import 'widgets/platform_filter_chips.dart';

class SocialMessages extends StatefulWidget {
  const SocialMessages({super.key});

  @override
  State<SocialMessages> createState() => _SocialMessagesState();
}

class _SocialMessagesState extends State<SocialMessages>
    with TickerProviderStateMixin {
  final SocialMessagesService _messagesService = SocialMessagesService.instance;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _filteredMessages = [];
  Map<String, dynamic>? _selectedConversation;

  String _selectedPlatform = 'all';
  String _selectedFilter = 'all'; // all, unread, priority
  int _unreadCount = 0;
  bool _isLoading = true;
  bool _showPriorityOnly = false;
  String? _error;

  final List<String> _platforms = [
    'all',
    'facebook',
    'instagram',
    'twitter',
    'linkedin'
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadUnreadCount();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Map<String, dynamic>> messages;

      if (_showPriorityOnly) {
        messages = await _messagesService.getPriorityMessages();
      } else if (_selectedPlatform == 'all') {
        messages = await _messagesService.getAllMessages();
      } else {
        messages =
            await _messagesService.getMessagesByPlatform(_selectedPlatform);
      }

      setState(() {
        _messages = messages;
        _filteredMessages = messages;
        _isLoading = false;
      });

      _applyFilters();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await _messagesService.getUnreadMessageCount();
      setState(() => _unreadCount = count);
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_messages);

    // Apply status filter
    if (_selectedFilter == 'unread') {
      filtered = filtered.where((msg) => msg['status'] == 'unread').toList();
    } else if (_selectedFilter == 'priority') {
      // Simulate priority filtering (in real app this would use AI analysis)
      filtered = filtered
          .where((msg) =>
              msg['status'] == 'unread' &&
              (msg['content'].toString().toLowerCase().contains('urgent') ||
                  msg['content']
                      .toString()
                      .toLowerCase()
                      .contains('important')))
          .toList();
    }

    setState(() => _filteredMessages = filtered);
  }

  void _onPlatformFilterChanged(String platform) {
    setState(() => _selectedPlatform = platform);
    _loadMessages();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() => _filteredMessages = _messages);
      return;
    }

    final filtered = _messages
        .where((msg) =>
            msg['content']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            msg['sender_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();

    setState(() => _filteredMessages = filtered);
  }

  void _onMessageTap(Map<String, dynamic> message) {
    setState(() => _selectedConversation = message);

    // Mark as read if unread
    if (message['status'] == 'unread') {
      _markMessageAsRead(message['id']);
    }

    // Show conversation in modal
    _showConversationModal(message);
  }

  void _showConversationModal(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConversationView(
        message: message,
        onSendReply: (content) => _sendReply(message, content),
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _markMessageAsRead(String messageId) async {
    final success = await _messagesService.markAsRead(messageId);
    if (success) {
      setState(() {
        final index = _messages.indexWhere((msg) => msg['id'] == messageId);
        if (index != -1) {
          _messages[index]['status'] = 'read';
        }
      });
      _loadUnreadCount();
      _applyFilters();
    }
  }

  Future<void> _sendReply(Map<String, dynamic> message, String content) async {
    final success = await _messagesService.sendReply(
      message['thread_id'] ?? message['id'],
      content,
      message['platform'],
    );

    if (success) {
      await _messagesService.markAsReplied(message['id']);
      Navigator.pop(context);
      _loadMessages();
      _loadUnreadCount();

      Fluttertoast.showToast(
        msg: "Reply sent successfully!",
        backgroundColor: AppTheme.success,
        textColor: AppTheme.textPrimary,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to send reply",
        backgroundColor: AppTheme.error,
        textColor: AppTheme.textPrimary,
      );
    }
  }

  void _togglePriorityFilter() {
    setState(() {
      _showPriorityOnly = !_showPriorityOnly;
      _selectedFilter = _showPriorityOnly ? 'priority' : 'all';
    });
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: Center(
          child: CustomErrorWidget(
            errorDetails: FlutterErrorDetails(
              exception: Exception(_error),
              library: 'Social Messages',
              context: ErrorDescription('Failed to load messages'),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: MessagesHeader(
        unreadCount: _unreadCount,
        onBackPressed: () => Navigator.pop(context),
        onPriorityToggle: _togglePriorityFilter,
        showPriorityOnly: _showPriorityOnly,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: MessageSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
          ),

          // Platform Filter Chips
          PlatformFilterChips(
            platforms: _platforms,
            selectedPlatform: _selectedPlatform,
            onPlatformChanged: _onPlatformFilterChanged,
          ),

          SizedBox(height: 16.h),

          // Messages List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentPrimary,
                    ),
                  )
                : _filteredMessages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message_outlined,
                              size: 64.sp,
                              color: AppTheme.textSecondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              _showPriorityOnly
                                  ? 'No priority messages found'
                                  : 'No messages found',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: _filteredMessages.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final message = _filteredMessages[index];
                          return MessageListItem(
                            message: message,
                            onTap: () => _onMessageTap(message),
                            onMarkAsRead: () =>
                                _markMessageAsRead(message['id']),
                            onArchive: () async {
                              final success = await _messagesService
                                  .archiveMessage(message['id']);
                              if (success) {
                                _loadMessages();
                                _loadUnreadCount();
                              }
                            },
                          );
                        },
                      ),
          ),

          // AI Response Suggestions (when conversation is selected)
          if (_selectedConversation != null)
            AiResponseSuggestions(
              message: _selectedConversation!,
              onSuggestionTap: (suggestion) {
                _sendReply(_selectedConversation!, suggestion);
              },
            ),
        ],
      ),
    );
  }
}