import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import '../../providers/post_provider.dart';
import '../post/view_post_page.dart';

class ArchivesPage extends StatefulWidget {
  const ArchivesPage({super.key});

  @override
  State<ArchivesPage> createState() => _ArchivesPageState();
}

class _ArchivesPageState extends State<ArchivesPage>
    with SingleTickerProviderStateMixin {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.allPosts
        .where((p) => !p.isPublic && p.author == "user@example.com")
        .toList();
    final theme = Theme.of(context);

    return Scaffold(
      body: posts.isEmpty
          ? Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "No archived posts",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.8),
                    fontSize: 18,
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final PostModel post = posts[index];
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      color: theme.cardColor.withOpacity(0.9),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          post.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          "By ${post.author} • ${post.timestamp.toLocal().toString().substring(0, 16)}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        trailing: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Icon(
                            Icons.lock_outline,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewPostPage(post: post),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
