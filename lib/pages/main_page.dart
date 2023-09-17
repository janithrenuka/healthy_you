import 'package:bmicalculator/pages/calculator.dart';
import 'package:bmicalculator/pages/workout.dart';
import 'package:bmicalculator/pages/tips.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[800],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Calculate',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workout Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.tips_and_updates),
            label: 'Tips',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: const Calculator(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Workout(),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Tips(),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Tips(),
        ),
      ][currentPageIndex],
    );
  }
}
