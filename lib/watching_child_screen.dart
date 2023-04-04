import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WatchingChildScreen extends StatefulWidget {
  const WatchingChildScreen({super.key, required this.childId});
  final String childId;

  @override
  State<WatchingChildScreen> createState() => _WatchingChildScreenState();
}

class _WatchingChildScreenState extends State<WatchingChildScreen> {
  final GlobalKey _dialogKey = GlobalKey();
  GoogleMapController? _controller;
  bool isWidgetVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isWidgetVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final documentReference =
        FirebaseFirestore.instance.collection("childs").doc(widget.childId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: documentReference.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final distance = Geolocator.distanceBetween(
            data?["homeLocation"].latitude,
            data?["homeLocation"].longitude,
            data?["currentLocation"].latitude,
            data?["currentLocation"].longitude,
          );
          if (distance > 10 && isWidgetVisible) {
            Future.delayed(const Duration(seconds: 3), () {
              if (_dialogKey.currentContext != null &&
                  Navigator.canPop(_dialogKey.currentContext!)) {
                Navigator.pop(_dialogKey.currentContext!);
              }
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    key: _dialogKey,
                    title: const Text("Alert"),
                    content: RichText(
                      text: TextSpan(
                        text: "Child is outside of safe zone\n\n",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: "${distance - 10} meters away from safe zone",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            });
          }

          // Display the data in your UI
          return Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Your Child's Information"),
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      title: const Text("ID"),
                      subtitle: Text(widget.childId),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Name"),
                      subtitle: Text(data?["name"]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Institution"),
                      subtitle: Text(data?["instituteName"]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Emergency Contact"),
                      subtitle: Text(data?["emergencyContact"]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Latitude"),
                      subtitle:
                          Text((data?["currentLocation"].latitude).toString()),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Longitude"),
                      subtitle:
                          Text((data?["currentLocation"].longitude).toString()),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GoogleMap(
                        onMapCreated: (controller) {
                          _controller = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            data?["currentLocation"].latitude,
                            data?["currentLocation"].longitude,
                          ),
                          zoom: 14.4746,
                        ),
                        mapType: MapType.hybrid,
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("currentLocation"),
                            points: [
                              LatLng(
                                data?["currentLocation"].latitude,
                                data?["currentLocation"].longitude,
                              ),
                              LatLng(
                                data?["homeLocation"].latitude,
                                data?["homeLocation"].longitude,
                              ),
                            ],
                            width: 2,
                          ),
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId("currentLocation"),
                            position: LatLng(
                              data?["currentLocation"].latitude,
                              data?["currentLocation"].longitude,
                            ),
                          ),
                          Marker(
                            markerId: const MarkerId("homeLocation"),
                            position: LatLng(
                              data?["homeLocation"].latitude,
                              data?["homeLocation"].longitude,
                            ),
                          ),
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
