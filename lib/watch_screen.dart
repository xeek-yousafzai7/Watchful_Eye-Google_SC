import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/extensions/context_extensions.dart';
import 'package:watchful_eye/models/watch_data.dart';
import 'package:watchful_eye/services/firestore_services.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final TextEditingController _watchIdController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _heartBeatController = TextEditingController();
  final TextEditingController _tamperController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _watchIdController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _heartBeatController.dispose();
    _tamperController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  void getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    _watchIdController.text = androidInfo.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watch Screen"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              TextFormField(
                controller: _watchIdController,
                decoration: const InputDecoration(
                  labelText: "Watch Id",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _latitudeController,
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
                  labelText: "Latitude",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _longitudeController,
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
                  labelText: "Longitude",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _heartBeatController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter heart beat";
                  } else if (int.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Heart Beat",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _tamperController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter tamper";
                  } else if (int.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Tamper",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final WatchData watchData = WatchData(
                      id: _watchIdController.text,
                      latitude: double.parse(_latitudeController.text),
                      longitude: double.parse(_longitudeController.text),
                      heartBeat: int.parse(_heartBeatController.text),
                      tamper: int.parse(_tamperController.text),
                    );
                    await FireStoreServices.updateWatchData(watchData).then(
                      (value) {
                        context.showSnackBar("Watch Data Updated");
                      },
                    );
                  }
                },
                child: const Text("Update Watch Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
