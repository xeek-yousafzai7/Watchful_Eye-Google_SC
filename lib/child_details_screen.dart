import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:watchful_eye/services/firestore_services.dart';

class ChildDetailsScreen extends StatefulWidget {
  const ChildDetailsScreen({super.key, required this.childRef});
  final DocumentReference childRef;

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  // Position? _currentPosition;
  Position? _homePosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ListView(
          children: [
            DrawerHeader(
              curve: Curves.easeIn,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      "Watchful Eye",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Parent Zone"),
                onTap: () {
                  Navigator.pushNamed(context, "/parent-zone");
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("All Childs"),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/all-childs", (_) => false);
                },
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: widget.childRef.get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final child = snapshot.data as DocumentSnapshot;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Child's Information",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        title: const Text("ID"),
                        subtitle: SelectableText(child.id),
                        trailing: IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: child.id),
                            );
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Name"),
                        subtitle: Text(child.get("name")),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Parent UserName"),
                        subtitle: Text(
                            child.get("parentUserName") ?? "Not Available"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Institution"),
                        subtitle: Text(child.get("institutionId")),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Emergency Contact"),
                        subtitle: Text(child.get("emergencyContact")),
                      ),
                    ),
                    /* Card(
                      child: ListTile(
                        title: const Text("Home Location"),
                        subtitle: Text(
                          child.get("homeLocation") != null
                              ? "${child.get("homeLocation").latitude}, ${child.get("homeLocation").longitude}"
                              : _homePosition == null
                                  ? "Not Available"
                                  : "${_homePosition!.latitude}, ${_homePosition!.longitude}",
                        ),
                      ),
                    ), */
                    if (child.get("watchId") != null)
                      FutureBuilder(
                        future: FireStoreServices.getWatchData(
                          child.get("watchId") ?? "watchId",
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final watchData = snapshot.data as DocumentSnapshot;
                          return Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: const Text("Current Location"),
                                  subtitle: Text(
                                    watchData.get("location") != null
                                        ? "${watchData.get("location").latitude}, ${watchData.get("location").longitude}"
                                        : "Not Available",
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: const Text("Heart Beat"),
                                  subtitle: Text(
                                    watchData.get("heartbeat") != null
                                        ? "${watchData.get("heartbeat")} bpm"
                                        : "Not Available",
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: const Text("Tamper"),
                                  subtitle: Text(
                                    watchData.get("tamper") != null
                                        ? "${watchData.get("tamper")}"
                                        : "Not Available",
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                    /* ElevatedButton(
                      onPressed: () async {
                        // print(child.reference.id);
                        final pemission = await Geolocator.checkPermission();
                        if (pemission == LocationPermission.denied) {
                          await Geolocator.requestPermission();
                        }
                        final homePosition =
                            await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );
                        child.reference.update({
                          "homeLocation": GeoPoint(
                            homePosition.latitude,
                            homePosition.longitude,
                          ),
                        });
                        if (mounted) {
                          setState(() {
                            _homePosition = homePosition;
                          });
                        }
              
                        Geolocator.getPositionStream().listen((event) {
                          child.reference.update({
                            "currentLocation": GeoPoint(
                              event.latitude,
                              event.longitude,
                            ),
                          });
                          if (mounted) {
                            setState(() {
                              _currentPosition = event;
                            });
                          }
                        });
                        // final position = await Geolocator.getCurrentPosition(
                        //   desiredAccuracy: LocationAccuracy.high,
                        // );
                        // child.reference.update({
                        //   "currentLocation": GeoPoint(
                        //     position.latitude,
                        //     position.longitude,
                        //   ),
                        // });
                      },
                      child: const Text("fetch location"),
                    ), */
                  ],
                ),
              );

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
