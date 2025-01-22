import 'package:flutter/material.dart';
import 'package:watchful_eye/child_details_screen.dart';
import 'package:watchful_eye/services/firestore_services.dart';

class ChildFormScreen extends StatefulWidget {
  const ChildFormScreen({super.key});

  static const routeName = "/child-form";

  @override
  State<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends State<ChildFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _parentUserName = "";
  String _emergencyContact = "";
  String _watchId = "";
  bool _isLoading = false;

  double _latitude = 0.0;
  double _longitude = 0.0;

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
                          _watchId = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter watch ID";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Watch ID",
                          hintText: "Enter watch ID",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _parentUserName = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter parent username";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Parent UserName",
                          hintText: "Enter parent username",
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onSaved: (newValue) {
                                _latitude = double.parse(newValue ?? "0.0");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter latitude";
                                } else if (double.tryParse(value) == null) {
                                  return "Please enter a valid number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Latitude",
                                hintText: "Enter latitude",
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              onSaved: (newValue) {
                                _longitude = double.parse(newValue ?? "0.0");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter longitude";
                                } else if (double.tryParse(value) == null) {
                                  return "Please enter a valid number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Longitude",
                                hintText: "Enter longitude",
                              ),
                            ),
                          ),
                        ],
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
                              emergencyContact: _emergencyContact,
                              parentUserName: _parentUserName,
                              watchId: _watchId,
                              latitude: _latitude,
                              longitude: _longitude,
                            ).then(
                              (value) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return ChildDetailsScreen(
                                      childRef: value,
                                    );
                                  },
                                ), (route) => false);
                              },
                            );
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
