import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionHelper {
  // নতুন লেনদেন সেভ করার ফাংশন
  static Future<void> addTransaction({
    required String title,
    required double amount,
    required String type, // 'credit' বা 'debit'
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // ১. আগের জমানো সব ট্রানজ্যাকশন রিড করা
      final String? existingData = prefs.getString('transaction_list');
      List<dynamic> jsonList = existingData != null ? jsonDecode(existingData) : [];

      // ২. নতুন ডাটা তৈরি করা
      TransactionModel newTx = TransactionModel(
        title: title,
        amount: amount,
        date: DateTime.now(),
        type: type,
      );
      
      // ৩. লিস্টে যোগ করা
      jsonList.add(newTx.toMap());
      
      // ৪. লিস্টটি পুনরায় স্ট্রিং বানিয়ে সেভ করা
      await prefs.setString('transaction_list', jsonEncode(jsonList));
      
      print("Transaction Saved: $title - $amount"); // ডিবাগিং এর জন্য
    } catch (e) {
      print("Error saving transaction: $e");
    }
  }

  // সব ট্রানজ্যাকশন একসাথে ডিলিট করার ফাংশন (দরকার হলে)
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('transaction_list');
  }
}