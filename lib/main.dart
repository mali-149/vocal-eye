import 'package:flutter/material.dart';
import './splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0068CB)),
        fontFamily: 'Roboto',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade100,
          // labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0068CB), width: 2.0),
              borderRadius: BorderRadius.circular(10)

          ),

        ),

      ),
      debugShowCheckedModeBanner: false,


      home: Splash(),
    );
  }
}











