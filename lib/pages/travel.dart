import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:transit_malaya/global_variables/bus_options.dart';
import 'package:transit_malaya/pages/travel_navigation.dart';
import 'package:transit_malaya/provider/travel_details_provider.dart';

class Travel extends StatefulWidget {
  const Travel({super.key});

  @override
  State<Travel> createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  final border = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(24, 28, 98, 1),
    ),
  );

  TextEditingController searchController = TextEditingController();
  final results = [...uniPlaces];
  Position? _currentPosition;

  bool _isPositionGet = false;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: TextFormField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                results.clear();
                results.addAll(
                  uniPlaces.where(
                    (uniPlace) =>
                        uniPlace["name"].toString().toLowerCase().contains(
                              value.trim().toLowerCase(),
                            ),
                  ),
                );
                sortResultsByDistance();
              });
            },
            maxLines: 1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              hintText: "Enter your destination",
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              focusedBorder: border,
              enabledBorder: border,
            ),
          ),
        ),
        const SizedBox(
          height: 100.0,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[50],
            ),
            child: results.isEmpty
                ? const Center(
                    child: Text("No results were found..."),
                  )
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      var place = results[index];
                      double? userLat = _currentPosition?.latitude;
                      double? userLng = _currentPosition?.longitude;

                      return ListTile(
                        title: Text(place["name"] as String),
                        subtitle: _currentPosition == null
                            ? const LinearProgressIndicator()
                            : Text("${(Geolocator.distanceBetween(
                                  userLat!,
                                  userLng!,
                                  place["lat"] as double,
                                  place["lng"] as double,
                                ) / 1000).toStringAsFixed(2)} km"),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 12,
                          child: const Icon(
                            Icons.house,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        trailing: _isPositionGet
                            ? InkWell(
                                onTap: () {
                                  String destinationName =
                                      place["name"] as String;
                                  Provider.of<TravelDetailsProvider>(context,
                                          listen: false)
                                      .addDestinationName(destinationName);

                                  Provider.of<TravelDetailsProvider>(context,
                                          listen: false)
                                      .addDestinationGeoLocation(
                                          place["lat"] as double,
                                          place["lng"] as double);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TravelNavigationPage(
                                        destinationName:
                                            place["name"] as String,
                                        userLat: userLat,
                                        userLng: userLng,
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.directions,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : null,
                      );
                    },
                  ),
          ),
        )
      ],
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _isPositionGet = true;
        _currentPosition = position;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void sortResultsByDistance() {
    if (_currentPosition != null) {
      results.sort((place1, place2) {
        double distance1 = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          place1["lat"] as double,
          place1["lng"] as double,
        );

        double distance2 = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          place2["lat"] as double,
          place2["lng"] as double,
        );

        return distance1.compareTo(distance2);
      });
    }
  }
}
