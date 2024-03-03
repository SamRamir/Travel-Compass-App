/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
model_class.dart
 */

/// Represents a post in the community forum.
class Post {
  /// The username of the user who created the post.
  final String username;

  /// The title of the post.
  final String title;

  /// The content of the post.
  final String content;

  /// The number of likes the post has received.
  int likes;

  /// Indicates whether the current user has liked the post.
  bool isLiked;

  /// The date and time when the post was created.
  DateTime postDateTime;

  /// Constructs a [Post] with the specified parameters.
  ///
  /// The [username], [title], and [content] are required parameters. The [likes]
  /// and [isLiked] parameters have default values of 0 and false, respectively.
  /// The [postDateTime] parameter should be provided to initialize the post creation time.
  Post({
    required this.username,
    required this.title,
    required this.content,
    this.likes = 0,
    this.isLiked = false,
    required this.postDateTime,
  });
}
