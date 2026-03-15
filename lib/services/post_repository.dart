import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:insta_feed_clone/models/post_model.dart';

class PostRepository {
  static List<PostModel>? _cachedPosts;

  Future<List<PostModel>> fetchPosts({int page = 1, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      _cachedPosts ??= await _loadBasePosts();
      final base = _cachedPosts!;

      if (base.isEmpty) return [];

      final startIndex = (page - 1) * limit;
      final List<PostModel> result = [];

      for (int i = 0; i < limit; i++) {
        final loopIndex = (startIndex + i) % base.length;
        final loopPass = (startIndex + i) ~/ base.length;
        final original = base[loopIndex];

        if (loopPass == 0) {
          result.add(original);
        } else {
          result.add(PostModel(
            id: '${original.id}_loop$loopPass',
            username: original.username,
            userAvatar: original.userAvatar,
            imageUrls: original.imageUrls,
            caption: original.caption,
            likes: original.likes,
            comments: original.comments,
            reshares: original.reshares,
            shares: original.shares,
            isLiked: original.isLiked,
            isSaved: original.isSaved,
            isVerified: original.isVerified,
            timestamp: original.timestamp,
          ));
        }
      }

      return result;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<List<PostModel>> _loadBasePosts() async {
    final String response =
        await rootBundle.loadString('assets/data/posts.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => PostModel.fromJson(json)).toList();
  }
}