import 'package:flutter/material.dart';
import 'package:watchful_eye/child_details_screen.dart';
import 'package:watchful_eye/services/firestore_services.dart';

class ChildFormScreen extends StatefulWidget {
  const ChildFormScreen({super.key});

  @override
  State<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends State<ChildFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _institution = "";
  String _emergencyContact = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        alignment: Alignment.center,
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Enter student data",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          size: 90,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Profile Picture",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _name = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your child's name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Name",
                          hintText: "Enter your child's name",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _institution = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your child's institution";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Institution",
                          hintText: "Enter your child's institution",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _emergencyContact = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your child's emergency contact";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Emergency Contact",
                          hintText: "Enter your child's emergency contact",
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final docref = await FireStoreServices.addChild(
                                    name: _name,
                                    instituteName: _institution,
                                    emergencyContact: _emergencyContact)
                                .then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                builder: (context) {
                                  return ChildDetailsScreen(
                                    childRef: value,
                                  );
                                },
                              ), (route) => false);
                            });
                          }
                        },
                        child: const Text("Send Details"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
