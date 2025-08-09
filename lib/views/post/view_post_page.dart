import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import '../../providers/post_provider.dart';
import 'edit_post_page.dart';

class ViewPostPage extends StatefulWidget {
  final PostModel post;
  const ViewPostPage({super.key, required this.post});

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage>
    with SingleTickerProviderStateMixin {
  final _commentController = TextEditingController();
  String _replyingToCommentId = '';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final updatedPost =
        postProvider.allPosts.firstWhere((p) => p.id == widget.post.id);
    final theme = Theme.of(context);

    bool isImage = updatedPost.filePath != null &&
        (updatedPost.filePath!.endsWith('.jpg') ||
            updatedPost.filePath!.endsWith('.png'));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post Detail",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 4,
        actions: [
          if (updatedPost.author == "user@example.com") ...[
            ScaleTransition(
              scale: _scaleAnimation,
              child: IconButton(
                icon: Icon(Icons.edit, color: theme.colorScheme.onBackground),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPostPage(post: updatedPost),
                    ),
                  );
                },
                tooltip: "Edit Post",
              ),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: IconButton(
                icon: Icon(Icons.delete, color: theme.colorScheme.error),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        "Delete Post",
                        style: theme.textTheme.titleLarge,
                      ),
                      content: Text(
                        "Are you sure you want to delete this post?",
                        style: theme.textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            postProvider.deletePost(updatedPost.id);
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: theme.colorScheme.onError,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                tooltip: "Delete Post",
              ),
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Image preview
                if (isImage)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(updatedPost.filePath!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: theme.colorScheme.surface,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (updatedPost.filePath != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "📎 ${updatedPost.filePath!.split('/').last}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // Content
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    updatedPost.content,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "By ${updatedPost.author} • ${updatedPost.timestamp.toLocal().toString().substring(0, 16)}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),

                // Likes
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            color: updatedPost.likes > 0
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                            setState(() {
                              updatedPost.likes++;
                              updatedPost.save();
                            });
                            postProvider.notifyListeners();
                          },
                        ),
                      ),
                      Text(
                        "${updatedPost.likes} Likes",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Make Public Button (only if private & author)
                if (!updatedPost.isPublic &&
                    updatedPost.author == "user@example.com")
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.public),
                          label: const Text("Make Public"),
                          onPressed: () {
                            setState(() {
                              updatedPost.isPublic = true;
                              updatedPost.save();
                            });
                            postProvider.notifyListeners();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Post is now public!",
                                  style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                  ),
                                ),
                                backgroundColor: theme.colorScheme.surface,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                const Divider(),

                // Comments Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "Comments",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                ...updatedPost.comments.map((comment) => FadeTransition(
                      opacity: _fadeAnimation,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.text,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onBackground,
                                ),
                              ),
                              Text(
                                "— ${comment.author}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _replyingToCommentId = comment.id;
                                    });
                                  },
                                  child: Text(
                                    "Reply",
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              if (comment.replies.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: comment.replies
                                        .map((reply) => Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Text(
                                                "↳ ${reply.text} — ${reply.author}",
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme
                                                      .colorScheme.onBackground
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 80), // space for input field
              ],
            ),
          ),

          // Comment Input
          _buildCommentInput(postProvider, updatedPost.id),
        ],
      ),
    );
  }

  Widget _buildCommentInput(PostProvider postProvider, String postId) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: _replyingToCommentId.isEmpty
                    ? "Add a comment..."
                    : "Replying...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surface.withOpacity(0.8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ScaleTransition(
            scale: _scaleAnimation,
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                final text = _commentController.text.trim();
                if (text.isEmpty) return;

                if (_replyingToCommentId.isEmpty) {
                  postProvider.addComment(postId, "user@example.com", text);
                } else {
                  postProvider.addReply(
                      postId, _replyingToCommentId, "user@example.com", text);
                  _replyingToCommentId = '';
                }

                _commentController.clear();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
