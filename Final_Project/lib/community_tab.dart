/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
community_tab.dart
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'create_post_form.dart';
import 'model_class.dart';
import 'provider.dart';

/// Represents a tab displaying a community forum with posts and a create post button.
class CommunityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, communityProvider, child) {
        final List<Post> posts = communityProvider.posts;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showCreatePostDialog(context, communityProvider);
                },
                child: Text('Create Post'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        post.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Posted by: ${post.username}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Posted on: ${DateFormat('MMM dd, yyyy - hh:mm a').format(post.postDateTime)}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(post.content),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${post.likes} Likes',
                                style: TextStyle(color: Colors.grey),
                              ),
                              IconButton(
                                onPressed: () {
                                  communityProvider.toggleLike(post);
                                },
                                icon: Icon(
                                  post.isLiked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_alt,
                                  color: post.isLiked ? Colors.blue : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Displays a dialog for creating a new post.
  void _showCreatePostDialog(BuildContext context,
      CommunityProvider communityProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create a Post'),
          content: CreatePostForm(communityProvider),
        );
      },
    );
  }
}
