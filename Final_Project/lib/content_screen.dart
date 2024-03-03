/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
content_screen.dart
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A screen that displays details for a specific location.
class LocationDetailsScreen extends StatelessWidget {
  /// The title of the location being displayed.
  final String locationTitle;

  /// Constructs a [LocationDetailsScreen] with the specified [locationTitle].
  LocationDetailsScreen({required this.locationTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationTitle), // Display the location title in the app bar.
      ),
      body: Center(
        child: Text('Location details for $locationTitle'), // Display location details centered on the screen.
      ),
    );
  }
}
