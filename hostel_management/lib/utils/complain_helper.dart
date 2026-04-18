import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/complain_model.dart'; // মডেলটি অবশ্যই ইমপোর্ট করতে হবে

class ComplainHelper {
  static const String _key = 'complain_list';

  // নতুন অভিযোগ সেভ করা
  static Future<void> addComplain(ComplainModel complain) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    List<dynamic> jsonList = data != null ? jsonDecode(data) : [];
    
    jsonList.add(complain.toMap());
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  // সব অভিযোগ লোড করা
  static Future<List<ComplainModel>> getAllComplains() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];
    
    List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((m) => ComplainModel.fromMap(m)).toList().reversed.toList();
  }

  // আপনার দেওয়া কোডটি এখানে থাকবে:
  static Future<void> resolveComplain(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return;

    List<dynamic> jsonList = jsonDecode(data);
    // টাইপ সেফটি নিশ্চিত করা হচ্ছে
    List<ComplainModel> complains = jsonList.map((m) => ComplainModel.fromMap(m)).toList();

    for (var c in complains) {
      if (c.id == id) {
        c.isResolved = true;
        break;
      }
    }

    // লিস্ট আপডেট করে আবার সেভ করা হচ্ছে
    List<Map<String, dynamic>> updatedList = complains.map((c) => c.toMap()).toList();
    await prefs.setString(_key, jsonEncode(updatedList));
  }
}