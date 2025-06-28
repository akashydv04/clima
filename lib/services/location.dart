import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  late double longitude;
  late double latitude;

  Future<void> getCurrentLocation() async {
    try {
      final LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      longitude = position.longitude;
      latitude = position.latitude;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
