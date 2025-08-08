import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import '../../providers/post_provider.dart';
import '../post/view_post_page.dart';

class ArchivesPage extends StatelessWidget {
  const ArchivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.allPosts
        .where((p) => !p.isPublic && p.author == "user@example.com")
        .toList();

    return posts.isEmpty
        ? const Center(child: Text("No archived posts"))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final PostModel post = posts[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    post.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "By ${post.author} • ${post.timestamp.toLocal().toString().substring(0, 16)}",
                  ),
                  trailing: const Icon(Icons.lock_outline),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewPostPage(post: post),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
