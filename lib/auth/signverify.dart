
import 'package:flutter/material.dart';
import 'login.dart';

class VerificationPage1 extends StatefulWidget {
  final String email;
  const VerificationPage1({Key? key, required this.email}) : super(key: key);


  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage1> {
  final TextEditingController _codeController = TextEditingController();
  String verificationCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo at the top
                    Image.asset(
                      'assets/images/logo1.jpg', // Replace with your logo's path
                      height: 120,
                    ),
                    const SizedBox(height: 2),

                    const Text(
                      "Congratulations!🎉",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        children: [
                          const TextSpan(text: "Your account has been successfully created! 🎊 A verification link has been sent to:(  "),
                          TextSpan(
                            text: widget.email,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0068CB)),
                          ),
                          const TextSpan(text: "  )Please check your inbox 📥 and click the link to activate your account ✅."),
                        ],
                      ),
                    ),


                    const SizedBox(height: 40),



                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          verificationCode = _codeController.text;
                        });
                        // Navigate to Reset Password Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Color(0xFF0068CB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Goto Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Resend code link

                    const SizedBox(height: 20),

                    // Login Now Text Link with Underline

                  ],
                ),
              ),
            ),
          ),
          // Back Arrow Positioned at the top left corner
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back to ForgotPasswordPage
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Color(0xFF0068CB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}