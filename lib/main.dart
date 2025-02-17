import 'package:flutter/material.dart';
import 'league.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liga Bola',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LeagueListPage(),
    );
  }
}