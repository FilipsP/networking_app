//not used
import 'package:firebase_database/firebase_database.dart';

class PostDTO {
  String author;
  String authorId;
  String postId;
  String body;
  String title;
  int time;
  int likes;
  List<String> tags;

  PostDTO({
    required this.author,
    required this.authorId,
    required this.postId,
    required this.body,
    required this.title,
    required this.time,
    required this.likes,
    required this.tags,
  });

  factory PostDTO.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;

    return PostDTO(
      author: data['author'] as String,
      authorId: data['authorId'] as String,
      postId: data['postId'] as String,
      body: data['body'] as String,
      title: data['title'] as String,
      time: data['time'] as int,
      likes: data['likes'] as int,
      tags: List<String>.from(data['tags'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'authorId': authorId,
      'postId': postId,
      'body': body,
      'title': title,
      'time': time,
      'likes': likes,
      'tags': tags,
    };
  }
}
