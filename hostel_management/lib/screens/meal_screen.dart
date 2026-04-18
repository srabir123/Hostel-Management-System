import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ডাটা সেভ করার জন্য
import '../models/user_model.dart';
import '../utils/transaction_helper.dart'; // ট্রানজ্যাকশন হেল্পার ইমপোর্ট করা হলো

class MealScreen extends StatefulWidget {
  final UserModel user;
  const MealScreen({super.key, required this.user});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final double breakfastCost = 25.0;
  final double lunchCost = 50.0;
  final double dinnerCost = 50.0;

  final Map<String, String> todayMenu = {
    "Breakfast": "খিচুড়ি, ডিম ভুনা ও আচার",
    "Lunch": "সাদা ভাত, মুরগির মাংস, ডাল ও সবজি",
    "Dinner": "চিকেন বিরিয়ানি ও সালাদ",
  };

  bool _isBookingOpen(String mealType) {
    int hour = DateTime.now().hour;
    if (mealType == "Breakfast") {
      return hour >= 20 || hour < 4;
    } else if (mealType == "Lunch") {
      return hour >= 20 || hour < 10;
    } else if (mealType == "Dinner") {
      return hour >= 22 || hour < 16;
    }
    return false;
  }

  // মিল বুকিং ফাংশন (আপডেটেড)
  void _bookMeal(String mealType, double cost) async {
    if (!_isBookingOpen(mealType)) {
      _showMessage("বুকিংয়ের সময় শেষ হয়ে গেছে!", Colors.red);
      return;
    }

    if (widget.user.balance < cost) {
      _showMessage("পর্যাপ্ত ব্যালেন্স নেই!", Colors.orange);
      return;
    }

    setState(() {
      widget.user.balance -= cost;
    });

    // ১. ব্যালেন্স স্থায়ীভাবে সেভ করা (Shared Preferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', widget.user.balance);

    // ২. ট্রানজ্যাকশন হিস্ট্রিতে রেকর্ড যোগ করা
    await TransactionHelper.addTransaction(
      title: "Meal Booked ($mealType)",
      amount: cost,
      type: "debit", // যেহেতু টাকা খরচ হচ্ছে
    );
    
    _showMessage("$mealType সফলভাবে বুক করা হয়েছে!", Colors.green);
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Meal Management"),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildBalanceCard(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Today's Menu & Booking", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _mealCard("Breakfast", "8 PM - 4 AM", breakfastCost, Icons.wb_twilight),
                _mealCard("Lunch", "8 PM - 10 AM", lunchCost, Icons.wb_sunny),
                _mealCard("Dinner", "10 PM - 4 PM", dinnerCost, Icons.nightlight_round),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
              Text("৳${widget.user.balance.toStringAsFixed(2)}", 
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
          const Icon(Icons.account_balance_wallet, color: Colors.white54, size: 40),
        ],
      ),
    );
  }

  Widget _mealCard(String title, String deadline, double cost, IconData icon) {
    bool isAvailable = _isBookingOpen(title);
    String menu = todayMenu[title] ?? "Menu not updated";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isAvailable ? Colors.blue[50] : Colors.grey[200],
          child: Icon(icon, color: isAvailable ? Colors.blue : Colors.grey),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("৳$cost | Deadline: $deadline"),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🍽️ আজ যা থাকছে মেনুতে:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                const SizedBox(height: 8),
                Text(menu, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isAvailable ? () => _bookMeal(title, cost) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAvailable ? Colors.green : Colors.grey[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isAvailable ? "Book Now" : "Time Over",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}