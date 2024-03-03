/*
Samuel Ramirez
Project: Travel Compass
8/8/23
CS4381
database_helper.dart
 */


import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/// A helper class for managing SQLite database operations.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  /// Returns the database instance, initializing it if necessary.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // If _database is null, initialize it.
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database by creating tables if needed.
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'locations.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  /// Creates the 'locations' table in the database.
  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        address TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  /// Inserts a location into the database.
  Future<int> insertLocation(DbLocationData location) async {
    final db = await database;
    return await db.insert('locations', location.toMap());
  }

  /// Retrieves a list of all locations from the database.
  Future<List<DbLocationData>> getLocations() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('locations');
    return List.generate(maps.length, (index) {
      return DbLocationData.fromMap(maps[index]);
    });
  }
}

/// Represents data for a location stored in the database.
class DbLocationData {
  final int? id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? shortDescription; // Add the short description property

  /// Constructs a [DbLocationData] instance with the provided parameters.
  DbLocationData({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.shortDescription,
  });

  /// Converts the location data to a map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Creates a [DbLocationData] instance from a map retrieved from the database.
  factory DbLocationData.fromMap(Map<String, dynamic> map) {
    return DbLocationData(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
