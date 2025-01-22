import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/child_details_screen.dart';
import 'package:watchful_eye/dashboard_screen.dart';
import 'package:watchful_eye/extensions/context_extensions.dart';

class AllChildsScreen extends StatelessWidget {
  const AllChildsScreen({super.key});

  static const routeName = "/all-childs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
        actions: [
          IconButton(
            onPressed: () {
              context.push(DashboardScreen());
            },
            icon: const Icon(Icons.dashboard),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Institute Enrolled Childs",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
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
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: data.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemBuilder: (context, index) {
                          final item = data.docs[index];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.orange,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Image.network(
                                        "https://cdn-icons-png.flaticon.com/512/7084/7084446.png",
                                        height: 60,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text("${item.get("name")}"),
                                    const SizedBox(height: 5),
                                    Text("${item.get("parentUserName")}")
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: -0,
                                right: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    context.push(
                                      ChildDetailsScreen(
                                          childRef: item.reference),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("View More"),
                                  ),
                                ),
                              ),
                            ],
                          );
                          /* return Card(
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
                              subtitle: Text(item["parentUserName"]),
                              trailing: Text(item["emergencyContact"]),
                            ),
                          ); */
                        },
                      );
              },
            ),
          ),
        ],
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
