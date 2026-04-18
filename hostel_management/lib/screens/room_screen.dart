import 'package:flutter/material.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Room Allocation"), backgroundColor: const Color(0xFF1E3A8A)),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: 10, // ডামি ডাটা হিসেবে ১০টি রুম
        itemBuilder: (context, index) {
          bool isAvailable = index % 3 != 0; // ডামি লজিক
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Icon(Icons.meeting_room, color: isAvailable ? Colors.green : Colors.red),
              title: Text("Room No: ${401 + index}"),
              subtitle: Text(isAvailable ? "Available" : "Occupied"),
              trailing: isAvailable 
                ? ElevatedButton(onPressed: () {}, child: const Text("Request"))
                : const Icon(Icons.lock_outline, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}