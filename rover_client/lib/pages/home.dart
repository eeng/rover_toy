import 'package:flutter/material.dart';
import './../domain/bluetooth.dart';
import './../widgets/bluetooth_button.dart';
import './../widgets/joystick.dart';
import './../pages/settings.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Bluetooth bluetooth = Bluetooth();
  Map<String, String> sensorData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rover Client'),
        actions: <Widget>[
          BluetoothButton(
            bluetooth: bluetooth,
            onSensorValueReceived: (sensor, value) =>
                setState(() => sensorData[sensor] = value),
            onDeviceDisconnected: () {
              Future.delayed(
                Duration(milliseconds: 100),
                () => setState(() => sensorData.clear()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Joystick(
            onPositionChange: bluetooth.moveRover,
            sensorData: sensorData,
          ),
        ],
      ),
    );
  }
}
