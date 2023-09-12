import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:client/services/auth_validation.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:client/widgets/input_fields.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String buttonText = 'Sign Up';

  final InputField firstNameInput = InputField(
    label: 'First Name',
    icon: Icons.person_outline,
    hint: 'John',
  );

  final InputField lastNameInput = InputField(
    label: 'Last Name',
    icon: Icons.person_outline,
    hint: 'Doe',
  );

  final InputField emailInput = InputField(
    label: 'Email',
    icon: Icons.email_outlined,
    hint: 'you@site.com',
  );

  final InputField passwordInput = InputField(
    label: 'Password',
    icon: Icons.lock_outline,
    hint: '********',
    isPassword: true,
  );

  final InputField confirmPasswordInput = InputField(
    label: 'Confirm Password',
    icon: Icons.lock_outline,
    hint: '********',
    isPassword: true,
  );

  Future signupUser (String firstName, String lastName, String email, String password, String confirmPassword) async {
    setState(() {
      buttonText = 'Loading...';
    });
    final url = Uri.parse('http://10.0.2.2:8000/api/auth/register');
    String name = '$firstName $lastName';
    
    final validationError = AuthValidation.validateSignup(firstName, lastName, email, password, confirmPassword);

    if (validationError != null) {
      setState(() {
        buttonText = validationError;
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          buttonText = 'Sign Up';
        });
      });
      return;
    }

    try {
      setState(() {
        buttonText = 'Signing Up...';
      });
      final response = await http.post(url, body: {
        'name': name,
        'email': email,
        'password': password,
      });
      Map data = json.decode(response.body);
      print('response: $data');
      if (data['status'] == 'success') {
        setState(() {
          buttonText = 'Success!';
        });
        Timer(const Duration(seconds: 3), () {
          // TODO: Navigate to home screen
        });
      } else {
        setState(() {
          buttonText = 'Invalid Credentials';
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            buttonText = 'Sign Up';
          });
        });
      }
    }  catch (e) {
      setState(() {
        buttonText = 'Email already exists';
      });
      Timer(const Duration(seconds: 3), () {
          setState(() {
            buttonText = 'Sign Up';
          });
        });
      print('error: $e');
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create your account, it’s free!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 96, 96, 96),
                    ),
                  ),
                  Container(
                    width: 334,
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(child: firstNameInput),
                            const SizedBox(width: 10),
                            Expanded(child: lastNameInput),
                          ],
                        ),
                        const SizedBox(height: 20),
                        emailInput,
                        const SizedBox(height: 20),
                        passwordInput,
                        const SizedBox(height: 20),
                        confirmPasswordInput,                        
                      ],
                    )
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: buttonText, 
                    onPressed: () {
                      String firstName = firstNameInput.inputValue;
                      String lastName = lastNameInput.inputValue;
                      String email = emailInput.inputValue;
                      String password = passwordInput.inputValue;
                      String confirmPassword = confirmPasswordInput.inputValue;
                      signupUser(firstName, lastName, email, password, confirmPassword);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
