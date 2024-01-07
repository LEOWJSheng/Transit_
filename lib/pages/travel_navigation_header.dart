import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_malaya/provider/marker_provider.dart';
import 'package:transit_malaya/provider/travel_details_provider.dart';

class TravelNavigationHeader extends StatefulWidget {
  final String destinationName;
  final VoidCallback setMyPositionState, fetchNavigationData;
  final bool isMyPositionPressed;

  const TravelNavigationHeader({
    super.key,
    required this.setMyPositionState,
    required this.destinationName,
    required this.isMyPositionPressed,
    required this.fetchNavigationData,
  });

  @override
  State<TravelNavigationHeader> createState() => TravelNavigationHeaderState();
}

class TravelNavigationHeaderState extends State<TravelNavigationHeader> {
  static final TextEditingController departureController =
      TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  bool shouldCloseDepartureIcon = true;
  bool shouldCloseDestinationIcon = true;
  int selectedTransportOption = 0;

  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    destinationController.text = widget.destinationName;
  }

  @override
  Widget build(BuildContext context) {
    return _isExpanded
        ? Container(
            color: Colors.white,
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.circle_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context).primaryColor,
                                  size: 25.0,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: departureController,
                                    onChanged: (value) {
                                      setState(() {
                                        shouldCloseDepartureIcon =
                                            departureController.text.isEmpty;
                                      });
                                    },
                                    onTap: () {
                                      widget.setMyPositionState();
                                    },
                                    decoration: InputDecoration(
                                      hintText: "From",
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      suffixIcon: shouldCloseDepartureIcon
                                          ? null
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  shouldCloseDepartureIcon =
                                                      true;
                                                  departureController.clear();
                                                });
                                              },
                                              child: Icon(
                                                Icons.close_sharp,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const Divider(),
                                  TextFormField(
                                    controller: destinationController,
                                    onChanged: (value) {
                                      setState(() {
                                        shouldCloseDestinationIcon =
                                            destinationController.text.isEmpty;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "To",
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      suffixIcon: shouldCloseDestinationIcon
                                          ? null
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  shouldCloseDestinationIcon =
                                                      true;
                                                  destinationController.clear();
                                                });
                                              },
                                              child: Icon(
                                                Icons.close_sharp,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  String temp = departureController.text;
                                  departureController.text =
                                      destinationController.text;
                                  destinationController.text = temp;
                                });
                                Provider.of<TravelDetailsProvider>(context,
                                        listen: false)
                                    .swapLocations();
                                widget.fetchNavigationData();
                              },
                              child: Icon(
                                Icons.swap_vert,
                                color: Theme.of(context).primaryColor,
                                size: 32,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedTransportOption = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: selectedTransportOption == 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.directions_walk,
                                color: selectedTransportOption == 0
                                    ? Colors.white
                                    : Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedTransportOption = 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: selectedTransportOption == 1
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.directions_bus_filled,
                                color: selectedTransportOption == 1
                                    ? Colors.white
                                    : Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedTransportOption = 2;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: selectedTransportOption == 2
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.drive_eta,
                                color: selectedTransportOption == 2
                                    ? Colors.white
                                    : Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 50.0,
                      child: TextButton(
                        onPressed: () {
                          Provider.of<TravelDetailsProvider>(context,
                                  listen: false)
                              .clearDepartureName();
                          Provider.of<TravelDetailsProvider>(context,
                                  listen: false)
                              .clearDepartureGeoLocation();

                          Provider.of<MarkerProvider>(context, listen: false)
                              .clearPolyline();

                          Provider.of<MarkerProvider>(context, listen: false)
                              .removeDynamicMarkers();

                          departureController.clear();

                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.0,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ))
        : Container(
            padding: const EdgeInsets.all(25.0),
            color: const Color.fromRGBO(100, 100, 100, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () {
                      Provider.of<TravelDetailsProvider>(context, listen: false)
                          .clearDepartureName();

                      Provider.of<TravelDetailsProvider>(context, listen: false)
                          .clearDepartureGeoLocation();

                      Provider.of<MarkerProvider>(context, listen: false)
                          .clearPolyline();

                      Provider.of<MarkerProvider>(context, listen: false)
                          .removeDynamicMarkers();

                      departureController.clear();

                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    destinationController.dispose();
  }
}
