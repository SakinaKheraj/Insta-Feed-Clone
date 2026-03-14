import 'package:flutter/material.dart';
import 'package:insta_feed_clone/models/post_model.dart';
import 'package:insta_feed_clone/services/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  
  List<PostModel> _posts = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;

  PostProvider(this._repository);

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    _posts = await _repository.fetchPosts(page: _currentPage);
    
    if (_posts.isEmpty || _posts.length < 10) {
      _hasMore = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    if (_isFetchingMore || !_hasMore) return;
    
    _isFetchingMore = true;
    notifyListeners();

    _currentPage++;
    final morePosts = await _repository.fetchPosts(page: _currentPage);
    
    if (morePosts.isEmpty) {
      _hasMore = false;
    } else {
      _posts.addAll(morePosts);
      if (morePosts.length < 10) {
        _hasMore = false;
      }
    }
    
    _isFetchingMore = false;
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      notifyListeners();
    }
  }

  void toggleSave(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(isSaved: !post.isSaved);
      notifyListeners();
    }
  }
}