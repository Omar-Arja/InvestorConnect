import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:client/widgets/input_fields.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

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
        body: Container(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: emailInput,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: passwordInput,
              ),
              const SizedBox(height: 30),
              CustomButton(text: 'Login', onPressed: () {
                String email = emailInput.inputValue;
                String password = passwordInput.inputValue;
                print('Email: $email, Password: $password');
              }),
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/data_protection.png',
                width: 200,
                fit: BoxFit.contain,
              )
            ],
          ),
        ),
      ),
    );
  }
}
