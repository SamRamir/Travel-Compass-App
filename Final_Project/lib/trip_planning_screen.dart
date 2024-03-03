/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
trip_planning_screen.dart
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A tab for planning and managing the user's travel itinerary.
class PlanningTab extends StatefulWidget {
  @override
  _PlanningTabState createState() => _PlanningTabState();
}

class _PlanningTabState extends State<PlanningTab> {
  List<ItineraryItem> itineraryItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Itinerary')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itineraryItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(itineraryItems[index].destination),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      itineraryItems.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(itineraryItems[index].destination),
                      subtitle:
                      Text('${itineraryItems[index].startDate} - ${itineraryItems[index].endDate}'),
                      onTap: () {
                        // Open edit screen for this itinerary item
                        _editItinerary(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open input dialog for creating a new itinerary
          _addItinerary();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItinerary() {
    showDialog(
      context: context,
      builder: (context) => UserInputScreen(),
    ).then((newData) {
      if (newData != null) {
        setState(() {
          itineraryItems.add(ItineraryItem(
            destination: newData.destination,
            startDate: newData.startDate,
            endDate: newData.endDate,
            activities: newData.activities,
          ));
        });
      }
    });
  }

  void _editItinerary(int index) {
    showDialog(
      context: context,
      builder: (context) => UserInputScreen(
        destination: itineraryItems[index].destination,
        startDate: itineraryItems[index].startDate,
        endDate: itineraryItems[index].endDate,
        activities: itineraryItems[index].activities,
      ),
    ).then((editedData) {
      if (editedData != null) {
        setState(() {
          itineraryItems[index] = ItineraryItem(
            destination: editedData.destination,
            startDate: editedData.startDate,
            endDate: editedData.endDate,
            activities: editedData.activities,
          );
        });
      }
    });
  }
}

/// Represents data for an itinerary item.
class ItineraryData {
  final String destination;
  final String startDate;
  final String endDate;
  final String activities;

  ItineraryData({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.activities,
  });
}

/// Represents an item in the user's travel itinerary.
class ItineraryItem {
  final String destination;
  final String startDate;
  final String endDate;
  final String activities;

  ItineraryItem({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.activities,
  });
}

/// A screen for user input to create or edit an itinerary item.
class UserInputScreen extends StatefulWidget {
  final String destination;
  final String startDate;
  final String endDate;
  final String activities;

  UserInputScreen({
    this.destination = '',
    this.startDate = '',
    this.endDate = '',
    this.activities = '',
  });

  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

/// The state for the UserInputScreen widget.
class _UserInputScreenState extends State<UserInputScreen> {
  TextEditingController destinationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController activitiesController = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    destinationController.text = widget.destination;
    startDateController.text = widget.startDate;
    endDateController.text = widget.endDate;
    activitiesController.text = widget.activities;

    activities = _parseActivities(widget.activities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Your Itinerary')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap the content with SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: destinationController,
                decoration: InputDecoration(labelText: 'Destination'),
              ),
              InkWell(
                onTap: () {
                  _selectStartDate();
                },
                child: TextFormField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  enabled: false,
                ),
              ),
              InkWell(
                onTap: () {
                  _selectEndDate();
                },
                child: TextFormField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                  enabled: false,
                ),
              ),
              SizedBox(height: 20),
              Text('Activities:'),
              ListView.builder(
                shrinkWrap: true, // Add shrinkWrap: true here
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(activities[index].name),
                    subtitle: Text('Time: ${activities[index].time}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          activities.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: _addActivity,
                child: Text('Add Activity'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save user input and return the data to the main screen
                  ItineraryData newData = ItineraryData(
                    destination: destinationController.text,
                    startDate: startDateController.text,
                    endDate: endDateController.text,
                    activities: activities.map((activity) => "${activity.name} - ${activity.time}").join('\n'),
                  );
                  Navigator.pop(context, newData);
                },
                child: Text('Generate Itinerary'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addActivity() async {
    Activity? newActivity = await showDialog(
      context: context,
      builder: (context) => AddActivityDialog(),
    );

    if (newActivity != null) {
      setState(() {
        activities.add(newActivity);
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        startDateController.text = formatDate(picked);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now(),
      firstDate: selectedStartDate ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        endDateController.text = formatDate(picked);
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  List<Activity> _parseActivities(String activitiesStr) {
    List<Activity> parsedActivities = [];
    List<String> activityLines = activitiesStr.split('\n');

    for (String line in activityLines) {
      List<String> parts = line.split(' - ');
      if (parts.length == 2) {
        String name = parts[0];
        String time = parts[1];
        parsedActivities.add(Activity(name: name, time: time));
      }
    }

    return parsedActivities;
  }
}

/// Represents an activity in the itinerary.
class Activity {
  final String name;
  final String time;

  Activity({required this.name, required this.time});
}

/// A dialog for adding a new activity to the itinerary.
class AddActivityDialog extends StatefulWidget {
  @override
  _AddActivityDialogState createState() => _AddActivityDialogState();
}

/// The state for the AddActivityDialog widget.
class _AddActivityDialogState extends State<AddActivityDialog> {
  TextEditingController nameController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Activity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Activity Name'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectTime,
            child: Text('Select Time'),
          ),
          SizedBox(height: 10),
          Text(
            'Selected Time: ${selectedTime.format(context)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              Navigator.pop(
                context,
                Activity(name: nameController.text, time: selectedTime.format(context)),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
}