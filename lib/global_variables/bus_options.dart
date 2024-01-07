import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final buses = [
  {
    "name": "AB",
    "color": const Color.fromARGB(255, 0, 30, 90),
    "markerOptions": [
      {
        "markerId": const MarkerId("UM Sentral"),
        "position": const LatLng(3.121204981133347, 101.65367399567317),
        "infoWindow": const InfoWindow(title: "UM Sentral"),
      },
      {
        "markerId": const MarkerId("KK3/4/7"),
        "position": const LatLng(3.124506832127239, 101.65152807095672),
        "infoWindow": const InfoWindow(title: "KK3/4/7"),
      },
      {
        "markerId": const MarkerId("KK8"),
        "position": const LatLng(3.1297706116345987, 101.65010119233135),
        "infoWindow": const InfoWindow(title: "KK8"),
      },
      {
        "markerId": const MarkerId("Academy of Islamic Studies(API)"),
        "position": const LatLng(3.1329807976474773, 101.657570789978),
        "infoWindow":
            const InfoWindow(title: "Academy of Islamic Studies(API)"),
      },
      {
        "markerId": const MarkerId("KK11"),
        "position": const LatLng(3.129541566879574, 101.66017003594187),
        "infoWindow": const InfoWindow(title: "KK11"),
      },
      {
        "markerId": const MarkerId("KK12"),
        "position": const LatLng(3.1266968412949288, 101.65974503960912),
        "infoWindow": const InfoWindow(title: "KK12"),
      },
      {
        "markerId": const MarkerId("KK1"),
        "position": const LatLng(3.1182471283702013, 101.65933941869564),
        "infoWindow": const InfoWindow(title: "KK1"),
      },
      {
        "markerId": const MarkerId("Faculty of Engineering"),
        "position": const LatLng(3.119190202407765, 101.65555469703942),
        "infoWindow": const InfoWindow(title: "Faculty of Engineering"),
      },
      {
        "markerId": const MarkerId("UM Sentral"),
        "position": const LatLng(3.121204981133347, 101.65367399567317),
        "infoWindow": const InfoWindow(title: "UM Sentral"),
      },
    ],
    "schedule": "assets/AB_BA_E_schedule.jpg"
  },
  {
    "name": "BA",
    "color": const Color.fromARGB(255, 0, 90, 30),
    "markerOptions": [
      {
        "markerId": const MarkerId("UM Sentral"),
        "position": const LatLng(3.121204981133347, 101.65367399567317),
        "infoWindow": const InfoWindow(title: "UM Sentral"),
      },
      {
        "markerId": const MarkerId("Pasum"),
        "position": const LatLng(3.121819966640032, 101.65825678058702),
        "infoWindow": const InfoWindow(title: "Pasum"),
      },
      {
        "markerId": const MarkerId("KK5"),
        "position": const LatLng(3.1266957539613327, 101.65974861377771),
        "infoWindow": const InfoWindow(title: "KK5"),
      },
      {
        "markerId": const MarkerId("Academy of Islamic Studies(API)"),
        "position": const LatLng(3.1329807976474773, 101.657570789978),
        "infoWindow":
            const InfoWindow(title: "Academy of Islamic Studies(API)"),
      },
      {
        "markerId": const MarkerId("KK8"),
        "position": const LatLng(3.1297706116345987, 101.65010119233135),
        "infoWindow": const InfoWindow(title: "KK8"),
      },
      {
        "markerId": const MarkerId("Academy of Malay Studies(APM)"),
        "position": const LatLng(3.126194059065697, 101.65158966304091),
        "infoWindow": const InfoWindow(title: "Academy of Malay Studies(APM)"),
      },
      {
        "markerId": const MarkerId("KK3/4/7"),
        "position": const LatLng(3.124506832127239, 101.65152807095672),
        "infoWindow": const InfoWindow(title: "KK3/4/7"),
      },
      {
        "markerId": const MarkerId("Faculty of Science"),
        "position": const LatLng(3.1219524009481963, 101.65352793895883),
        "infoWindow": const InfoWindow(title: "Faculty of Science"),
      },
      {
        "markerId": const MarkerId("UM Sentral"),
        "position": const LatLng(3.121204981133347, 101.65367399567317),
        "infoWindow": const InfoWindow(title: "UM Sentral"),
      },
    ],
    "schedule": "assets/AB_BA_E_schedule.jpg"
  },
  {
    "name": "C",
    "color": const Color.fromARGB(255, 30, 0, 90),
    "schedule": "assets/C_D_schedule.jpg"
  },
  {
    "name": "D",
    "color": const Color.fromARGB(255, 90, 0, 30),
    "schedule": "assets/C_D_schedule.jpg"
  },
  {
    "name": "E",
    "color": const Color.fromARGB(255, 90, 30, 0),
    "schedule": "assets/AB_BA_E_schedule.jpg"
  },
];

final uniPlaces = [
  {
    "name": "Kolej Kediaman Pertama",
    "category": "college",
    "lat": 3.1176708543420193,
    "lng": 101.65932309567313,
  },
  {
    "name": "Kolej Kediaman Kedua",
    "category": "college",
    "lat": 3.1178442591180042,
    "lng": 101.65720062908372,
  },
  {
    "name": "Kolej Kediaman Ketiga",
    "category": "college",
    "lat": 3.1240961320565126,
    "lng": 101.65009579567312,
  },
  {
    "name": "Kolej Kediaman Keempat",
    "category": "college",
    "lat": 3.125038866047452,
    "lng": 101.64949498082262,
  },
  {
    "name": "Kolej Kediaman Kelima",
    "category": "college",
    "lat": 3.1269921854335365,
    "lng": 101.65943447030119,
  },
];

const apiKey = "${MAP_API_KEY}";
