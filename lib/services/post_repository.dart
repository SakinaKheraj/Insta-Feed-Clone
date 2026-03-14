import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:insta_feed_clone/models/post_model.dart';

class PostRepository {
  Future<List<PostModel>> fetchPosts({int page = 1, int limit = 10}) async {
    // Force a 1.5-second delay to demonstrate Loading State
    await Future.delayed(const Duration(milliseconds: 1500));
    
    try {
      final String response = await rootBundle.loadString('assets/data/posts.json');
      final List<dynamic> data = json.decode(response);
      List<PostModel> allPosts = data.map((json) => PostModel.fromJson(json)).toList();
      
      // Implement pagination slice
      int startIndex = (page - 1) * limit;
      if (startIndex >= allPosts.length) {
        return [];
      }
      int endIndex = startIndex + limit;
      if (endIndex > allPosts.length) {
        endIndex = allPosts.length;
      }
      
      return allPosts.sublist(startIndex, endIndex);
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}