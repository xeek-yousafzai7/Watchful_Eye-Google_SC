import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watchful_eye/services/firestore_services.dart';

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
    super.initState();
    setState(() {
      isWidgetVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FireStoreServices.getChildData(widget.childId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;

          // Display the data in your UI
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Child's Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person_pin_sharp),
                    title: const Text("ID"),
                    subtitle: Text(widget.childId),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: const Text("Name"),
                    subtitle: Text(data?["name"]),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.school),
                    title: const Text("Institution"),
                    subtitle: Text(data?["instituteName"]),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.call),
                    title: const Text("Emergency Contact"),
                    subtitle: Text(data?["emergencyContact"]),
                  ),
                ),
                StreamBuilder(
                  stream: FireStoreServices.watchData(data?["watchId"]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("No Data Found ${snapshot.error}"),
                      );
                    }
                    final watchData = snapshot.data;
                    if (watchData == null) {
                      return const Center(
                        child: Text("No Data Found"),
                      );
                    }
                    final distance = Geolocator.distanceBetween(
                      data?["homeLocation"].latitude,
                      data?["homeLocation"].longitude,
                      watchData.latitude,
                      watchData.longitude,
                    );
                    if (true) {
                    } else if (distance > 10 && isWidgetVisible ||
                        watchData.heartBeat < 60 ||
                        watchData.heartBeat > 100 ||
                        watchData.tamper > 50) {
                      String content = "";
                      if (distance > 10) {
                        content +=
                            "${distance - 10} meters away from safe zone";
                      }
                      if (watchData.heartBeat < 60 ||
                          watchData.heartBeat > 100) {
                        content += "\n\nHeartbeat is not normal";
                      }
                      if (watchData.tamper > 50) {
                        content += "\n\nTamper is detected";
                      }

                      showAlertDialog(
                        context,
                        title: "Child is outside of safe zone\n\n",
                        content: content,
                      );
                    }
                    return Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: const Text("Home Location"),
                                subtitle: Text(
                                  "${data?["homeLocation"].latitude} N, ${data?["homeLocation"].longitude} E",
                                ),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: const Text("Current Location"),
                                subtitle: Text(
                                  "${watchData.latitude} N, ${watchData.longitude} E",
                                ),
                              ),
                            ],
                          ),
                        ),
                        /* Card(
                          child: ListTile(
                            leading: Icon(Icons.monitor_heart_outlined),
                            title: const Text("Heart Beat"),
                            subtitle: Text(
                              "${watchData.heartBeat}",
                            ),
                          ),
                        ), */
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.monitor_heart_outlined,
                                        size: 45,
                                        color: Colors.red,
                                      ),
                                      const Text(
                                        "Heart Beat",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "${watchData.heartBeat}",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        size: 45,
                                        color: Colors.yellow[800],
                                      ),
                                      const Text(
                                        "Tamper",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "${watchData.tamper}",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        /* Card(
                          child: ListTile(
                            leading: Icon(Icons.warning),
                            title: const Text("Tamper"),
                            subtitle: Text(
                              "${watchData.tamper}",
                            ),
                          ),
                        ), */
                        Card(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: GoogleMap(
                              onMapCreated: (controller) {
                                _controller = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  watchData.latitude,
                                  watchData.longitude,
                                ),
                                zoom: 13,
                              ),
                              mapType: MapType.normal,
                              markers: {
                                Marker(
                                  markerId: const MarkerId("currentLocation"),
                                  position: LatLng(
                                    watchData.latitude,
                                    watchData.longitude,
                                  ),
                                ),
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Null> showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        if (_dialogKey.currentContext != null &&
            Navigator.canPop(_dialogKey.currentContext!)) {
          Navigator.pop(_dialogKey.currentContext!);
        }

        final bool isDialogVisible = _dialogKey.currentContext != null;
        if (isDialogVisible) {
          return;
        }
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              key: _dialogKey,
              title: const Text("Alert"),
              content: RichText(
                text: TextSpan(
                  text: title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  children: [
                    TextSpan(
                      text: content,
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
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
