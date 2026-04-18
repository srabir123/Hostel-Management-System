import 'package:flutter/material.dart';
import '../models/user_model.dart';

class WalletScreen extends StatefulWidget {
  final UserModel user;
  const WalletScreen({super.key, required this.user});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _amountController = TextEditingController();
  String? _selectedMethod;

  // ট্রানজেকশন হিস্টোরি ট্র্যাক করার জন্য একটি লিস্ট (আপাতত লোকাল)
  final List<Map<String, dynamic>> _history = [
    {"title": "Welcome Bonus", "amount": "+৳500.00", "color": Colors.green},
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'bKash', 'icon': Icons.account_balance_wallet, 'color': Colors.pink},
    {'name': 'Nagad', 'icon': Icons.account_balance_wallet, 'color': Colors.orange},
    {'name': 'Rocket', 'icon': Icons.account_balance_wallet, 'color': Colors.purple},
    {'name': 'Bank Transfer', 'icon': Icons.account_balance, 'color': Colors.teal},
  ];

  void _showPaymentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20, left: 20, right: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Online Recharge", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Amount (৳)",
                  hintText: "e.g. 500",
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Select Payment Method:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedMethod == _paymentMethods[index]['name'];
                    return GestureDetector(
                      onTap: () => setModalState(() => _selectedMethod = _paymentMethods[index]['name']),
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? _paymentMethods[index]['color'].withOpacity(0.1) : Colors.white,
                          border: Border.all(color: isSelected ? _paymentMethods[index]['color'] : Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_paymentMethods[index]['icon'], color: _paymentMethods[index]['color']),
                            const SizedBox(height: 5),
                            Text(_paymentMethods[index]['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // ১. ইনপুট চেক (Validation)
                  String input = _amountController.text.trim();
                  double? amount = double.tryParse(input);

                  if (input.isEmpty || amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid amount!"), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  if (_selectedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a payment method!"), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  // ২. ব্যালেন্স আপডেট এবং হিস্টোরি অ্যাড
                  setState(() {
                    widget.user.balance += amount;
                    _history.insert(0, {
                      "title": "Recharged via $_selectedMethod",
                      "amount": "+৳${amount.toStringAsFixed(2)}",
                      "color": Colors.green
                    });
                    _selectedMethod = null; // মেথড রিসেট
                  });

                  _amountController.clear();
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("৳$amount Recharge Successful!"), 
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("CONFIRM RECHARGE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ব্যালেন্স সেকশন
          Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text("Total Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 10),
                Text(
                  "৳${widget.user.balance.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // হোস্টেল ফি কার্ড
                  Card(
                    elevation: 0,
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Icon(Icons.info_outline, color: Colors.blue[700]),
                      title: const Text("Current Hostel Fee", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Due: 5th of this month"),
                      trailing: Text("৳2500", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  // ডাইনামিক হিস্টোরি লিস্ট
                  Expanded(
                    child: _history.isEmpty 
                      ? const Center(child: Text("No transactions yet"))
                      : ListView.builder(
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final item = _history[index];
                            return _transactionItem(item['title'], item['amount'], item['color']);
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
          
          // বটম বাটন
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: _showPaymentModal,
              icon: const Icon(Icons.add_to_photos, color: Colors.white),
              label: const Text("RECHARGE NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionItem(String title, String amount, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1), 
          child: Icon(amount.contains('+') ? Icons.south_west : Icons.north_east, color: color, size: 18)
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}