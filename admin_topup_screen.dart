import 'package:flutter/material.dart';

class AdminTopupScreen extends StatefulWidget {
  const AdminTopupScreen({super.key});

  @override
  _AdminTopupScreenState createState() => _AdminTopupScreenState();
}

class _AdminTopupScreenState extends State<AdminTopupScreen> {
  final _studentIdController = TextEditingController();
  final _amountController = TextEditingController();

  void _processOfflineRecharge() {
    String id = _studentIdController.text;
    String amount = _amountController.text;

    if (id.isNotEmpty && amount.isNotEmpty) {
      // এখানে ভবিষ্যতে ডাটাবেস আপডেট হবে
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
          content: Text("Successfully added ৳$amount to Student ID: $id"),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offline Recharge (Admin)"), backgroundColor: Colors.red[900]),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(controller: _studentIdController, decoration: const InputDecoration(labelText: "Student ID", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            TextField(controller: _amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Amount to Add", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _processOfflineRecharge,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[900], minimumSize: const Size(double.infinity, 55)),
              child: const Text("RECHARGE NOW", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}