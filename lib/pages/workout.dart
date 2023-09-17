import 'package:flutter/material.dart';

class Workout extends StatefulWidget {
  const Workout({super.key});

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String gender = 'M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'M';
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 175,
                      decoration: BoxDecoration(
                        color: gender == 'M'
                            ? Colors.orange.withAlpha(150)
                            : Colors.orange.withAlpha(50),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.male,
                            size: 50,
                          ),
                          Text("Men"),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'F';
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 175,
                      decoration: BoxDecoration(
                        color: gender == 'F'
                            ? Colors.orange.withAlpha(150)
                            : Colors.orange.withAlpha(50),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.female,
                            size: 50,
                          ),
                          Text("Women"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
