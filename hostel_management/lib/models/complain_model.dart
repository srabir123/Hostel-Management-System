// lib/models/complain_model.dart
class ComplainModel {
  final String id;
  final String studentName;
  final String studentRoom;
  final String category;
  final String description;
  final DateTime date;
  bool isResolved;

  ComplainModel({
    required this.id,
    required this.studentName,
    required this.studentRoom,
    required this.category,
    required this.description,
    required this.date,
    this.isResolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'studentRoom': studentRoom,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'isResolved': isResolved,
    };
  }

  factory ComplainModel.fromMap(Map<String, dynamic> map) {
    return ComplainModel(
      id: map['id'],
      studentName: map['studentName'],
      studentRoom: map['studentRoom'],
      category: map['category'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isResolved: map['isResolved'],
    );
  }
}