import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:insta_feed_clone/models/post_model.dart';

class PostRepository {
  Future<List<PostModel>> fetchPosts() async {
    try {
      final String response = await rootBundle.loadString('assets/data/posts.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  // Future<List<PostModel>> fetchStories() async {
  //   try {
  //     final String response = await rootBundle.loadString('assets/data/stories.json');
  //     final List<dynamic> data = json.decode(response);
  //     return data.map((json) => PostModel.fromJson(json)).toList();
  //   } catch (e) {
  //     print('Error fetching stories: $e');
  //     return [];
  //   }
  // }
}