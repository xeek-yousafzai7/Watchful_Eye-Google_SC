import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchful_eye/extensions/context_extensions.dart';
import 'package:watchful_eye/parent_zone_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  static String routeName = "/verify-email";

  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isVerified = false;
  User? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (!currentUser!.emailVerified) {
      currentUser!.sendEmailVerification();
    }
    checkEmailVerification();
  }

  void checkEmailVerification() async {
    const int maxDuration = 180; // 3 minutes
    int elapsed = 0;

    while (!isVerified && elapsed < maxDuration) {
      await Future.delayed(const Duration(seconds: 3));
      elapsed += 3;

      await currentUser?.reload();
      currentUser = FirebaseAuth.instance.currentUser;

      setState(() {
        isVerified = currentUser?.emailVerified ?? false;
      });

      if (isVerified) {
        Navigator.of(context).pushReplacementNamed(ParentZoneScren.routeName);
        break;
      }
    }

    if (!isVerified) {
      context.showSnackBar(
        "Email verification timeout. Please reopen the app.",
      );
    }
  }

  void refreshVerificationStatus() async {
    setState(() {
      isLoading = true;
    });

    await currentUser?.reload();
    currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      isVerified = currentUser?.emailVerified ?? false;
      isLoading = false;
    });

    if (isVerified) {
      Navigator.of(context).pushReplacementNamed(ParentZoneScren.routeName);
    } else {
      context.showSnackBar("Email is not verified yet.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/email.jpg",
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Verify Your Email",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "We have sent a verification email to your registered email address. Please check your inbox and verify your email address.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading ? null : refreshVerificationStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Refresh Verification Status",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    await currentUser?.sendEmailVerification();
                    context.showSnackBar("Verification email resent!");
                  },
                  child: const Text(
                    "Resend Verification Email",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
