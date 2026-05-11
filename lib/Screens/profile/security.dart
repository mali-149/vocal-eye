import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Color(0xFF0068CB),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 20),
              Text(
                "Introduction",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Welcome to VocalEye. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our assistive app designed to empower blind and visually impaired users through audio-based navigation, object detection, and accessibility features.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "Information We Collect",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "VocalEye may collect personal information such as your name, email address, and usage behavior within the app. We may also request access to your device's camera, microphone, and location to provide accurate and real-time assistance.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "How We Use Your Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "1. To enable features like voice navigation, object recognition, and text-to-speech.\n"
                    "2. To improve app performance, accessibility, and user experience.\n"
                    "3. To provide personalized support and respond to user inquiries.\n"
                    "4. To analyze anonymous usage patterns for service improvements.\n"
                    "5. To comply with legal and regulatory requirements.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "Camera and Microphone Access",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "VocalEye uses your camera to identify objects, text, or surroundings and provides spoken feedback. The microphone may be used for voice commands or audio prompts. These features are essential to provide real-time assistance and are never used for surveillance or stored without your consent.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "Location Data",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "VocalEye may use your location to provide relevant navigation and situational guidance. Location data is used solely to enhance the app's assistive features and is never shared with third parties without your permission.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "Data Security",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We use modern security practices to protect your personal data. While we strive to use commercially acceptable means to protect your data, no method is 100% secure. We encourage users to ensure device-level security and use the app responsibly.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "Changes to This Policy",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "This Privacy Policy may be updated occasionally to reflect improvements or changes in the app. We recommend checking this page regularly to stay informed.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0068CB),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "If you have any questions or concerns about our Privacy Policy or your data, please contact us at support@vocaleye.app.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
