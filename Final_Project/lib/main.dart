/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
main.dart
 */

import 'package:flutter/material.dart';
import 'package:project/provider.dart'; // Import the necessary provider
import 'package:provider/provider.dart';
import 'main_screen.dart';

/// The entry point of the Flutter application.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityProvider>(
          create: (_) => CommunityProvider(), // Create and provide an instance of CommunityProvider
        ),
      ],
      child: Menu(), // Run the Menu widget as the root of the widget tree
    ),
  );
}
