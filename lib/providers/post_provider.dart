import 'package:flutter/material.dart';
import 'package:insta_feed_clone/models/post_model.dart';
import 'package:insta_feed_clone/services/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  List<PostModel> _posts = [];
  bool _isLoading = false;

  PostProvider(this._repository);

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    _posts = await _repository.fetchPosts();
    _isLoading = false;
    notifyListeners();
  }

  
}