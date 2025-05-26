import 'package:flutter/material.dart';

import '../models/location.dart';
import '../services/location-service.dart';

class LocationStore extends ChangeNotifier {
  List<Location> locations = [];
  final LocationService _service = LocationService();

  getListLocation() async {
    try {
      locations = await _service.getAllLocations();
      notifyListeners();
    } catch(error) {
      rethrow;
    }
  }

  addLocation(LocationCreateDto data) async {
    try {
      final location = await _service.addLocation(data);
      locations.add(location);
      notifyListeners();
    } catch(error) {
      rethrow;
    }
  }

  updateLocation(int id, LocationCreateDto data) async {
    try {
      final updatedLocation = await _service.updateLocation(id, data);
      final index = locations.indexWhere((location) => location.id == id);
      locations[index] = updatedLocation;
      notifyListeners();
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  removeLocation(Location location) async {
    try {
      await _service.deleteLocation(location.id);
      locations.remove(location);
      notifyListeners();
    } catch(error) {
      rethrow;
    }
  }
}