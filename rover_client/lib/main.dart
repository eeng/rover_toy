import 'package:flutter/material.dart';
import './pages/home.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    title: 'Rover',
    theme: ThemeData.dark(),
  ));
}
