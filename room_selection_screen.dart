import 'package:flutter/material.dart';
import '../models/user_model.dart';

class RoomSelectionScreen extends StatelessWidget {
  final UserModel user;
  RoomSelectionScreen({super.key, required this.user});

  // ডামি রুম ডাটা (ভবিষ্যতে ডাটাবেস থেকে আসবে)
  final List<Map<String, dynamic>> rooms = [
    {'no': '101', 'capacity': 4, 'filled': 3, 'members': ['Siam', 'Rakib', 'Abir'], 'dept': 'CSE'},
    {'no': '102', 'capacity': 4, 'filled': 2, 'members': ['Jamil', 'Hasan'], 'dept': 'EEE'},
    {'no': '105', 'capacity': 4, 'filled': 4, 'members': [], 'dept': 'CSE'}, // Full
  ];

  @override
  Widget build(BuildContext context) {
    // ব্যাচমেট বা সেম ডিপার্টমেন্টের রুমগুলোকে আগে ফিল্টার করা (Suggestion)
    List<Map<String, dynamic>> suggestedRooms = rooms.where((r) => r['dept'] == user.department && r['filled'] < r['capacity']).toList();
    List<Map<String, dynamic>> otherRooms = rooms.where((r) => r['dept'] != user.department && r['filled'] < r['capacity']).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Apply for Room"), backgroundColor: const Color(0xFF1E3A8A)),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _sectionTitle("Suggested for You (Batchmates)"),
          ...suggestedRooms.map((r) => _roomCard(context, r, true)),
          const SizedBox(height: 20),
          _sectionTitle("Other Available Rooms"),
          ...otherRooms.map((r) => _roomCard(context, r, false)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
  );

  Widget _roomCard(BuildContext context, Map<String, dynamic> room, bool isSuggested) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: isSuggested ? Colors.green : Colors.transparent, width: 2)),
      child: ListTile(
        leading: Icon(Icons.meeting_room, color: Colors.blue[900], size: 30),
        title: Text("Room No: ${room['no']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Available Seats: ${room['capacity'] - room['filled']}\nMembers: ${room['members'].join(', ')}"),
        trailing: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Application for Room ${room['no']} sent to Admin!"), backgroundColor: Colors.green));
            Navigator.pop(context);
          },
          child: const Text("Apply"),
        ),
      ),
    );
  }
}