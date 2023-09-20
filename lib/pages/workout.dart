// ignore_for_file: annotate_overrides

import 'dart:convert';
import 'package:bmicalculator/models/day_workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

class Workout extends StatefulWidget {
  const Workout({super.key});

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String gender = 'M';
  List dayCards = [];
  AssetImage image = const AssetImage('assets/images/man_workout.gif');

  void initState() {
    super.initState();
  }

  Future<List<DayWorkut>> ReadJsonData() async {
    final jsonData = await rootBundle.rootBundle.loadString('assets/data/mens_workout.json');
    final list = json.decode(jsonData) as List<dynamic>;

    return list.map((e) => DayWorkut.fromJson(e)).toList();
  }

  // Future<void> loadJsonDataMen() async {
  //   final String jsonstringMen =
  //       await rootBundle.loadString('assets/data/mens_workout.json');

  //   var items = json.decode(jsonstringMen);

  //   setState(() {
  //     dayCards = items;
  //   });
  // }

  // Future<void> loadJsonDataWomen() async {
  //   final String jsonstringWomen =
  //       await rootBundle.loadString('assets/data/womens_workout.json');

  //   var items = json.decode(jsonstringWomen);

  //   setState(() {
  //     dayCards = items;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {

              var days = data.data as List<DayWorkut>;

              return Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = 'M';
                              image = const AssetImage(
                                  'assets/images/man_workout.gif');
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
                              image = const AssetImage(
                                  'assets/images/women_workout.gif');
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
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: width * 0.92,
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      width: 0.5,
                                      color: const Color.fromARGB(
                                          255, 199, 196, 196),
                                    ),
                                    color:
                                        const Color.fromARGB(255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 230, 225, 225)
                                            .withOpacity(0.8),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Day :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "Type :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              days[index].day.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              days[index].type.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Image(
                                                    height: 90,
                                                    width: 200,
                                                    image: image,
                                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),                                                    BlendMode.srcOver)
                                                  )
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
