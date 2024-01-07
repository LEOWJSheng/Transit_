import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transit_malaya/pages/contact_us.dart';
import 'package:transit_malaya/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:transit_malaya/pages/service_details.dart';
import 'package:transit_malaya/pages/travel_navigation.dart';
import 'package:transit_malaya/provider/bus_map_provider.dart';
import 'package:transit_malaya/provider/travel_details_provider.dart';
import 'package:transit_malaya/widgets/bus_map.dart';

import 'provider/marker_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locationStatus = await Permission.location.request();
  if (locationStatus.isDenied) {
    bool isShown = await Permission.location.shouldShowRequestRationale;

    if (!isShown) {
      showSettingsDialog();
    }
  }

  if (await Permission.location.isGranted) {
    await Firebase.initializeApp();
    runApp(
      const MyApp(),
    );
  }
}

Future<void> showSettingsDialog() async {
  await showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: const Text('Location Permission'),
      content:
          const Text('We need your location to provide accurate services.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context); // Close the dialog
            await openAppSettings();
          },
          child: const Text('Settings'),
        ),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MarkerProvider()),
        ChangeNotifierProvider(create: (context) => BusMapProvider()),
        ChangeNotifierProvider(create: (context) => TravelDetailsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(24, 28, 98, 1),
            primary: const Color.fromRGBO(24, 28, 98, 1),
          ),
          appBarTheme:
              const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            selectedLabelStyle: TextStyle(
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(fontSize: 14),
            selectedIconTheme: IconThemeData(
              size: 36,
            ),
            unselectedIconTheme: IconThemeData(
              size: 26,
            ),
          ),
          useMaterial3: true,
        ),
        home: const Home(),
      ),
    );
  }
}
