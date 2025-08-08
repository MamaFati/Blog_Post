import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class PostModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  String? filePath;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String author;

  @HiveField(5)
  bool isPublic;

  @HiveField(6)
  int likes;

  @HiveField(7)
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

@HiveType(typeId: 1)
class Comment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String author;

  @HiveField(2)
  String text;

  @HiveField(3)
  List<Reply> replies;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    this.replies = const [],
  });
}

@HiveType(typeId: 2)
class Reply extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String author;

  @HiveField(2)
  String text;

  Reply({
    required this.id,
    required this.author,
    required this.text,
  });
}
