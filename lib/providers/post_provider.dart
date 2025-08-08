import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  late Box<PostModel> _postBox;

  PostProvider() {
    _postBox = Hive.box<PostModel>('posts');
  }

  List<PostModel> get allPosts => _postBox.values.toList();

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

    _postBox.put(newPost.id, newPost);
    notifyListeners();
  }

  void deletePost(String id) {
    _postBox.delete(id);
    notifyListeners();
  }

  void addComment(String postId, String author, String text) {
    final post = _postBox.get(postId);
    if (post != null) {
      post.comments = [
        ...post.comments,
        Comment(id: const Uuid().v4(), author: author, text: text)
      ];
      post.save();
      notifyListeners();
    }
  }

  void addReply(String postId, String commentId, String author, String text) {
    final post = _postBox.get(postId);
    if (post != null) {
      final commentIndex = post.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = post.comments[commentIndex];
        comment.replies = [
          ...comment.replies,
          Reply(id: const Uuid().v4(), author: author, text: text)
        ];
        post.comments[commentIndex] = comment;
        post.save();
        notifyListeners();
      }
    }
  }

  void updatePost(String id, String newContent,
      {String? newFilePath, bool? isPublic}) {
    final post = _postBox.get(id);
    if (post != null) {
      post.content = newContent;
      if (newFilePath != null) post.filePath = newFilePath;
      if (isPublic != null) post.isPublic = isPublic;
      post.save();
      notifyListeners();
    }
  }
}
