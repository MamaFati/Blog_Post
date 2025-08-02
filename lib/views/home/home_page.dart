import 'package:blog_post/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final username = "Fati";
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.allPosts;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog Posts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: posts.isEmpty
          ? const Center(child: Text("No posts yet. Click + to create one."))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final PostModel post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(post.content),
                    subtitle: Text(
                        "By ${post.author} • ${post.timestamp.toLocal().toString().substring(0, 16)}"),
                    trailing:
                        Icon(post.isPublic ? Icons.public : Icons.lock_outline),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createPost);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
