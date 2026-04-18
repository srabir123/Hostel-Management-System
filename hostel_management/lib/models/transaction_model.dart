// এখানে dart:convert দরকার নেই, তাই সরিয়ে ফেললাম
class TransactionModel {
  final String title;
  final double amount;
  final DateTime date;
  final String type; 

  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}