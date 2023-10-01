// ignore_for_file: annotate_overrides

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bmicalculator/models/workoutModel.dart';
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
  bool isLoading = true;

  String selectedGender = '';
  String selectedTypeName = '';
  int selectedType = 1;

  List<WorkoutModel> workoutDetails = [];
  List<WorkoutModel> filteredWorkouts = [];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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

      if (_connectionStatus == ConnectivityResult.wifi ||
          _connectionStatus == ConnectivityResult.mobile) {
        isConnected = true;
        fetchWorkoutData();
      } else {
        isConnected = false;
      }
    });
  }

  Future<void> setCardHeader() async {
    setState(() {
      if (gender == 'M') {
        selectedGender = EnumData.men;
      } else {
        selectedGender = EnumData.women;
      }

      if (type == 1) {
        selectedType = EnumData.beginnerEnum;
        selectedTypeName = EnumData.beginner;
      } else if (type == 2) {
        selectedType = EnumData.intermidateEnum;
        selectedTypeName = EnumData.intermidate;
      } else {
        selectedType = EnumData.expertEnum;
        selectedTypeName = EnumData.expert;
      }

      debugPrint(selectedType.toString());
      debugPrint(selectedTypeName);
      debugPrint(selectedGender);
    });
  }

  Future<void> fetchWorkoutData() async {
    filteredWorkouts = [];
    if (isConnected == true) {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/janithrenuka/healthy_you/main/assets/data/mens_workout.json'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body)['workoutDetails'];
        workoutDetails =
            jsonData.map((data) => WorkoutModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load workout data');
      }
      filteredWorkouts = getFilteredWorkouts(workoutDetails);
    }
  }

  List<WorkoutModel> getFilteredWorkouts(workouts) {
    debugPrint(workouts.isEmpty.toString());
    return workouts.where((workout) => workout.type == selectedType).toList();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    //set defaults
    selectedGender = EnumData.men;
    selectedType = EnumData.beginnerEnum;
    selectedTypeName = EnumData.beginner;

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    if (_connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.mobile) {
      isConnected = true;
      Future.delayed(Duration.zero, () async {
        await fetchWorkoutData();
      });
      setCardHeader();
    } else {
      isConnected = false;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isConnected
            ? Column(
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
                            fetchWorkoutData();
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
                                    ? const Color.fromARGB(255, 29, 65, 226)
                                        .withAlpha(150)
                                    : const Color.fromARGB(255, 190, 206, 214)
                                        .withAlpha(50),
                                borderRadius: BorderRadius.circular(25),
                                border: gender == 'M'
                                    ? Border.all(
                                        width: 2.0,
                                        color: const Color.fromARGB(
                                            255, 209, 198, 124))
                                    : null),
                            padding: const EdgeInsets.all(8.0),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.male,
                                  size: 50,
                                ),
                                Text(
                                  "Men",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
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
                            fetchWorkoutData();
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
                                    ? const Color.fromARGB(255, 227, 32, 178)
                                        .withAlpha(150)
                                    : const Color.fromARGB(255, 199, 148, 191)
                                        .withAlpha(50),
                                borderRadius: BorderRadius.circular(25),
                                border: gender == 'F'
                                    ? Border.all(
                                        width: 2.0,
                                        color: const Color.fromARGB(
                                            255, 209, 198, 124))
                                    : null),
                            padding: const EdgeInsets.all(8.0),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.female,
                                  size: 50,
                                ),
                                Text(
                                  "Women",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
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
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                type = 1;
                                setCardHeader();
                                fetchWorkoutData();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: type == 1
                                  ? Colors.white
                                  : const Color.fromARGB(255, 30, 188, 36),
                              backgroundColor: type == 1
                                  ? const Color.fromARGB(255, 30, 188, 36)
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
                                fetchWorkoutData();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: type == 2
                                  ? Colors.white
                                  : const Color.fromARGB(255, 225, 202, 28),
                              backgroundColor: type == 2
                                  ? const Color.fromARGB(255, 225, 202, 28)
                                  : Colors.white,
                              side: const BorderSide(
                                color: Color.fromARGB(255, 225, 202, 28),
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
                                fetchWorkoutData();
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
                  Text(
                    // Card Header
                    '$selectedGender - $selectedTypeName',
                    style: TextStyle(
                        color: type == 1
                            ? const Color.fromARGB(255, 30, 188, 36)
                            : type == 2
                                ? const Color.fromARGB(255, 225, 202, 28)
                                : Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Image(
                    height: 90,
                    width: width * 0.4,
                    image: image,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: filteredWorkouts.isNotEmpty
                          ? ListView.builder(
                              itemCount: filteredWorkouts.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0.0,
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${filteredWorkouts[index].perWeek} times per week',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: filteredWorkouts[index]
                                              .workout
                                              .map((exercise) => Text(
                                                    '• $exercise',
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                "Refresh the Tab...",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )
            : const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        width: 150,
                        height: 150,
                        image: AssetImage('assets/images/no-wifi.png'),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
                        child: Text(
                          'No internet connection. Please check your network.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ]),
              ),
      ),
    );
  }
}
