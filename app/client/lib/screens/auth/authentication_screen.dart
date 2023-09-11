import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:client/widgets/or_divider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text(
                      'Investor',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Connect',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(right: 34),
                  child: Text(
                    'Unlocking Opportunities, One Connection at a Time.',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 96, 96, 96),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Image.asset(
                  'assets/images/auth.jpg',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 25),
                GoogleButton(onPressed: () {}),
                const SizedBox(height: 20),
                const OrDivider(),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    timeDilation = 3;
                    Navigator.of(context).pushNamed('/login');
                  },
                  text: 'Log In',
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    timeDilation = 3;
                    Navigator.of(context).pushNamed('/signup');
                  },
                  text: 'Sign Up',
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}