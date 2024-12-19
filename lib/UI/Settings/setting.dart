import 'package:expense_tracker_app_2/UI/Settings/Model/dev.dart';
import 'package:flutter/material.dart';
import '../../providers/provider.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<AddListProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          ListTile(
            title: Text("Dark Mode",
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Switch(
              value: homeProvider.isDarkTheme,
              onChanged: (value) {
                homeProvider.toggleTheme();
              },
            ),
          ),
          Divider(indent: 20, endIndent: 20),
          ListTile(
            title: Text("Set PIN",
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.lock),
            onTap: () {
              _showSetPinDialog(context);
            },
          ),
          Divider(indent: 20, endIndent: 20),
          ListTile(
            title: Text("About Dev",
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.info),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSetPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final _pinController = TextEditingController();
        final _confirmPinController = TextEditingController();
        return AlertDialog(
          title: Text("Set PIN"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _pinController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter PIN",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPinController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Confirm PIN",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_pinController.text == _confirmPinController.text &&
                    _pinController.text.length == 4) {
                  // Save PIN to a secure location (e.g., SharedPreferences)
                  Provider.of<AddListProvider>(context, listen: false)
                      .savePin(_pinController.text);
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("PIN set successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("PINs do not match or invalid!")),
                  );
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
