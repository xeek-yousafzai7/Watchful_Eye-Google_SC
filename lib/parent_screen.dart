import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/services/firestore_services.dart';
import 'package:watchful_eye/watching_child_screen.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key, required this.parentUsername});

  final String parentUsername;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$parentUsername's Parent Zone"),
      ),
      body: FutureBuilder(
        future: FireStoreServices.getAllChilds(parentUsername),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                final data = snapshot.data as List<DocumentSnapshot>;
                if (data.isEmpty) {
                  return const Center(
                    child: Text("No Childs Found"),
                  );
                }
                return ListView.builder(
                  itemCount: data.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final child = data[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          "https://cdn-icons-png.flaticon.com/512/7084/7084446.png",
                        ),
                        title: Text(child["name"]),
                        subtitle: Text(child["instituteName"]),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return WatchingChildScreen(
                                  childId: child.id,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No Childs Found"),
                );
              }
            default:
              return const Center(
                child: Text("Something went wrong"),
              );
          }
        },
      ),
    );
  }
}
