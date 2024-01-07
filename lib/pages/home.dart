import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transit_malaya/pages/announcement.dart';
import 'package:transit_malaya/pages/side_nav_bar.dart';
import 'package:transit_malaya/pages/travel.dart';
import 'package:transit_malaya/widgets/bus_map.dart';
import 'package:transit_malaya/widgets/bus_map_options.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedPage = 0;
  List<Marker> markerList = [];

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    // checkPermission(Permission.location, context);

    final List<Widget> pages = [
      Column(
        children: [
          Expanded(
            child: BusMap(
              actionOnMap: () {},
            ),
          ),
          const BusMapOption(),
        ],
      ),
      const Travel(),
      const Announcement(),
    ];

    return SafeArea(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Transit Malaya",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          elevation: 5,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: pages[selectedPage],
        // body: const Travel(),
        drawer: const SideNavbar(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          onTap: (value) {
            setState(() {
              selectedPage = value;
            });
          },
          backgroundColor: Theme.of(context).primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              label: "Routes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Travel",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notifications",
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> checkPermission(
  //     Permission permission, BuildContext context) async {
  //   final status = await permission.request();

  //   if (status == PermissionStatus.granted) {
  //     // Permission is granted
  //     return;
  //   } else if (status == PermissionStatus.denied) {
  //     // Permission is denied
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Location Permission Required'),
  //           content: const Text(
  //               'This app needs location permission to function properly. Please enable location access in your device settings.'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else if (status == PermissionStatus.permanentlyDenied) {
  //     // Permission is permanently denied
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Location Permission Required'),
  //           content: const Text(
  //               'This app needs location permission to function properly. Please enable location access in your device settings.'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //               child: const Text('Cancel'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 openAppSettings(); // Open app settings
  //               },
  //               child: const Text('Open Settings'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
}
