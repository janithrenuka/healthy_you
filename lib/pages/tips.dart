import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';


class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  var _response = 'dadaffafa';

  @override
  void initState() {
    super.initState();
    initConnectivity();
    ReadJsonData();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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
    });
  }

  Future<Object> ReadJsonData() async {
    _response = '';

    try {
      var url =
          'https://raw.githubusercontent.com/janithrenuka/healthy_you/main/assets/data/mens_workout.json';
      var response = await http.get(Uri.parse(url));

      setState(() {
        _response = jsonDecode(response.body).toString();
      });

      return List.empty();
    } catch (e) {
      return List.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
              child: Column(
                  children: [
                    Text(_response),
                    OutlinedButton(
                        onPressed: () {
                          ReadJsonData();
                        },
                        child: const Text(
                          "Refresh",
                        )
                    ),
                  ],
              ),
          ),
        ),
      ),
    );
  }
}



