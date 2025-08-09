import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/theme_provider.dart';
import '../../routes/app_routes.dart';
import '../../models/post_model.dart';
import '../post/view_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final posts = postProvider.allPosts.where((post) => post.isPublic).toList();
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor.withOpacity(0.8),
                
                  Colors.blue.shade900,
                ],
              ),
            ),
          ),
          // Subtle Particle Effect
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chips
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    _buildCategoryChip("UI Design", true),
                    _buildCategoryChip("UX Design", false),
                    _buildCategoryChip("Visual Design", false),
                    _buildCategoryChip("Development", false),
                  ],
                ),
              ),
              // Posts List
              Expanded(
                child: posts.isEmpty
                    ? Center(
                        child: Text(
                          "No public posts yet.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final PostModel post = posts[index];
                          final bool isImage = post.filePath != null &&
                              (post.filePath!.endsWith('.jpg') ||
                                  post.filePath!.endsWith('.png'));

                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ViewPostPage(post: post),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.cardColor.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Author Row
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: theme.primaryColor,
                                          child: const Icon(Icons.person,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            post.author,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          post.timestamp
                                              .toLocal()
                                              .toString()
                                              .substring(0, 16),
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Image Preview
                                    if (isImage)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(post.filePath!),
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            height: 200,
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    // Title
                                    Text(
                                      post.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Like Button & Count
                                    Row(
                                      children: [
                                        ScaleTransition(
                                          scale: _scaleAnimation,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.thumb_up,
                                              color: post.likes > 0
                                                  ? theme.primaryColor
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              post.likes++;
                                              post.save();
                                              postProvider.notifyListeners();
                                            },
                                          ),
                                        ),
                                        Text(
                                          "${post.likes} Likes",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.createPost);
          },
          backgroundColor: theme.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Chip(
          label: Text(label),
          backgroundColor: selected
              ? Colors.blueAccent
              : Colors.grey.shade100.withOpacity(0.8),
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          elevation: selected ? 4 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selected ? Colors.blueAccent : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}
