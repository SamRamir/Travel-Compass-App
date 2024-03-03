/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
main_screen.dart
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trip_planning_screen.dart';
import 'community_tab.dart'; // Import your Community Tab widget
import 'provider.dart'; // Import your Provider class
import 'main_tab.dart';

/// The main application menu that displays different tabs for navigation.
class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: DefaultTabController(
        length: 3, // Reduce the length to 3 since we're removing the "Profile" tab
        child: Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              child: Text('TravelCompass'),
            ),
          ),
          body: TabBarView(
            children: [
              MainTab(),
              PlanningTab(),
              CommunityTab(), // Use your CommunityTab here
            ],
          ),
          bottomNavigationBar: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.teal,
            indicatorColor: Colors.teal,
            tabs: [
              Tab(icon: Icon(Icons.date_range), text: 'Main'),
              Tab(icon: Icon(Icons.contacts), text: 'Planning'),
              Tab(icon: Icon(Icons.note), text: 'Community'),
            ],
          ),
        ),
      ),
    );
  }
}
