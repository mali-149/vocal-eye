import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './bording.dart';
import './navigation/navigation.dart'; // Import your Navigationbar widget

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('token');
    //
    // // Delay to show splash screen
    // await Future.delayed(const Duration(seconds: 4));
    //
    // if (token != null && token.isNotEmpty) {
    //   // If token is saved, navigate to home
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => Navigationbar()),
    //   );
    // }
    // else
    // {
    //   // If token is not saved, go to onboarding screen
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => OnboardingScreen()),
    //   );
    // }
    await Future.delayed(const Duration(seconds: 4));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Navigationbar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.jpg',
          width: 180,
          height: 180,
        ),
      ),
    );
  }
}
