import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  final List<PostModel> _posts = [];

  List<PostModel> get allPosts => _posts;

  void addPost({
    required String content,
    String? filePath,
    required String author,
    required bool isPublic,
  }) {
    final newPost = PostModel(
      id: const Uuid().v4(),
      content: content,
      filePath: filePath,
      author: author,
      isPublic: isPublic,
      timestamp: DateTime.now(),
    );

    _posts.insert(0, newPost); // newest on top
    notifyListeners();
  }

  void deletePost(String id) {
    _posts.removeWhere((post) => post.id == id);
    notifyListeners();
  }
}
