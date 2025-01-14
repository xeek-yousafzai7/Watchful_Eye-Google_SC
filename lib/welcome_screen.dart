import 'package:flutter/material.dart';
import 'package:watchful_eye/watch_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchful Eye"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/eye_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .55,
              ),
              const Text(
                "Welcome to Watchful Eye",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text("Login as Institue"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/parent-zone");
                },
                child: const Text("Parent Zone"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const WatchScreen();
            }),
          );
        },
        child: const Icon(Icons.watch),
      ),
    );
  }
}
