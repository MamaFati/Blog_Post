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

class _ViewPostPageState extends State<ViewPostPage> {
  final _commentController = TextEditingController();
  String _replyingToCommentId = '';

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final updatedPost =
        postProvider.allPosts.firstWhere((p) => p.id == widget.post.id);

    bool isImage = updatedPost.filePath != null &&
        (updatedPost.filePath!.endsWith('.jpg') ||
            updatedPost.filePath!.endsWith('.png'));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Detail"),
        actions: [
          if (updatedPost.author == "user@example.com") ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditPostPage(post: updatedPost),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Post"),
                    content: const Text(
                        "Are you sure you want to delete this post?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          postProvider.deletePost(updatedPost.id);
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(updatedPost.filePath!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                else if (updatedPost.filePath != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text("📎 ${updatedPost.filePath!.split('/').last}"),
                  ),
                const SizedBox(height: 10),

                // Content
                Text(
                  updatedPost.content,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  "By ${updatedPost.author} • ${updatedPost.timestamp.toLocal().toString().substring(0, 16)}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Likes
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color:
                            updatedPost.likes > 0 ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          updatedPost.likes++;
                          updatedPost.save();
                        });
                      },
                    ),
                    Text("${updatedPost.likes} Likes"),
                  ],
                ),
                const SizedBox(height: 10),

                // Make Public Button (only if private & author)
                if (!updatedPost.isPublic &&
                    updatedPost.author == "user@example.com")
                  SizedBox(
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
                          const SnackBar(content: Text("Post is now public!")),
                        );
                      },
                    ),
                  ),
                const Divider(),

                // Comments Section
                const Text(
                  "Comments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                ...updatedPost.comments.map((comment) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.text),
                            Text(
                              "— ${comment.author}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _replyingToCommentId = comment.id;
                                });
                              },
                              child: const Text("Reply"),
                            ),
                            if (comment.replies.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: comment.replies
                                      .map((reply) => Text(
                                          "↳ ${reply.text} — ${reply.author}"))
                                      .toList(),
                                ),
                              )
                          ],
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
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: _replyingToCommentId.isEmpty
                    ? "Add a comment..."
                    : "Replying...",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
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
            },
          )
        ],
      ),
    );
  }
}
