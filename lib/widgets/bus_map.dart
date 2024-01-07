import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transit_malaya/provider/bus_map_provider.dart';
import 'package:transit_malaya/provider/marker_provider.dart';

class BusMap extends StatelessWidget {
  final Function actionOnMap;
  const BusMap({super.key, required this.actionOnMap});

  @override
  Widget build(BuildContext context) {
    List<Marker> staticMarkers =
        Provider.of<MarkerProvider>(context).staticMarkers;
    List<Marker> dynamicMarkers =
        Provider.of<MarkerProvider>(context).dynamicMarkers;
    List<Polyline> polyline = Provider.of<MarkerProvider>(context).polyline;

    return Consumer<BusMapProvider>(
      builder: (context, mapProvider, child) {
        return GoogleMap(
          onMapCreated: (controller) {
            BusMapProvider.setMapController(controller);
            actionOnMap();
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(3.1219, 101.6570),
            zoom: 15,
          ),
          markers: {...staticMarkers, ...dynamicMarkers},
          polylines: Set.from(polyline),
        );
      },
    );
  }
}
