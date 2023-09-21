import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:client/services/api_service.dart';
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
  String firstNameInputValue = '';
  String lastNameInputValue = '';
  String emailInputValue = '';
  String passwordInputValue = '';
  String confirmPasswordInputValue = '';

  Future signupUser (String firstName, String lastName, String email, String password, String confirmPassword) async {
    setState(() {
      buttonText = 'Loading...';
    });

    // Validate credentials
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

      // Call API
      final data = await ApiService.signup(firstName, lastName, email, password);

      if (data['status'] == 'success') {
        setState(() {
          buttonText = 'Success!';
        });
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pushNamed('/login');
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
          backgroundColor: Colors.transparent,
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
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InputField(
                                label: 'First Name',
                                icon: Icons.person_outline,
                                hint: 'John',
                                onInputChanged: (value) {
                                  firstNameInputValue = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InputField(
                                label: 'Last Name',
                                icon: Icons.person_outline,
                                hint: 'Doe',
                                onInputChanged: (value) {
                                  lastNameInputValue = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        InputField(
                          label: 'Confirm Password',
                          icon: Icons.lock_outline,
                          hint: '********',
                          isPassword: true,
                          onInputChanged: (value) {
                            confirmPasswordInputValue = value;
                          },
                        ),                        
                        const SizedBox(height: 25),
                        CustomButton(
                          text: buttonText, 
                          onPressed: () {
                            signupUser(
                              firstNameInputValue,
                              lastNameInputValue,
                              emailInputValue,
                              passwordInputValue,
                              confirmPasswordInputValue,
                            );
                          }
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
