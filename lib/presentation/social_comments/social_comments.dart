import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/comment_service.dart';
import './widgets/ai_moderation_panel_widget.dart';
import './widgets/bulk_actions_bar_widget.dart';
import './widgets/comment_card_widget.dart';
import './widgets/comment_stats_widget.dart';
import './widgets/filter_panel_widget.dart';
import './widgets/quick_reply_modal_widget.dart';
import 'widgets/ai_moderation_panel_widget.dart';
import 'widgets/bulk_actions_bar_widget.dart';
import 'widgets/comment_card_widget.dart';
import 'widgets/comment_stats_widget.dart';
import 'widgets/filter_panel_widget.dart';
import 'widgets/quick_reply_modal_widget.dart';

class SocialComments extends StatefulWidget {
  const SocialComments({Key? key}) : super(key: key);

  @override
  State<SocialComments> createState() => _SocialCommentsState();
}

class _SocialCommentsState extends State<SocialComments> {
  List<dynamic> _comments = [];
  List<String> _selectedCommentIds = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  bool _isSelectionMode = false;
  String _currentFilter = 'all';
  String _currentSentiment = 'all';
  String _currentStatus = 'all';
  String _searchKeyword = '';
  String _sortBy = 'created_at';
  bool _sortAscending = false;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadComments();
    _loadStats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    try {
      final comments = await CommentService.getComments(
        platformFilter: _currentFilter != 'all' ? _currentFilter : null,
        sentimentFilter: _currentSentiment != 'all' ? _currentSentiment : null,
        statusFilter: _currentStatus != 'all' ? _currentStatus : null,
        searchKeyword: _searchKeyword.isNotEmpty ? _searchKeyword : null,
        sortBy: _sortBy,
        ascending: _sortAscending,
      );

      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to load comments: ${e.toString()}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await CommentService.getCommentStats();
      setState(() => _stats = stats);
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to load stats: ${e.toString()}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _onFilterChanged(String type, String value) {
    setState(() {
      switch (type) {
        case 'platform':
          _currentFilter = value;
          break;
        case 'sentiment':
          _currentSentiment = value;
          break;
        case 'status':
          _currentStatus = value;
          break;
      }
    });
    _loadComments();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchKeyword = query);
    Future.delayed(const Duration(milliseconds: 500), _loadComments);
  }

  void _onSortChanged(String sortBy, bool ascending) {
    setState(() {
      _sortBy = sortBy;
      _sortAscending = ascending;
    });
    _loadComments();
  }

  void _toggleSelection(String commentId) {
    setState(() {
      if (_selectedCommentIds.contains(commentId)) {
        _selectedCommentIds.remove(commentId);
      } else {
        _selectedCommentIds.add(commentId);
      }
      _isSelectionMode = _selectedCommentIds.isNotEmpty;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedCommentIds.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _handleBulkAction(String action) async {
    if (_selectedCommentIds.isEmpty) return;

    try {
      await CommentService.bulkUpdateComments(_selectedCommentIds, action);
      _clearSelection();
      await _loadComments();
      await _loadStats();

      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Bulk action completed successfully',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Bulk action failed: ${e.toString()}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _showQuickReply(Map<String, dynamic> comment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickReplyModalWidget(
        comment: comment,
        onReply: (replyContent) async {
          try {
            await CommentService.replyToComment(comment['id'], replyContent);
            await _loadComments();
            Navigator.pop(context);

            if (mounted) {
              Fluttertoast.showToast(
                msg: 'Reply sent successfully',
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            }
          } catch (e) {
            if (mounted) {
              Fluttertoast.showToast(
                msg: 'Failed to send reply: ${e.toString()}',
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _handleCommentAction(String commentId, String action) async {
    try {
      await CommentService.updateCommentStatus(commentId, action);
      await _loadComments();
      await _loadStats();

      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Comment ${action.toLowerCase()} successfully',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to ${action.toLowerCase()} comment: ${e.toString()}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Social Comments',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E3192),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CommentSearchDelegate(
                  onSearchChanged: _onSearchChanged,
                  currentQuery: _searchKeyword,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isSelectionMode ? Icons.close : Icons.select_all,
              color: Colors.white,
            ),
            onPressed: () {
              if (_isSelectionMode) {
                _clearSelection();
              } else {
                setState(() => _isSelectionMode = true);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Overview
          CommentStatsWidget(stats: _stats),

          // Filter Panel
          FilterPanelWidget(
            currentFilter: _currentFilter,
            currentSentiment: _currentSentiment,
            currentStatus: _currentStatus,
            sortBy: _sortBy,
            sortAscending: _sortAscending,
            onFilterChanged: _onFilterChanged,
            onSortChanged: _onSortChanged,
          ),

          // Comments List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          final isSelected =
                              _selectedCommentIds.contains(comment['id']);

                          return CommentCardWidget(
                            comment: comment,
                            isSelected: isSelected,
                            isSelectionMode: _isSelectionMode,
                            onTap: () => _toggleSelection(comment['id']),
                            onReply: () => _showQuickReply(comment),
                            onModerate: (action) =>
                                _handleCommentAction(comment['id'], action),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomSheet: _isSelectionMode && _selectedCommentIds.isNotEmpty
          ? BulkActionsBarWidget(
              selectedCount: _selectedCommentIds.length,
              onApprove: () => _handleBulkAction('approved'),
              onHide: () => _handleBulkAction('hidden'),
              onDelete: () => _handleBulkAction('deleted'),
              onCancel: _clearSelection,
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AiModerationPanelWidget(
              onAutoModerate: () async {
                try {
                  for (String commentId in _selectedCommentIds.isNotEmpty
                      ? _selectedCommentIds
                      : _comments.map((c) => c['id'] as String).toList()) {
                    await CommentService.runAutoModeration(commentId);
                  }
                  await _loadComments();
                  await _loadStats();
                  Navigator.pop(context);

                  if (mounted) {
                    Fluttertoast.showToast(
                      msg: 'Auto-moderation completed',
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Fluttertoast.showToast(
                      msg: 'Auto-moderation failed: ${e.toString()}',
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                }
              },
            ),
          );
        },
        backgroundColor: const Color(0xFF2E3192),
        child: const Icon(Icons.psychology, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment_outlined,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 2.h),
          Text(
            'No comments found',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchKeyword.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Comments will appear here when available',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CommentSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearchChanged;
  final String currentQuery;

  CommentSearchDelegate({
    required this.onSearchChanged,
    required this.currentQuery,
  });

  @override
  String get searchFieldLabel => 'Search comments...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearchChanged('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, query);
        onSearchChanged(query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchChanged(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'positive comments',
      'negative feedback',
      'spam detection',
      'pending moderation',
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            onSearchChanged(query);
            close(context, query);
          },
        );
      },
    );
  }
}