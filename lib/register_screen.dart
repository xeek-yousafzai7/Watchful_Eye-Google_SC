import 'package:flutter/material.dart';
import 'package:watchful_eye/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _phone = "";
  String _password = "";
  String _instituteName = "";
  String _instituteAddress = "";

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
                        "Register",
                        style: TextStyle(
                          fontSize: 24,
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
                            return "Please enter your name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Name",
                          hintText: "Enter your full name",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _email = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!value.contains("@")) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          hintText: "Enter your email",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _phone = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your phone number";
                          } else if (value.length != 11) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Phone",
                          hintText: "Enter your phone num e.g 03121234567",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _password = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          hintText: "Enter your password",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _instituteName = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your institution name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Intitution Name",
                          hintText: "Enter your institution name",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          _instituteAddress = newValue ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your institution address";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Institution Address",
                          hintText: "Enter your institution address",
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _isLoading = true;
                            });
                            _formKey.currentState?.save();
                            try {
                              await AuthServices.signUp(
                                      email: _email,
                                      password: _password,
                                      name: _name,
                                      phone: _phone,
                                      instituteName: _instituteName,
                                      instituteAddress: _instituteAddress)
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registered Successfully"),
                                  ),
                                );
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/child-form", (route) => false);
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
