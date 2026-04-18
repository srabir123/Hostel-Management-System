import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/complain_model.dart';
import '../utils/complain_helper.dart';

class ComplainScreen extends StatefulWidget {
  final UserModel user;
  const ComplainScreen({super.key, required this.user});

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final _descController = TextEditingController();
  String selectedCategory = 'Electricity';
  List<ComplainModel> complains = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final data = await ComplainHelper.getAllComplains();
    setState(() { complains = data; });
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Submit a New Complaint", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Category"),
              items: ['Electricity', 'Plumbing', 'Food', 'WiFi', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() { selectedCategory = val!; }),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descController, 
              maxLines: 3,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if(_descController.text.isEmpty) return;
                final newComplain = ComplainModel(
                  id: DateTime.now().toString(),
                  studentName: widget.user.name,
                  studentRoom: widget.user.room,
                  category: selectedCategory,
                  description: _descController.text,
                  date: DateTime.now(),
                );
                await ComplainHelper.addComplain(newComplain);
                _descController.clear();
                Navigator.pop(context);
                _loadData();
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.deepOrange),
              child: const Text("SUBMIT COMPLAINT", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"), 
        backgroundColor: widget.user.isAdmin ? Colors.red[900] : const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: complains.isEmpty 
          ? const Center(child: Text("No complaints found."))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: complains.length,
              itemBuilder: (context, index) {
                final c = complains[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: c.isResolved ? Colors.green[100] : Colors.red[100],
                      child: Icon(c.isResolved ? Icons.check : Icons.warning, color: c.isResolved ? Colors.green : Colors.red),
                    ),
                    title: Text("${c.category} - Room ${c.studentRoom}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.description),
                        Text("By: ${c.studentName}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: widget.user.isAdmin && !c.isResolved
                      ? TextButton(
                          onPressed: () async {
                            await ComplainHelper.resolveComplain(c.id);
                            _loadData();
                          },
                          child: const Text("SOLVE", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        )
                      : Text(c.isResolved ? "Solved" : "Pending", 
                          style: TextStyle(color: c.isResolved ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
      floatingActionButton: !widget.user.isAdmin 
        ? FloatingActionButton(
            onPressed: _showAddDialog, 
            backgroundColor: const Color(0xFF1E3A8A), 
            child: const Icon(Icons.add, color: Colors.white)) 
        : null,
    );
  }
}