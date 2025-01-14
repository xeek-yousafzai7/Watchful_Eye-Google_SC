import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/services/firestore_services.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: FireStoreServices.getInstitutionData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          final data = snapshot.data!;

          return InstituteDetails(data: data);
          /* return Column(
            children: [
              // Institute Name
              ListTile(
                title: const Text("Institute Name"),
                subtitle: Text(snapshot.data["name"]),
              ),
              // Email
              ListTile(
                title: const Text("Email"),
                subtitle: Text(snapshot.data["email"]),
              ),
              // Phone
              ListTile(
                title: const Text("Phone"),
                subtitle: Text(snapshot.data["phone"]),
              ),
              ListTile(
                title: const Text("Total Childs"),
                subtitle: Text("${snapshot.data["totalChildren"]}"),
              ),

              ListTile(
                title: const Text("Present Childs"),
                subtitle: Text("${snapshot.data["totalChildren"]}"),
              ),
              ListTile(
                title: const Text("Absent Childs"),
                subtitle: Text("0"),
              ),
            ],
          ); */
        },
      ),
    );
  }
}

class InstituteDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  const InstituteDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                  icon: FontAwesomeIcons.school,
                  title: "Institute Name",
                  value: data["name"],
                  isLeftAlign: true,
                ),
                const Divider(),
                _buildDetailRow(
                  icon: FontAwesomeIcons.envelope,
                  title: "Email",
                  value: data["email"],
                  isLeftAlign: true,
                ),
                const Divider(),
                _buildDetailRow(
                  icon: FontAwesomeIcons.phone,
                  title: "Phone",
                  value: data["phone"],
                  isLeftAlign: true,
                ),
                const Divider(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: _buildDetailRow(
                    icon: FontAwesomeIcons.child,
                    title: "Total Children",
                    value: "20",
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailRow(
                        icon: FontAwesomeIcons.check,
                        title: "Present Children",
                        value: "17",
                        iconColor: Colors.green,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 2,
                      color: Colors.black12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _buildDetailRow(
                        icon: FontAwesomeIcons.xmark,
                        title: "Absent Children",
                        value: "03",
                        iconColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    Color iconColor = Colors.blueAccent,
    bool isLeftAlign = false,
  }) {
    return Column(
      crossAxisAlignment:
          isLeftAlign ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: 20,
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
