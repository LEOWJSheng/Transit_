import 'package:flutter/material.dart';

class TravelDetailsProvider extends ChangeNotifier {
  String? departureName, destinationName;
  double? departureLat, departureLng, destinationLat, destinationLng;

  void addDestinationName(String destinationName) {
    this.destinationName = destinationName;
    notifyListeners();
  }

  void addDestinationGeoLocation(double lat, double lng) {
    destinationLat = lat;
    destinationLng = lng;
    notifyListeners();
  }

  void addDepartureName(String departureName) {
    this.departureName = departureName;
    notifyListeners();
  }

  void addDepartureGeoLocation(double lat, double lng) {
    departureLat = lat;
    departureLng = lng;
    notifyListeners();
  }

  void clearDepartureGeoLocation() {
    departureLat = null;
    departureLng = null;
    notifyListeners();
  }

  void clearDepartureName() {
    departureName = null;
    notifyListeners();
  }

  void clearDestinationName() {
    destinationName = null;
    notifyListeners();
  }

  void swapLocations() {
    String? tempName = departureName;
    departureName = destinationName;
    destinationName = tempName;

    double? tempLat = departureLat;
    double? tempLng = departureLng;

    departureLat = destinationLat;
    departureLng = destinationLng;

    destinationLat = tempLat;
    destinationLng = tempLng;

    notifyListeners();
  }
}
