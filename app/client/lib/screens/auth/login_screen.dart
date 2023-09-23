import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:client/services/api_service.dart';
import 'package:client/services/auth_validation.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:client/widgets/input_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String buttonText = 'Login';
  String emailInputValue = '';
  String passwordInputValue = '';

  Future loginUser (String email, String password) async {
    setState(() {
      buttonText = 'Loading...';
    });
    
    // Validate email and password
    final validationError = AuthValidation.validateLogin(email, password);

    if (validationError != null) {
      setState(() {
        buttonText = validationError;
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          buttonText = 'Login';
        });
      });
      return;
    }

    try {
      // Call API
      final data = await ApiService.login(email, password);

      if (data['status'] == 'success') {
        setState(() {
          buttonText = 'Success!';
        });

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['authorisation']['token']);

        Timer(const Duration(seconds: 3), () {
          if (data['user']['usertype_name'] == 'pending') {
            Navigator.pushNamed(context, '/setup_profile');
          } else {
            Navigator.pushNamed(context, '/home');
          }
        });
      } else {
        setState(() {
          buttonText = 'Email or password is incorrect';
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            buttonText = 'Login';
          });
        });
      }
    } catch (e) {
      setState(() {
        buttonText = 'Email or password is incorrect';
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          buttonText = 'Login';
        });
      });
      debugPrint('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            padding: const EdgeInsets.only(left: 25),
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login to your Account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 96, 96, 96),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        InputField(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          hint: 'you@site.com',
                          onInputChanged: (value) {
                            emailInputValue = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        InputField(
                          label: 'Password',
                          icon: Icons.lock_outline,
                          hint: '********',
                          isPassword: true,
                          onInputChanged: (value) {
                            passwordInputValue = value;
                          },
                        ),
                        const SizedBox(height: 28),
                        CustomButton(text: buttonText, onPressed: () {
                          loginUser(emailInputValue, passwordInputValue);
                        }),
                        const SizedBox(height: 30),
                        Image.asset(
                          'assets/images/data_protection.png',
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
