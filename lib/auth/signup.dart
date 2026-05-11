import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import './signverify.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _termsAccepted = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();

  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  Future<void> _registerUser() async {
    final String name = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String ageText = _dobController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || _selectedDate == null) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    int age = DateTime.now().year - _selectedDate!.year;
    DateTime birthdayThisYear = DateTime(DateTime.now().year, _selectedDate!.month, _selectedDate!.day);
    if (DateTime.now().isBefore(birthdayThisYear)) {
      age--; // Adjust if birthday hasn't occurred yet this year
    }

    if (age < 15 || age > 60) {
      Fluttertoast.showToast(msg: "Age must be between 15 and 60");
      return;
    }


    final url = Uri.parse("https://heapware.onrender.com/api/auth/register");

    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "password": password,
      "age": age,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Signup successful!");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerificationPage1(email: email))
        );
      } else {
        final responseBody = json.decode(response.body);
        Fluttertoast.showToast(
            msg: "Signup failed: ${responseBody['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = _selectedDate ?? DateTime(2000);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Image.asset('assets/images/logo1.jpg', height: 120),
                  const SizedBox(height: 50),

                  _buildTextField(_usernameController, Icons.person, "Username"),
                  _buildTextField(_emailController, Icons.email, "Email"),

                  // Date of Birth Picker Field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: "Date of Birth",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),

                  _buildPasswordField(_passwordController, "Password", true),
                  // _buildPasswordField(_confirmPasswordController, "Confirm Password", false),

                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) => setState(() => _termsAccepted = value ?? false),
                      ),
                      const Text("I accept the Terms and Conditions"),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _registerUser,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF0068CB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Login here", style: TextStyle(color: Color(0xFF0068CB), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Color(0xFF0068CB), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_showPassword : !_showConfirmPassword,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(
              isPassword ? (_showPassword ? Icons.visibility : Icons.visibility_off)
                  : (_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
            ),
            onPressed: () {
              setState(() {
                if (isPassword) {
                  _showPassword = !_showPassword;
                } else {
                  _showConfirmPassword = !_showConfirmPassword;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
