/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
create_post_form.dart
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model_class.dart';
import 'provider.dart';

/// A form for creating a new post.
class CreatePostForm extends StatefulWidget {
  /// The provider for managing community data.
  final CommunityProvider communityProvider;

  /// Constructs a [CreatePostForm] with the specified [communityProvider].
  CreatePostForm(this.communityProvider);

  @override
  _CreatePostFormState createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap the content in a SingleChildScrollView to allow scrolling when the keyboard is shown.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createPost(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  /// Generates a random username based on the current timestamp.
  String _generateRandomUsername() {
    final String baseUsername = 'user';
    final int randomSuffix = DateTime.now().millisecondsSinceEpoch % 10000;
    return '$baseUsername$randomSuffix';
  }

  /// Creates a new post and adds it to the community.
  void _createPost(BuildContext context) {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final String username = _generateRandomUsername(); // Generate random username
    final Post newPost = Post(
      title: title,
      content: content,
      likes: 0,
      username: username,
      postDateTime: DateTime.now(),
    );

    widget.communityProvider.addPost(newPost); // Add the new post using the provided provider.

    Navigator.pop(context); // Close the dialog after submitting the post.
  }
}
