import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapFieldViewModel extends ChangeNotifier {
  LatLng? _selectedLocation;
  bool _useLocationToggle = false;
  bool _currentLocationToggle = false;

  LatLng? get selectedLocation => _selectedLocation;
  bool get useLocationToggle => _useLocationToggle;
  bool get currentLocationToggle => _currentLocationToggle;

  void selectLocation(LatLng location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void toggleUseLocation(bool value) {
    _useLocationToggle = value;
    notifyListeners();
  }

  void toggleCurrentLocation(bool value) {
    _currentLocationToggle = value;
    notifyListeners();
  }
}

