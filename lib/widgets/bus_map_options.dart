import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transit_malaya/global_variables/bus_options.dart';
import 'package:transit_malaya/pages/service_details.dart';
import 'package:transit_malaya/provider/marker_provider.dart';
import 'package:transit_malaya/utils/firestore.dart';

class BusMapOption extends StatefulWidget {
  const BusMapOption({super.key});

  @override
  State<BusMapOption> createState() => _BusMapOptionState();
}

class _BusMapOptionState extends State<BusMapOption> {
  String selectedBus = "";

  late BitmapDescriptor abBusStopDescriptor;
  late BitmapDescriptor abBusDescriptor;

  late BitmapDescriptor baBusStopDescriptor;
  late BitmapDescriptor baBusDescriptor;

  Timer? locationUpdateTimer;

  @override
  void dispose() {
    locationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(40, 40),
            ),
            "assets/AB_border.png")
        .then((value) {
      abBusStopDescriptor = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(150, 150),
            ),
            "assets/AB_bus_icon.png")
        .then((value) {
      abBusDescriptor = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(40, 40),
            ),
            "assets/BA_bus_stop_icon.png")
        .then((value) {
      baBusStopDescriptor = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(150, 150),
            ),
            "assets/BA_bus_icon.png")
        .then((value) {
      baBusDescriptor = value;
    });

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shuttle Buses",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ServiceDetails(),
                    ),
                  );
                },
                child: Text(
                  "Schedule details",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: buses.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final bus = buses[index];
                final List<dynamic> markerOptions = bus["markerOptions"] == null
                    ? []
                    : bus["markerOptions"] as List<Map<String, Object>>;
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: selectedBus == bus["name"]
                              ? bus["color"] as Color
                              : Colors.transparent,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            clearPreviousSelection();
                            selectedBus = bus["name"] as String;
                            List<Marker> markers = markerOptions
                                .map(
                                  (markerOption) => Marker(
                                    markerId:
                                        markerOption["markerId"] as MarkerId,
                                    position:
                                        markerOption["position"] as LatLng,
                                    infoWindow: markerOption["infoWindow"]
                                        as InfoWindow,
                                    icon: getBusStopIcon(bus["name"] as String),
                                  ),
                                )
                                .toList();

                            List<LatLng> polyLinePoints = markers
                                .map((marker) => marker.position)
                                .toList();
                            Polyline polyline = Polyline(
                              polylineId: PolylineId(
                                bus["name"] as String,
                              ),
                              color: bus["color"] as Color,
                              points: polyLinePoints,
                              width: 5,
                              jointType: JointType.round,
                              geodesic: true,
                            );

                            locationUpdateTimer = Timer.periodic(
                                const Duration(seconds: 3), (timer) async {
                              LatLng? busLocation = await Firestore()
                                  .getCurrentBusLocation(bus["name"] as String);

                              if (busLocation != null) {
                                Marker marker = Marker(
                                  markerId: MarkerId(bus["name"] as String),
                                  position: busLocation,
                                  infoWindow: InfoWindow(
                                      title: (bus["name"]) as String),
                                  icon: getBusIcon(bus["name"] as String),
                                  zIndex: 100,
                                );

                                Provider.of<MarkerProvider>(context,
                                        listen: false)
                                    .addDynamicMarkers(marker);
                              } else {
                                Provider.of<MarkerProvider>(context,
                                        listen: false)
                                    .removeDynamicMarkers();
                              }
                            });

                            Provider.of<MarkerProvider>(context, listen: false)
                                .addStaticMarkers(markers);
                            Provider.of<MarkerProvider>(context, listen: false)
                                .addPolyline(polyline);
                          });
                        },
                        icon: const Icon(
                          Icons.directions_bus,
                          size: 50,
                        ),
                        color: bus["color"] as Color,
                      ),
                    ),
                    Text(
                      bus["name"] as String,
                      style: TextStyle(
                        color: bus["color"] as Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void clearPreviousSelection() {
    locationUpdateTimer?.cancel();
    Provider.of<MarkerProvider>(context, listen: false).removeStaticMarkers();
    Provider.of<MarkerProvider>(context, listen: false).removeDynamicMarkers();
    Provider.of<MarkerProvider>(context, listen: false).clearPolyline();
  }

  BitmapDescriptor getBusIcon(String busName) {
    switch (busName) {
      case "AB":
        return abBusDescriptor;
      case "BA":
        return baBusDescriptor;
    }

    return BitmapDescriptor.defaultMarker;
  }

  BitmapDescriptor getBusStopIcon(String busName) {
    switch (busName) {
      case "AB":
        return abBusStopDescriptor;
      case "BA":
        return baBusStopDescriptor;
    }

    return BitmapDescriptor.defaultMarker;
  }
}
