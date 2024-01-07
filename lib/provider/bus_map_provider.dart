import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusMapProvider extends ChangeNotifier {
  static late GoogleMapController _mapController;

  static GoogleMapController get mapController => _mapController;

  static void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }
}
