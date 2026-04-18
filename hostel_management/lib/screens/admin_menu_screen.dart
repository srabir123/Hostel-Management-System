import 'package:flutter/material.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  _AdminMenuScreenState createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  // টেক্সট এডিট করার কন্ট্রোলার
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();

  // মেনু আপডেট করার ফাংশন
  void _updateMenu() {
    String breakfast = _breakfastController.text;
    String lunch = _lunchController.text;
    String dinner = _dinnerController.text;

    if (breakfast.isEmpty || lunch.isEmpty || dinner.isEmpty) {
      _showSnackBar("Please fill all menus!", Colors.red);
      return;
    }

    // এখানে ভবিষ্যতে ডাটাবেস (Firebase/API) কানেক্ট করবেন
    print("Updated Breakfast: $breakfast");
    print("Updated Lunch: $lunch");
    print("Updated Dinner: $dinner");

    _showSnackBar("Today's Menu Updated Successfully!", Colors.green);
    
    // আপডেট শেষে ব্যাকে চলে যাবে
    Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Set Daily Menu"),
        backgroundColor: Colors.red[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Food Items",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red[900]),
            ),
            const Text("What's cooking today?", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),

            // Breakfast Input
            _menuInputField("Breakfast", _breakfastController, Icons.wb_sunny_outlined, Colors.orange),
            const SizedBox(height: 20),

            // Lunch Input
            _menuInputField("Lunch", _lunchController, Icons.light_mode, Colors.blue),
            const SizedBox(height: 20),

            // Dinner Input
            _menuInputField("Dinner", _dinnerController, Icons.nightlight_round, Colors.indigo),
            
            const SizedBox(height: 40),

            // Update Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _updateMenu,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: const Text(
                  "UPDATE TODAY'S MENU",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // কাস্টম ইনপুট ফিল্ড ডিজাইন
  Widget _menuInputField(String label, TextEditingController controller, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
          prefixIcon: Icon(icon, color: iconColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          hintText: "Enter $label items...",
        ),
      ),
    );
  }
} 