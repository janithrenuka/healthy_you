import 'package:bmicalculator/constants.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int height = 150;
  int weight = 70;

  String gender = 'M';

  late double bmi = calculateBmi(height: height, weight: weight);

  double calculateBmi({required int height, required int weight}) {
    return (weight / (height * height)) * 10000;
  }

  String getResult(bmi) {
    if (bmi >= 25) {
      return "Overweight";
    } else if (bmi > 18.5) {
      return "Normal";
    } else {
      return "Underweight";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'M';
                        print(gender);
                      });
                    },
                    child: Container(
                      height: 200,
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
                            size: 150,
                          ),
                          Text("Male"),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'F';
                        print(gender);
                      });
                    },
                    child: Container(
                      height: 200,
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
                            size: 150,
                          ),
                          Text("Female"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("Height"),
                        Text("$height", style: kInputLabelColor),
                        Row(children: [
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                if (height > 50) {
                                  height--;
                                  bmi = calculateBmi(
                                      height: height, weight: weight);
                                }
                              });
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                if (height < 220) {
                                  height++;
                                  bmi = calculateBmi(
                                      height: height, weight: weight);
                                }
                              });
                            },
                            child: const Icon(
                              Icons.add,
                              size: 40,
                            ),
                          )
                        ]),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("Weight"),
                        Text(
                          "$weight",
                          style: kInputLabelColor,
                        ),
                        Row(children: [
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                if (weight > 35) {
                                  weight--;
                                  bmi = calculateBmi(
                                      height: height, weight: weight);
                                }
                              });
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 40,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                if (weight < 300) {
                                  weight++;
                                  bmi = calculateBmi(
                                      height: height, weight: weight);
                                }
                              });
                            },
                            child: const Icon(
                              Icons.add,
                              size: 40,
                            ),
                          )
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  const Text("BMI"),
                  Text(
                    bmi.toStringAsFixed(2),
                    style: kInputLabelColor.copyWith(
                        color: kOutputTextColor, fontSize: 60),
                  ),
                  Text(
                    getResult(bmi),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
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
