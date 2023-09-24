import 'dart:async';
import 'dart:convert';
import 'package:bmicalculator/models/workoutModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {

  
 
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tips',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
