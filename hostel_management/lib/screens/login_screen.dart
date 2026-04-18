import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() async {
    // ১. ইনপুট ট্রিম করা (যাতে স্পেস থাকলে সমস্যা না হয়)
    String emailInput = _emailController.text.trim();
    String passwordInput = _passController.text.trim();

    if (emailInput.isEmpty || passwordInput.isEmpty) {
      _showError("Please enter both Email and Password!");
      return;
    }

    // ২. SharedPreferences লোড করা
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // ৩. সেভ করা ডাটা পড়া
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    // DEBUG: আপনি চাইলে চেক করতে পারেন আসলে কি সেভ আছে (টার্মিনালে দেখা যাবে)
    debugPrint("Saved Email: $savedEmail");
    debugPrint("Saved Pass: $savedPassword");

    // ৪. অ্যাডমিন এবং স্টুডেন্ট চেক লজিক
    bool isAdminLogin = (emailInput.toLowerCase() == "admin" && passwordInput == "123");
    
    // ইমেইল চেক করার সময় case-sensitive হতে পারে, তাই দুইটাই চেক করা ভালো
    bool isStudentLogin = (savedEmail != null && 
                           emailInput == savedEmail && 
                           passwordInput == savedPassword);

    if (isAdminLogin || isStudentLogin) {
      await prefs.setBool('isLoggedIn', true);

      UserModel user;

      if (isAdminLogin) {
        user = UserModel(
          name: "System Admin",
          id: "ADM-001",
          email: "admin@hostel.com",
          phone: "01700000000",
          department: "Administration",
          room: "Office",
          semester: "Staff",
          isAdmin: true,
        );
      } else {
        // SharedPreferences থেকে সব ডাটা নিয়ে ইউজার অবজেক্ট তৈরি
        user = UserModel(
          name: prefs.getString('name') ?? "Student",
          id: prefs.getString('id') ?? "N/A",
          email: savedEmail!,
          phone: prefs.getString('phone') ?? "N/A",
          department: prefs.getString('dept') ?? "N/A",
          room: prefs.getString('room') ?? "N/A",
          semester: prefs.getString('sem') ?? "N/A",
          isAdmin: prefs.getBool('isAdmin') ?? false,
        );
      }

      // ৫. সাকসেস মেসেজ এবং নেভিগেশন
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful!"), backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => DashboardScreen(user: user))
        );
      }
    } else {
      // যদি ডাটা না মিলে
      _showError("Invalid Email or Password! Please register properly.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UI অংশটি আপনার আগের মতোই চমৎকার আছে, তাই আমি শুধু লজিক পার্ট আপডেট করে দিলাম।
    // নিচের অংশটি আপনার কোডের সাথে মিলে যাবে।
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, 
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)]
          )
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.home_work, size: 80, color: Colors.white),
            const Text(
              "HostelEase", 
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60), 
                    topRight: Radius.circular(60)
                  )
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address", 
                          prefixIcon: const Icon(Icons.email, color: Color(0xFF1E3A8A)), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password", 
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF1E3A8A)), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A), 
                          minimumSize: const Size(double.infinity, 55), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                        ),
                        child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const RegisterScreen())
                        ),
                        child: const Text(
                          "New Student? Register here", 
                          style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}