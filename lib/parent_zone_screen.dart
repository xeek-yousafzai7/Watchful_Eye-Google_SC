import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/services/firestore_services.dart';
import 'package:watchful_eye/watching_child_screen.dart';

class ParentZoneScren extends StatelessWidget {
  const ParentZoneScren({super.key});

  @override
  Widget build(BuildContext context) {
    String childId = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Welcome to Parent Zone"),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                childId = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Child ID",
                hintText: "Enter your child's ID",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                DocumentSnapshot snapshot = await firestore
                    .collection("childs")
                    .doc(childId)
                    .get()
                    .then((value) {
                  if (value.exists) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return WatchingChildScreen(childId: childId);
                      },
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Child not found"),
                      ),
                    );
                  }
                  return value;
                });
              },
              child: const Text("Track Child"),
            ),
          ],
        ),
      ),
    );
  }
}
