import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // নতুন যোগ করা হয়েছে
import 'package:path/path.dart' as path; // নতুন যোগ করা হয়েছে
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // গ্যালারি থেকে ছবি সিলেক্ট এবং স্থায়ীভাবে সেভ করার ফাংশন
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      try {
        // ১. অ্যাপের স্থায়ী ডিরেক্টরি খুঁজে বের করা
        final directory = await getApplicationDocumentsDirectory();
        
        // ২. ছবির জন্য একটি নাম তৈরি করা (যেমন: profile_timestamp.jpg)
        final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        final String permanentPath = '${directory.path}/$fileName';

        // ৩. ছবিটি স্থায়ী ফোল্ডারে কপি করা
        final File savedImage = await File(pickedFile.path).copy(permanentPath);

        setState(() {
          widget.user.profileImage = savedImage.path; // স্থায়ী পাথ সেট করা
        });

        // ৪. SharedPreferences-এ স্থায়ী পাথটি সেভ করা
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImage', savedImage.path);
        
      } catch (e) {
        debugPrint("Error saving image: $e");
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      widget.user.name = _nameController.text;
      widget.user.phone = _phoneController.text;
      widget.user.email = _emailController.text;
      _isEditing = false;
    });
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('email', _emailController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully!"), 
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check_circle : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: (widget.user.profileImage != null && widget.user.profileImage!.isNotEmpty)
                          ? FileImage(File(widget.user.profileImage!))
                          : null,
                      child: (widget.user.profileImage == null || widget.user.profileImage!.isEmpty)
                          ? Icon(Icons.person, size: 65, color: Colors.blue[900])
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
                            ),
                            child: const Icon(Icons.camera_alt, color: Color(0xFF1E3A8A), size: 20),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _buildInfoField("Full Name", _nameController, Icons.person, _isEditing),
                          const Divider(),
                          _buildInfoField("Phone Number", _phoneController, Icons.phone, _isEditing),
                          const Divider(),
                          _buildInfoField("Email Address", _emailController, Icons.email, _isEditing),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _buildReadOnlyField("Student ID", widget.user.id, Icons.badge),
                          const Divider(),
                          _buildReadOnlyField("Department", widget.user.department, Icons.school),
                          const Divider(),
                          _buildReadOnlyField("Semester", widget.user.semester, Icons.calendar_month),
                          const Divider(),
                          _buildReadOnlyField("Room No", widget.user.room, Icons.meeting_room),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showLogoutDialog,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text("LOGOUT ACCOUNT", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, IconData icon, bool isEditable) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E3A8A)),
      title: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      subtitle: isEditable
          ? TextField(
              controller: controller,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
              ),
            )
          : Text(
              controller.text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
            ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}