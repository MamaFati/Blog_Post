class PostModel {
  final String id;
  final String content;
  final String? filePath;
  final DateTime timestamp;
  final String author;
  final bool isPublic;
  int likes;
  List<Comment> comments;

  PostModel({
    required this.id,
    required this.content,
    this.filePath,
    required this.timestamp,
    required this.author,
    required this.isPublic,
    this.likes = 0,
    this.comments = const [],
  });
}

class Comment {
  final String id;
  final String author;
  final String text;
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    this.replies = const [],
  });
}

class Reply {
  final String id;
  final String author;
  final String text;

  Reply({
    required this.id,
    required this.author,
    required this.text,
  });
}
