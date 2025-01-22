import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/all_childs_screen.dart';
import 'package:watchful_eye/child_details_screen.dart';
import 'package:watchful_eye/child_form_screen.dart';
import 'package:watchful_eye/login_screen.dart';
import 'package:watchful_eye/parent_zone_screen.dart';
import 'package:watchful_eye/register_screen.dart';
import 'package:watchful_eye/verify_email_screen.dart';
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
        primarySwatch: Colors.orange,
      ),
      home: const WelcomeScreen(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        ParentZoneScren.routeName: (context) => const ParentZoneScren(),
        ChildFormScreen.routeName: (context) => const ChildFormScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        AllChildsScreen.routeName: (context) => const AllChildsScreen(),
        VerifyEmailScreen.routeName: (context) => const VerifyEmailScreen(),
      },
    );
  }
}
