import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerProvider extends ChangeNotifier {
  final List<Marker> staticMarkers = [];
  final List<Marker> dynamicMarkers = [];
  List<Polyline> polyline = [];

  void addStaticMarkers(List<Marker> markers) {
    removeStaticMarkers();
    staticMarkers.addAll(markers);
    notifyListeners();
  }

  void removeStaticMarkers() {
    staticMarkers.clear();
    notifyListeners();
  }

  void addDynamicMarkers(Marker marker) {
    removeDynamicMarkers();
    dynamicMarkers.add(marker);
    notifyListeners();
  }

  void removeDynamicMarkers() {
    dynamicMarkers.clear();
    notifyListeners();
  }

  void addPolyline(Polyline newPolyline) {
    clearPolyline();
    polyline.add(newPolyline);
    notifyListeners();
  }

  void clearPolyline() {
    polyline.clear();
    notifyListeners();
  }
}
