/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
main_tab.dart
 */

import 'package:flutter/material.dart';
import 'package:project/weather_api.dart';
import 'database_helper.dart';
import 'google_places_api.dart';

/// The main tab for displaying location search and details.
class MainTab extends StatefulWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final GooglePlacesApi _googlePlacesApi = GooglePlacesApi();

  List<ApiLocationData> _locations = [];
  ApiLocationData? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for cities...',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (searchQuery) {
                // Handle search functionality here
                _searchLocations(searchQuery);
              },
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              if (_selectedLocation != null)
                GestureDetector(
                  onTap: () {
                    _handleLocationBoxClick(context, _selectedLocation!);
                  },
                  child: _LocationBox(
                    locationTitle: _selectedLocation!.name,
                    locationDescription: _selectedLocation!.address,
                    shortDescription: _selectedLocation!.shortDescription,
                    photoReference: _selectedLocation!.photoReference,
                    cultureDescription: _selectedLocation!.cultureDescription, // Pass the culture description


                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _searchLocations(String searchQuery) async {
    try {
      final List<ApiLocationData> locations = await _googlePlacesApi.searchCities(searchQuery);

      setState(() {
        _locations = locations;
        if (_locations.isNotEmpty) {
          _selectedLocation = _locations.first;
        } else {
          _selectedLocation = null;
        }
      });
    } catch (e) {
      print('Error searching locations: $e');
    }
  }

  void _handleLocationBoxClick(BuildContext context, ApiLocationData location) async {
    // Save the location data to the local database.
    final DbLocationData dbLocation = DbLocationData(
      name: location.name,
      address: location.address,
      latitude: location.latitude,
      longitude: location.longitude,
      // Add any other properties needed for your database here
    );

    await _databaseHelper.insertLocation(dbLocation);

    // Navigate to the location details screen and pass the location description and photo reference
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailsScreen(
          locationTitle: location.name,
          locationDescription: location.shortDescription ?? '',
          photoReference: location.photoReference,
          cultureDescription: location.cultureDescription, // Pass the culture description
        ),
      ),
    );
  }
}

/// A widget representing a location box with details.
class _LocationBox extends StatelessWidget {
  final String locationTitle;
  final String locationDescription;
  final String? shortDescription;
  final String? photoReference;
  final String? cultureDescription;


  _LocationBox({
    required this.locationTitle,
    required this.locationDescription,
    this.shortDescription,
    this.photoReference,
    this.cultureDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (photoReference != null)
            Container(
              width: 100, // Adjust the image width as needed
              height: 100, // Adjust the image height as needed
              margin: const EdgeInsets.only(right: 16.0),
              child: Image.network(
                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=${GooglePlacesApi.apiKey}',
                fit: BoxFit.cover,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (shortDescription != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                    child: Text(
                      shortDescription!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                Text(
                  locationDescription,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The screen for displaying location details.
class LocationDetailsScreen extends StatefulWidget {
  final String locationTitle;
  final String locationDescription;
  final String? photoReference;
  final String? cultureDescription;

  LocationDetailsScreen({
    required this.locationTitle,
    required this.locationDescription,
    this.photoReference,
    this.cultureDescription,
  });

  @override
  _LocationDetailsScreenState createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  late String _weatherDescription = ''; // Initialize with an empty string
  late IconData _weatherIcon; // Variable to hold the weather icon
  bool _isWeatherLoaded = false; // Flag to track weather data loading

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await _weatherApi.fetchWeather(widget.locationTitle);
      setState(() {
        _weatherDescription = weatherData;
        _weatherIcon = _getWeatherIcon(weatherData);
        _isWeatherLoaded = true; // Mark weather data as loaded
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain) {
      case 'clear sky':
        return Icons.wb_sunny;
      case 'broken clouds':
        return Icons.cloud_queue;
      case 'few clouds':
        return Icons.cloud;
      case 'scattered clouds':
        return Icons.cloud;
      case 'overcast clouds':
        return Icons.cloud_off;
      case 'mist':
        return Icons.cloud;
      default:
        return Icons.help_outline;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.locationTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.photoReference != null)
              Container(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${widget
                      .photoReference}&key=${GooglePlacesApi.apiKey}',
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.locationTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (_isWeatherLoaded)
                    Row(
                      children: [
                        Icon(_weatherIcon),
                        SizedBox(width: 8),
                        Text(
                          'Weather: $_weatherDescription',
                          // Add 'Weather' before weather description
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  else
                    CircularProgressIndicator(),
                  // Show CircularProgressIndicator while loading
                  SizedBox(height: 16),
                  Text(
                    widget.locationDescription,
                    style: TextStyle(fontSize: 16),
                  ),
                  if (widget.cultureDescription != null)
                    SizedBox(height: 16),
                  Text(
                    'Culture: ${widget.cultureDescription}',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}