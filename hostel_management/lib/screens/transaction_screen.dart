import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Shared Preferences থেকে ট্রানজ্যাকশন লোড করা
  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('transaction_list');
    
    if (data != null) {
      List<dynamic> jsonList = jsonDecode(data);
      setState(() {
        transactions = jsonList.map((m) => TransactionModel.fromMap(m)).toList();
        // নতুন ট্রানজ্যাকশন সবার উপরে দেখানোর জন্য রিভার্স করা
        transactions = transactions.reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: transactions.isEmpty
          ? const Center(child: Text("No transactions yet!"))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final item = transactions[index];
                bool isCredit = item.type == 'credit';

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCredit ? Colors.green[50] : Colors.red[50],
                      child: Icon(
                        isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isCredit ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${item.date.day}/${item.date.month}/${item.date.year}"),
                    trailing: Text(
                      "${isCredit ? '+' : '-'} ৳${item.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isCredit ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}