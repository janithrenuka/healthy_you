// ignore_for_file: annotate_overrides

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bmicalculator/models/day_workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bmicalculator/enum.dart' as EnumData;
import 'package:swipe_refresh/swipe_refresh.dart';

class Workout extends StatefulWidget {
  const Workout({super.key});

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String gender = 'M';
  int type = 1;
  bool isConnected = true;
  AssetImage image = const AssetImage('assets/images/man_workout.gif');

  String selectedGender = '';
  String selectedType = '';

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    //set defaults
    selectedGender = EnumData.men;
    selectedType = EnumData.beginner;

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    if (_connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.mobile) {
      isConnected = true;
      ReadJsonData();
      setCardHeader();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
    isConnected = false;
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;

      if (_connectionStatus == ConnectivityResult.none) {
        isConnected = true;
      }
    });
  }

  Future<List<DayWorkut>> ReadJsonData() async {
    try {
      var url =
          'https://raw.githubusercontent.com/janithrenuka/healthy_you/main/assets/data/womens_workout.json';
      var response = await http.get(Uri.parse(url));

      final list = json.decode(response.body) as List<dynamic>;

      return list.map((e) => DayWorkut.fromJson(e)).toList();
    } catch (e) {
      return List.empty();
    }
  }

  Future<void> setCardHeader() async {
    setState(() {
      if (gender == 'M') {
        selectedGender = EnumData.men;
      } else {
        selectedGender = EnumData.women;
      }

      if (type == 1) {
        selectedType = EnumData.beginner;
      } else if (type == 2) {
        selectedType = EnumData.intermidate;
      } else {
        selectedType = EnumData.expert;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: isConnected
              ? FutureBuilder(
                  future: ReadJsonData(),
                  builder: (context, data) {
                    if (data.hasError) {
                      return Center(child: Text("${data.error}"));
                    } else if (data.hasData) {
                      var days = data.data as List<DayWorkut>;

                      return Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gender = 'M';
                                    image = const AssetImage(
                                        'assets/images/man_workout.gif');
                                    setCardHeader();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, left: 10.0, top: 8.0),
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
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gender = 'F';
                                    image = const AssetImage(
                                        'assets/images/women_workout.gif');
                                    setCardHeader();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, left: 10.0, top: 8.0),
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
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        type = 1;
                                        setCardHeader();
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: type == 1
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 30, 188, 36),
                                      backgroundColor: type == 1
                                          ? const Color.fromARGB(
                                              255, 30, 188, 36)
                                          : Colors.white,
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 30, 188, 36),
                                      ),
                                    ),
                                    child: const Text(
                                      "Beginner",
                                    )),
                                const Spacer(),
                                OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        type = 2;
                                        setCardHeader();
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: type == 2
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 225, 202, 28),
                                      backgroundColor: type == 2
                                          ? const Color.fromARGB(
                                              255, 225, 202, 28)
                                          : Colors.white,
                                      side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 225, 202, 28),
                                      ),
                                    ),
                                    child: const Text(
                                      "Intermidate",
                                    )),
                                const Spacer(),
                                OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        type = 3;
                                        setCardHeader();
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          type == 3 ? Colors.white : Colors.red,
                                      backgroundColor:
                                          type == 3 ? Colors.red : Colors.white,
                                      side: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    child: const Text(
                                      "Expert",
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  Text( // Card Header
                                    '$selectedGender - $selectedType',
                                    style: TextStyle(
                                        color: type == 1 ? const Color.fromARGB(255, 30, 188, 36) : type == 2 ? const Color.fromARGB(255, 225, 202, 28) : Colors.red,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Divider(),
                                  const Text(
                                    "Workout",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image(
                                        height: 90,
                                        width: width * 0.4,
                                        image: image,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(  // Strength workout
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Strength",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Sans-Serif',
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(  // Cardio workout
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cardio",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Sans-Serif',
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(),
                                  const Row( // Meal
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Meal Plan",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Image(
                                        height: 90,
                                        width: width * 0.4,
                                        image: const AssetImage('assets/images/food.png'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(  // Breakfast Meal
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Breakfast",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Sans-Serif',
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(  // Lunch Meal
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lunch",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Sans-Serif',
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(  // Dinner Meal
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dinner",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Sans-Serif',
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(  // Snacks
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Snacks",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Sans-Serif',
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No internet connection. Please check your network.',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ] 
                  ),
                ),
        ),
      ),
    );
  }
}
