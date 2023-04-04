import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/child_details_screen.dart';

class AllChildsScreen extends StatelessWidget {
  const AllChildsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
      ),
      body: FutureBuilder(
        future: () async {
          final currentUser = FirebaseAuth.instance.currentUser;
          final value = await FirebaseFirestore.instance
              .collection("childs")
              .where("institutionId", isEqualTo: currentUser?.uid)
              .get();
          return value;
        }(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          final data = snapshot.data as QuerySnapshot;
          return data.docs.isEmpty
              ? const Center(child: Text("No childs Found"))
              : ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    final item = data.docs[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ChildDetailsScreen(
                                childRef: item.reference,
                              );
                            },
                          ));
                        },
                        title: Text(item["name"]),
                        subtitle: Text(item["instituteName"]),
                        trailing: Text(item["emergencyContact"]),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, "/child-form");
        },
        icon: const Icon(Icons.add),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
      ),
    );
  }
}
