class UserModel {
  String name;
  String id;
  String phone;
  String email;
  String department;
  String semester;
  bool isAdmin;
  String room;
  double balance;
  int totalMeals;
  String? pendingRoomRequest;
  // প্রোফাইল ছবির পাথ সেভ করার জন্য নতুন ফিল্ড
  String? profileImage; 

  UserModel({
    required this.name,
    required this.id,
    required this.phone,
    required this.email,
    required this.department,
    required this.room,
    required this.semester,
    this.isAdmin = false,
    this.balance = 0.0,
    this.totalMeals = 0,
    this.pendingRoomRequest,
    this.profileImage, // কনস্ট্রাক্টরে যোগ করা হলো
  });

  // ডাটাবেস বা Shared Preferences-এ সেভ করার জন্য
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'phone': phone,
      'email': email,
      'department': department,
      'room': room,
      'semester': semester,
      'isAdmin': isAdmin ? 1 : 0,
      'balance': balance,
      'totalMeals': totalMeals,
      'pendingRoomRequest': pendingRoomRequest,
      'profileImage': profileImage, // ম্যাপে যোগ করা হলো
    };
  }

  // ম্যাপ থেকে অবজেক্ট তৈরি করার জন্য
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name']?.toString() ?? '',
      id: map['id']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      department: map['department']?.toString() ?? '',
      room: map['room']?.toString() ?? 'Not Assigned',
      semester: map['semester']?.toString() ?? '',
      isAdmin: map['isAdmin'] == true || map['isAdmin'] == 1, 
      balance: (map['balance'] ?? 0.0).toDouble(),
      totalMeals: map['totalMeals'] ?? 0,
      pendingRoomRequest: map['pendingRoomRequest']?.toString(),
      profileImage: map['profileImage']?.toString(), // ম্যাপ থেকে ডাটা নেওয়া
    );
  }
}