import 'package:flutter/material.dart';

class AdminRoomPanel extends StatelessWidget {
  // ১. এরর ফিক্স: কনস্ট্যান্ট কনস্ট্রাক্টর থাকলে ভেরিয়েবলকে static const হতে হয়
  static const List<Map<String, String>> requests = [
    {'name': 'Siam Ahmed', 'id': '201', 'reqRoom': '101', 'dept': 'CSE'},
    {'name': 'Tanvir Raihan', 'id': '305', 'reqRoom': '102', 'dept': 'EEE'},
  ];

  const AdminRoomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Requests"), 
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white, // টেক্সট সাদা রাখার জন্য
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: CircleAvatar(
                backgroundColor: Colors.red[100],
                child: const Icon(Icons.person, color: Colors.red),
              ),
              title: Text(
                req['name']!, 
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              subtitle: Text(
                "ID: ${req['id']} | Dept: ${req['dept']}\nRequested Room: ${req['reqRoom']}",
                style: const TextStyle(height: 1.5),
              ),
              isThreeLine: true, // মাল্টি-লাইন টেক্সটের জন্য এটি জরুরি
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green), 
                    onPressed: () {
                      // Approve logic
                    }
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red), 
                    onPressed: () {
                      // Reject logic
                    }
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}