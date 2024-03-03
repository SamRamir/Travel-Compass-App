/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
provider.dart
 */

import 'package:flutter/cupertino.dart';

import 'model_class.dart'; // Import the required model class

/// A provider class that manages the community posts and their interactions.
class CommunityProvider with ChangeNotifier {
  List<Post> _posts = [];

  /// Gets the list of community posts.
  List<Post> get posts => _posts;

  /// Adds a new post to the list of community posts.
  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }

  /// Toggles the like status of a post and updates the like count.
  void toggleLike(Post post) {
    post.isLiked = !post.isLiked;
    if (post.isLiked) {
      post.likes++;
    } else {
      post.likes--;
    }
    notifyListeners();
  }
}
