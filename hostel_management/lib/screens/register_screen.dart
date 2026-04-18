import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController(), _id = TextEditingController(), _email = TextEditingController();
  final _phone = TextEditingController(), _dept = TextEditingController(), _room = TextEditingController(), _sem = TextEditingController();
  final _key = TextEditingController();
  
  final _password = TextEditingController(); 
  bool _isPasswordVisible = false;

  bool _isAdmin = false;
  final String secretKey = "HOSTEL_ADMIN_2026";

  void _submit() async {
    // ১. সাধারণ ভ্যালিডেশন
    if (_name.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields!"), backgroundColor: Colors.orange)
      );
      return;
    }

    if (_password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters!"), backgroundColor: Colors.orange)
      );
      return;
    }

    if (_isAdmin && _key.text != secretKey) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong Admin Key!"), backgroundColor: Colors.red));
      return;
    }

    // ২. SharedPreferences-এ ডাটা সেভ করা
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('name', _name.text.trim());
    await prefs.setString('id', _id.text.trim());
    await prefs.setString('email', _email.text.trim());
    await prefs.setString('phone', _phone.text.trim());
    await prefs.setString('password', _password.text.trim()); // পাসওয়ার্ড সেভ
    await prefs.setBool('isAdmin', _isAdmin);

    // স্টুডেন্ট ডাটা (dept, room, sem) সেভ করা হচ্ছে যা আগে মিসিং ছিল
    if (!_isAdmin) {
      await prefs.setString('dept', _dept.text.trim());
      await prefs.setString('room', _room.text.trim());
      await prefs.setString('sem', _sem.text.trim());
    } else {
      await prefs.setString('dept', "Admin Office");
      await prefs.setString('room', "Authority");
      await prefs.setString('sem', "Staff");
    }

    // ৩. ইউজার মডেল তৈরি
    UserModel user = UserModel(
      name: _name.text.trim(), 
      id: _id.text.trim(), 
      email: _email.text.trim(), 
      phone: _phone.text.trim(),
      department: _isAdmin ? "Admin Office" : _dept.text.trim(),
      room: _isAdmin ? "Authority" : _room.text.trim(),
      semester: _isAdmin ? "Staff" : _sem.text.trim(),
      isAdmin: _isAdmin,
    );

    // ৪. ড্যাশবোর্ডে নেভিগেট করা
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => DashboardScreen(user: user)), 
        (r) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdmin ? "Admin Register" : "Student Register"), 
        backgroundColor: _isAdmin ? Colors.red[900] : const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, 
            colors: _isAdmin ? [Colors.red[900]!, Colors.red[400]!] : [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
          )
        ),
        child: Column(children: [
          Expanded(child: Container(
            margin: const EdgeInsets.only(top: 20), 
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
            ),
            child: SingleChildScrollView(child: Column(children: [
              SwitchListTile(
                title: const Text("Are you an Admin?"), 
                value: _isAdmin, 
                onChanged: (v) => setState(() => _isAdmin = v)
              ),
              if (_isAdmin) _box(_key, "Secret Key", Icons.vpn_key, obscure: true),
              
              _box(_name, "Full Name", Icons.person),
              _box(_id, _isAdmin ? "Employee ID" : "Student ID", Icons.badge),
              _box(_email, "Email", Icons.email),
              _box(_phone, "Phone", Icons.phone),
              
              _box(
                _password, 
                "Create Password", 
                Icons.lock, 
                obscure: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                )
              ),

              if (!_isAdmin) ...[
                _box(_dept, "Department", Icons.school), 
                _box(_room, "Room No", Icons.room), 
                _box(_sem, "Semester", Icons.layers)
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAdmin ? Colors.red : const Color(0xFF1E3A8A), 
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ), 
                child: const Text("REGISTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
              ),
            ])),
          ))
        ]),
      ),
    );
  }

  Widget _box(TextEditingController c, String l, IconData i, {bool obscure = false, Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), 
      child: TextField(
        controller: c, 
        obscureText: obscure, 
        decoration: InputDecoration(
          labelText: l, 
          prefixIcon: Icon(i), 
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
        )
      )
    );
  }
}