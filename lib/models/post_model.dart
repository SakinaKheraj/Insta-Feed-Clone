class PostModel {
  final String id;
  final String username;
  final String userAvatar;
  final String imageUrl;
  final String caption;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isVerified;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isVerified,
    required this.timestamp,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      imageUrl: json['imageUrl'],
      caption: json['caption'],
      likes: json['likes'],
      comments: json['comments'],
      isLiked: json['isLiked'],
      isVerified: json['isVerified'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userAvatar': userAvatar,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'isLiked': isLiked,
      'isVerified': isVerified,
      'timestamp': timestamp,
    };
  }
}
