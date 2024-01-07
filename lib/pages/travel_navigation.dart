import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transit_malaya/global_variables/bus_options.dart';
import 'package:transit_malaya/pages/travel_navigation_header.dart';
import 'package:transit_malaya/provider/bus_map_provider.dart';
import 'package:transit_malaya/provider/marker_provider.dart';
import 'package:transit_malaya/provider/travel_details_provider.dart';
import 'package:transit_malaya/widgets/bus_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TravelNavigationPage extends StatefulWidget {
  final String destinationName;
  final double? userLat, userLng;
  const TravelNavigationPage(
      {super.key,
      required this.destinationName,
      required this.userLat,
      required this.userLng});

  @override
  State<StatefulWidget> createState() {
    return _TravelNavigationPage();
  }
}

class _TravelNavigationPage extends State<TravelNavigationPage> {
  bool _isMyPositionPressed = false;
  bool _showNavigationInfo = false, _isLoading = false;
  List<Widget> addtionalWidgets = [];

  @override
  Widget build(BuildContext context) {
    void setMyPositionState() {
      setState(() {
        _isMyPositionPressed = true;
      });
    }

    double? destinationLat =
        Provider.of<TravelDetailsProvider>(context).destinationLat;
    double? destinationLng =
        Provider.of<TravelDetailsProvider>(context).destinationLng;

    LatLng destinationLatLng = LatLng(destinationLat!, destinationLng!);

    void actionOnMap() {
      GoogleMapController googleMapController = BusMapProvider.mapController;

      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(destinationLatLng, 16.0),
      );

      Provider.of<MarkerProvider>(context, listen: false).clearPolyline();

      Provider.of<MarkerProvider>(context, listen: false).addStaticMarkers([
        Marker(
          markerId: MarkerId(widget.destinationName),
          position: destinationLatLng,
          infoWindow: InfoWindow(
            title: (widget.destinationName),
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      ]);
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: _showNavigationInfo ? 1 : 2,
              child: Stack(
                children: [
                  BusMap(
                    actionOnMap: actionOnMap,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: TravelNavigationHeader(
                      destinationName: widget.destinationName,
                      setMyPositionState: setMyPositionState,
                      isMyPositionPressed: _isMyPositionPressed,
                      fetchNavigationData: fetchNavigationData,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: _showNavigationInfo ? 2 : 1,
              child: Container(
                color: Colors.white,
                child: _isMyPositionPressed
                    ? _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : _showNavigationInfo
                            ? Column(
                                children: [...addtionalWidgets],
                              )
                            : ListTile(
                                onTap: () async {
                                  setState(() {
                                    TravelNavigationHeaderState
                                        .departureController
                                        .text = "Your Position";

                                    Provider.of<TravelDetailsProvider>(context,
                                            listen: false)
                                        .addDepartureGeoLocation(
                                            widget.userLat!, widget.userLng!);
                                  });

                                  fetchNavigationData();
                                },
                                leading: Icon(
                                  Icons.gps_fixed,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(
                                  "Your position",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                    : const Center(
                        child: Text("Please select a start and end position"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getZoomLevel(double distance) {
    if (distance > 2000) {
      return 11;
    } else if (distance > 1000) {
      return 14.0;
    } else if (distance > 500) {
      return 15.0;
    } else {
      return 16.5;
    }
  }

  void fetchNavigationData() async {
    setState(() {
      _isLoading = true;
      addtionalWidgets.clear();
    });
    double? userLat =
        Provider.of<TravelDetailsProvider>(context, listen: false).departureLat;
    double? userLng =
        Provider.of<TravelDetailsProvider>(context, listen: false).departureLng;
    double? destinationLat =
        Provider.of<TravelDetailsProvider>(context, listen: false)
            .destinationLat;
    double? destinationLng =
        Provider.of<TravelDetailsProvider>(context, listen: false)
            .destinationLng;

    if (userLat != null &&
        userLng != null &&
        destinationLat != null &&
        destinationLng != null) {
      Marker userMarker = Marker(
        markerId: const MarkerId("Current Location"),
        position: LatLng(userLat, userLng),
        infoWindow: const InfoWindow(
          title: "Your Location",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      );

      Marker destinationMarker = Marker(
        markerId: const MarkerId("Destination"),
        position: LatLng(destinationLat, destinationLng),
        infoWindow: const InfoWindow(
          title: "Destination",
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Add the user marker to the MarkerProvider
      Provider.of<MarkerProvider>(context, listen: false)
          .addDynamicMarkers(userMarker);

      Provider.of<MarkerProvider>(context, listen: false)
          .addStaticMarkers([destinationMarker]);

      double midPointLat = (userLat + destinationLat) / 2;
      double midPointLng = (userLng + destinationLng) / 2;

      // Calculate the distance between user and destination
      double distance = Geolocator.distanceBetween(
        userLat,
        userLng,
        destinationLat,
        destinationLng,
      );

      // Adjust zoom level based on distance
      double zoomLevel = getZoomLevel(distance);

      // Animate the camera to the midpoint with the adjusted zoom level
      GoogleMapController googleMapController = BusMapProvider.mapController;

      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(midPointLat, midPointLng), zoomLevel),
      );

      final apiUrl = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$userLat,$userLng&destination=$destinationLat,$destinationLng'
          '&key=$apiKey'
          '&mode=walking';

      try {
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> routes = data['routes'];

          if (routes.isNotEmpty) {
            final List<dynamic> legs = routes[0]['legs'];
            final List<dynamic> steps = legs[0]['steps'];

            final String overviewPolyline =
                data['routes'][0]['overview_polyline']['points'];

            List<LatLng> overviewPolylinePoints = PolylinePoints()
                .decodePolyline(overviewPolyline)
                .map((PointLatLng point) =>
                    LatLng(point.latitude, point.longitude))
                .toList();

            Polyline overviewPolylineWidget = Polyline(
              polylineId: const PolylineId("overview_polyline"),
              color: Theme.of(context).primaryColor, // Set color as needed
              points: overviewPolylinePoints,
              width: 5,
            );

            Provider.of<MarkerProvider>(context, listen: false)
                .addPolyline(overviewPolylineWidget);

            setState(() {
              addtionalWidgets.add(
                ListTile(
                  title: Text(
                    (legs[0]["end_address"] as String).split(",")[0],
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${legs[0]["duration"]["text"]} (${legs[0]["distance"]["text"]})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );

              addtionalWidgets.add(
                Expanded(
                  child: Container(
                    color: Colors.blue[50],
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:
                          steps.length + 2, // +2 for start and end instructions
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First item, start instruction
                          return const ListTile(
                            title: Text('Start'),
                            subtitle: Text('Your journey begins here.'),
                          );
                        } else if (index == steps.length + 1) {
                          // Last item, end instruction
                          return const ListTile(
                            title: Text('End'),
                            subtitle:
                                Text('You have reached your destination.'),
                          );
                        } else {
                          // Regular step
                          final step = steps[index - 1];
                          // Use a regex to extract text before and after <b> tags
                          final match = RegExp(r'(.*?)<b>(.*?)<\/b>')
                              .firstMatch(step['html_instructions']);
                          final beforeText = match?.group(1) ?? '';
                          final boldText = match?.group(2) ?? '';

                          return ListTile(
                            title: Text('$beforeText$boldText'),
                            subtitle: Text(
                              'Duration: ${step['duration']['text']}, Distance: ${step['distance']['text']}',
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              );

              _showNavigationInfo = true;
              _isLoading = false;
            });
          }
        } else {
          throw Exception('Failed to load directions');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
