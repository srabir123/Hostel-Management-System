import 'dart:io'; 
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';
import 'meal_screen.dart';
import 'wallet_screen.dart';
import 'admin_topup_screen.dart';
import 'room_selection_screen.dart';
import 'admin_room_panel.dart';
import 'admin_menu_screen.dart';
import 'transaction_screen.dart';
import 'complain_screen.dart'; // নতুন ইমপোর্ট যোগ করা হয়েছে

class DashboardScreen extends StatefulWidget {
  final UserModel user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.user.isAdmin ? "Admin Panel" : "HostelEase Dashboard"),
        backgroundColor: widget.user.isAdmin ? Colors.red[900] : const Color(0xFF1E3A8A),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(25),
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.user.isAdmin ? Colors.red[900] : const Color(0xFF1E3A8A),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Welcome,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                        Text(
                          widget.user.name,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Room: ${widget.user.room}",
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user))
                      ).then((_) => _refresh()),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage: widget.user.profileImage != null
                            ? FileImage(File(widget.user.profileImage!))
                            : null,
                        child: widget.user.profileImage == null
                            ? const Icon(Icons.person, color: Colors.white, size: 30)
                            : null,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.user.isAdmin ? Icons.admin_panel_settings : Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.user.isAdmin 
                          ? "Role: System Administrator" 
                          : "Balance: ৳${widget.user.balance.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Grid Menu Section
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: widget.user.isAdmin ? _adminCards(context) : _studentCards(context),
            ),
          )
        ],
      ),
    );
  }

  // Admin Cards
  List<Widget> _adminCards(BuildContext context) => [
        _card(context, Icons.add_moderator, "Offline Top-up", Colors.red, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminTopupScreen())).then((_) => _refresh());
        }),
        _card(context, Icons.restaurant_menu, "Set Today's Menu", Colors.orange, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminMenuScreen()));
        }),
        _card(context, Icons.room_preferences, "Room Requests", Colors.blue, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRoomPanel())).then((_) => _refresh());
        }),
        // Admin-এর জন্য অভিযোগ দেখার বাটন
        _card(context, Icons.report_problem, "Complaints", Colors.deepOrange, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ComplainScreen(user: widget.user))).then((_) => _refresh());
        }),
      ];

  // Student Cards
  List<Widget> _studentCards(BuildContext context) => [
        _card(context, Icons.fastfood, "Meal Management", Colors.orange, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MealScreen(user: widget.user))).then((_) => _refresh());
        }),
        _card(context, Icons.account_balance_wallet, "Wallet & Fees", Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(user: widget.user))).then((_) => _refresh());
        }),
        _card(context, Icons.meeting_room, "Room Selection", Colors.blue, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RoomSelectionScreen(user: widget.user))).then((_) => _refresh());
        }),
        _card(context, Icons.history, "Transactions", Colors.purple, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionScreen()));
        }),
        // Student-এর জন্য অভিযোগ দেওয়ার বাটন
        _card(context, Icons.report_problem, "Complaints", Colors.deepOrange, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ComplainScreen(user: widget.user))).then((_) => _refresh());
        }),
      ];

  Widget _card(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}