import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation with reverse

    // Define the animation tween
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
  CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
);


    // Navigate to the home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: child,
            );
          },
          child: Image.asset(
            'asset/images/ic_launcher.png', // Ensure your logo is in the assets folder
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
