class PostModel {
  final String id;
  final String username;
  final String userAvatar;
  final List<String> imageUrls;
  final String caption;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isSaved;
  final bool isVerified;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.imageUrls,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isSaved,
    required this.isVerified,
    required this.timestamp,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedImageUrls = [];
    if (json['imageUrls'] != null) {
      parsedImageUrls = List<String>.from(json['imageUrls']);
    } else if (json['imageUrl'] != null) {
      parsedImageUrls = [json['imageUrl']];
    }

    return PostModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      imageUrls: parsedImageUrls,
      caption: json['caption'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isSaved: json['isSaved'] ?? false,
      isVerified: json['isVerified'] ?? false,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userAvatar': userAvatar,
      'imageUrls': imageUrls,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'isVerified': isVerified,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  PostModel copyWith({
    int? likes,
    bool? isLiked,
    bool? isSaved,
  }) {
    return PostModel(
      id: id,
      username: username,
      userAvatar: userAvatar,
      imageUrls: imageUrls,
      caption: caption,
      likes: likes ?? this.likes,
      comments: comments,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isVerified: isVerified,
      timestamp: timestamp,
    );
  }
}
