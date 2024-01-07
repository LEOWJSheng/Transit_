import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Firestore {
  Future<LatLng?> getCurrentBusLocation(String busName) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("buses").doc(busName).get();

    if (snapshot.exists) {
      return LatLng(snapshot.get("lat"), snapshot.get("lon"));
    }
    return null;
  }

  Future<bool> uploadFeedBack(Map<String, dynamic> feedbackData) async {
    try {
      await FirebaseFirestore.instance
          .collection("feedbacks")
          .doc()
          .set(feedbackData);
      return true; // Upload successful
    } catch (error) {
      return false; // Upload failed
    }
  }
}
