import 'package:expense_tracker_app_2/widget/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  _PinLoginScreenState createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final TextEditingController _pinController = TextEditingController();

  Future<bool> _validatePin(String enteredPin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString("pin");
    return enteredPin == savedPin;
  }

  void _onSubmit() async {
    final isValid = await _validatePin(_pinController.text);
    if (isValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigationBarPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid PIN. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: "PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text("Unlock"),
            ),
          ],
        ),
      ),
    );
  }
}
