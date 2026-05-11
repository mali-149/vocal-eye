import 'dart:convert';
import 'dart:io';
// import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, dynamic>? _user;
  String? _error;
  String? _userId;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _role = 'machanic';

  File? _imageFile;

  final List<String> _roles = ['machanic', 'fuelpump', 'user'];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      setState(() {
        _error = "User ID not found.";
        _isLoading = false;
      });
      return;
    }

    _userId = userId;

    final url = Uri.parse('https://skyride.onrender.com/api/getaccount/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _user = data['data'];
          _usernameController.text = _user!['username'] ?? '';
          _emailController.text = _user!['email'] ?? '';
          _phoneController.text = _user!['phone'].toString();
          _role = _user!['role'] ?? 'machanic';
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }


  Future<void> getLiveLocation() async {
    // Location location = Location();
    //
    // bool serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled) {
    //   serviceEnabled = await location.requestService();
    // }
    //
    // PermissionStatus permissionGranted = await location.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    // }
    //
    // if (permissionGranted == PermissionStatus.granted ||
    //     permissionGranted == PermissionStatus.grantedLimited) {
    //   final locData = await location.getLocation();
    //
    //   if (locData.latitude != null && locData.longitude != null) {
    //     double lon = locData.latitude!;
    //     double lat = locData.longitude!;
    //     print("Live Location -> Latitude: $lat, Longitude: $lon");
    //     // Pass the coordinates to the update method
    //     _updateAccount(lat, lon);
    //   } else {
    //     print("Location data is null.");
    //   }
    // } else {
    //   print("Location permission not granted.");
    // }
  }




  @override
  Widget build(BuildContext context) {
    final imageUrl = _user?['image'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Account",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF0068CB),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (imageUrl != null && imageUrl.isNotEmpty)
                          ? NetworkImage(imageUrl)
                          : AssetImage('assets/images/user1.jpg') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: SvgPicture.string(cameraIcon),
                        onPressed: _pickImage,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField("Username", _usernameController),
                _buildTextField("Email", _emailController, keyboard: TextInputType.emailAddress),
                _buildTextField("Phone", _phoneController, keyboard: TextInputType.phone),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _role,
                  items: _roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // First fetch the live location
                    await getLiveLocation();

                    // The account will be updated once the location is fetched
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0068CB),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Update Account",style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, bool obscure = false, String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}

const String cameraIcon = '''
<svg viewBox="0 0 24 24">
  <path fill="black" d="M12 5c-3.86 0-7 3.14-7 7s3.14 7 7 7
  7-3.14 7-7-3.14-7-7-7zm0 12c-2.76 0-5-2.24-5-5s2.24-5
  5-5 5 2.24 5 5-2.24 5-5 5zm8-14h-3.17l-1.84-2H8.01L6.17
  3H3c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h18c1.1 0 2-.9
  2-2V5c0-1.1-.9-2-2-2z"/>
</svg>
''';
