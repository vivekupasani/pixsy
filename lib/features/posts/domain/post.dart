import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixsy/features/posts/domain/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "username": userName,
      "text": text,
      "imageUrl": imageUrl,
      "timestamp": Timestamp.fromDate(timestamp),
      "likes": likes,
      "comments": comments.map((e) => e.toJson()).toList(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((e) => Comment.fromJson(e))
            .toList() ??
        [];

    return Post(
      id: json["id"],
      userId: json["userId"],
      userName: json["username"],
      text: json["text"],
      imageUrl: json["imageUrl"],
      timestamp: (json["timestamp"] as Timestamp).toDate(),
      likes: List<String>.from(json["likes"]),
      comments: comments,
    );
  }
}
