import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'All',
              style: TextStyle(
                color: Color.fromARGB(255, 61, 78, 129),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Matched',
              style: TextStyle(
                color: Color.fromARGB(255, 61, 78, 129),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
