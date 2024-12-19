import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "About Dev",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80, // Adjust the size as needed
              backgroundImage: AssetImage('asset/images/profile.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              "Afia Tabassum",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "ID: C201245",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Email: afia.tabassum45@gmail.com",
              style: TextStyle(fontSize: 18, color: Color.fromRGBO(117, 117, 117, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
