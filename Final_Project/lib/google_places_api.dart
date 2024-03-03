/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
google_places_api.dart
 */

import 'dart:convert';
import 'package:http/http.dart' as http;

/// A class for interacting with the Google Places API to retrieve location data.
class GooglePlacesApi {
  static const apiKey = 'AIzaSyBiL2R8oa4Dr3DO9Er2Lgtfu_OJPkjxFq0'; // This is the API that I got from making a google cloud account

  /// Searches for cities based on a query and returns a list of location data.
  Future<List<ApiLocationData>> searchCities(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json' +
          '?input=$query' +
          '&types=(cities)' +
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List<dynamic>;

        final List<ApiLocationData> locations = await Future.wait(predictions.map((prediction) async {
          final String cityName = prediction['structured_formatting']['main_text'];
          final String countryName = prediction['structured_formatting']['secondary_text'];
          final String description = await fetchShortDescription(cityName);
          final String? photoReference = await fetchPlacePhotoReference(prediction['place_id']);
          final String cultureDescription = await fetchCultureDescription(cityName);//


          return ApiLocationData(
            name: prediction['description'],
            address: '',
            latitude: null,
            longitude: null,
            shortDescription: description,
            photoReference: photoReference,
            cultureDescription: cultureDescription,
          );
        }));

        return locations;
      } else {
        throw Exception('Failed to fetch data from Google Places API');
      }
    } catch (e) {
      print('Error searching locations: $e');
      return [];
    }
  }


/// Fetches short descriptions of locations from Wikipedia based on the city name.
  Future<String> fetchShortDescription(String cityName) async {
    final apiUrl =
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro=true&titles=$cityName';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'];
        final pageId = pages.keys.first;
        final extract = pages[pageId]['extract'];

        // Extract the first four sentences
        final List<String> sentences = extract.split(RegExp(r'(?<=[.!?])\s+(?=[A-Z])'));
        final int maxSentences = 4;
        final shortDescription = sentences.take(maxSentences).join(' ');

        // Remove unwanted parts from the short description
        final sanitizedDescription = shortDescription.replaceAll(RegExp(r"<.*?>"), '');

        return sanitizedDescription;
      } else {
        throw Exception('Failed to fetch data from Wikipedia API');
      }
    } catch (e) {
      print('Error fetching short description: $e');
      return '';
    }
  }

/// Fetches the photo reference for a place from the Google Places API.
  Future<String?> fetchPlacePhotoReference(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json' +
            '?place_id=$placeId' +
            '&fields=photos' +
            '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic>? photos = data['result']['photos'];

        if (photos != null && photos.isNotEmpty) {
          // Return the first photo reference
          return photos[0]['photo_reference'];
        }
      }
    } catch (e) {
      print('Error fetching place photo reference: $e');
    }

    return null;
  }
}

/// Fetches the culture description of a city from Wikipedia based on the city name.
Future<String> fetchCultureDescription(String cityName) async {
  final apiUrl =
      'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&titles=$cityName&exsectionformat=plain';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pages = data['query']['pages'];
      final pageId = pages.keys.first;
      final extract = pages[pageId]['extract'];

      // Find the starting and ending indices of the culture section
      final cultureSectionStart = extract.indexOf('<span id="Culture">Culture</span>');
      final nextHeading = extract.indexOf('<h2>', cultureSectionStart);
      final cultureSectionEnd = nextHeading != -1 ? nextHeading : extract.length;

      // Extract the culture section's content
      final cultureDescription = extract.substring(cultureSectionStart, cultureSectionEnd);

      // Remove unwanted parts from the description
      final sanitizedDescription = cultureDescription.replaceAll(RegExp(r"<.*?>"), '');
      print(sanitizedDescription);

      return sanitizedDescription;
    } else {
      throw Exception('Failed to fetch culture description from Wikipedia API');
    }
  } catch (e) {
    print('Error fetching culture description: $e');
    return '';
  }
}


/// Represents data for a location returned by the Google Places API.
class ApiLocationData {
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? shortDescription;
  final String? photoReference;
  final String? cultureDescription;

  /// Constructs a [ApiLocationData] instance with the provided parameters.
  ApiLocationData({
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.shortDescription,
    this.photoReference,
    this.cultureDescription,
  });
}
