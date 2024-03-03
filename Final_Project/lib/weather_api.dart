/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
trip_planning_screen.dart
 */

import 'dart:convert';
import 'package:http/http.dart' as http;

/// A class that provides methods to fetch weather data from the OpenWeatherMap API.
class WeatherApi {
  static const apiKey = '9c52d9e60a979bc8a9bb5e6648bd9e9c';

  /// Fetches weather data for a specific city using the OpenWeatherMap API.
  ///
  /// Returns a description of the weather.
  ///
  /// Throws an [Exception] if fetching the weather data fails.
  Future<String> fetchWeather(String cityName) async {
    final String url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';

    print('here');
    print(url);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
            'Weather API Response: $data'); // Print the response to the console

        final weather = data['weather'][0]['description'];
        return weather;
      } else {
        throw Exception('Failed to fetch weather data from OpenWeatherMap API');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
}
