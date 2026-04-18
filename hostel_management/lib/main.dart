import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'models/user_model.dart';

void main() async {
  // ফ্লাটার ইঞ্জিন এবং প্লাগইন সেটআপ নিশ্চিত করা
  WidgetsFlutterBinding.ensureInitialized();
  
  // মেমোরি থেকে ডাটা রিড করা
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  // UserModel-এর কনস্ট্রাক্টর অনুযায়ী ডাটা লোড করা
  UserModel savedUser = UserModel(
    name: prefs.getString('name') ?? "",
    id: prefs.getString('id') ?? "",
    phone: prefs.getString('phone') ?? "",
    email: prefs.getString('email') ?? "",
    department: prefs.getString('dept') ?? "",
    room: prefs.getString('room') ?? "Not Assigned",
    semester: prefs.getString('sem') ?? "",
    isAdmin: prefs.getBool('isAdmin') ?? false,
    balance: prefs.getDouble('balance') ?? 0.0,
    totalMeals: prefs.getInt('totalMeals') ?? 0,
  );

  runApp(HostelEaseApp(
    isLoggedIn: isLoggedIn,
    user: savedUser,
  ));
}

class HostelEaseApp extends StatelessWidget {
  final bool isLoggedIn;
  final UserModel user;

  const HostelEaseApp({super.key, required this.isLoggedIn, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HostelEase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        primaryColor: const Color(0xFF1E3A8A),
        useMaterial3: true,
      ),
      
      // প্রাথমিক স্ক্রিন নির্ধারণ
      home: isLoggedIn ? DashboardScreen(user: user) : const LoginScreen(),
      
      // রাউট কনফিগারেশন (লগআউট বাটন যখন কাজ করবে)
      routes: {
        '/login': (context) => const LoginScreen(),
        // যদি অন্য কোনো স্ক্রিন থেকে Navigator.pushNamedAndRemoveUntil('/login', ...) দেওয়া হয়
      },
    );
  }
}