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
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , topRight: Radius.circular(5)),
        ),
        child: NavigationBar(
          height: height * 0.1,
          backgroundColor: const Color.fromARGB(255, 217, 216, 212),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: const Color.fromARGB(255, 44, 180, 243),
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
      ][currentPageIndex],
    );
  }
}
