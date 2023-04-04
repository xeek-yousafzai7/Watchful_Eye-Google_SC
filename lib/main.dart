import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/all_childs_screen.dart';
import 'package:watchful_eye/child_details_screen.dart';
import 'package:watchful_eye/child_form_screen.dart';
import 'package:watchful_eye/login_screen.dart';
import 'package:watchful_eye/parent_zone_screen.dart';
import 'package:watchful_eye/register_screen.dart';
import 'package:watchful_eye/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/parent-zone": (context) => const ParentZoneScren(),
        "/child-form": (context) => const ChildFormScreen(),
        "/register": (context) => const RegisterScreen(),
        "/all-childs": (context) => const AllChildsScreen(),
      },
    );
  }
}
