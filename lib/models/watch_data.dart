import 'package:cloud_firestore/cloud_firestore.dart';

class WatchData {
  final String id;
  final int heartBeat;
  final double latitude;
  final double longitude;
  final int tamper;

  WatchData({
    required this.id,
    required this.heartBeat,
    required this.latitude,
    required this.longitude,
    required this.tamper,
  });

  factory WatchData.fromMap(Map<String, dynamic> data) {
    return WatchData(
      id: data["id"],
      heartBeat: data["heartbeat"],
      latitude: data["location"].latitude,
      longitude: data["location"].longitude,
      tamper: data["tamper"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "heartbeat": heartBeat,
      "location": GeoPoint(latitude, longitude),
      "tamper": tamper,
    };
  }
}
