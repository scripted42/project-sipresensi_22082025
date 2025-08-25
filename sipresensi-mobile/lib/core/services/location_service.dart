import 'package:geolocator/geolocator.dart';

class LocationService {
  // Constants for school location (mock values)
  // In a real app, these would come from API or database
  static const double schoolLatitude = -6.123456;
  static const double schoolLongitude = 106.876543;
  static const double radiusInMeters = 100.0; // 100 meters radius

  /// Determine the current position of the device.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /// Check if the current location is within the school radius
  Future<bool> isWithinSchoolRadius() async {
    try {
      final Position position = await getCurrentLocation();
      
      // Calculate distance between current position and school
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        schoolLatitude,
        schoolLongitude,
      );
      
      // Check if within radius
      return distanceInMeters <= radiusInMeters;
    } catch (e) {
      // If there's an error getting location, we can't verify
      // In a real app, you might want to handle this differently
      rethrow;
    }
  }

  /// Calculate distance to school in meters
  Future<double> calculateDistanceToSchool(Position position) async {
    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      schoolLatitude,
      schoolLongitude,
    );
  }
}