import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:client/widgets/input_fields.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final InputField firstName = InputField(
    label: 'First Name',
    icon: Icons.person_outline,
    hint: 'John',
  );

  final InputField lastName = InputField(
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
                            Expanded(child: firstName),
                            const SizedBox(width: 10),
                            Expanded(child: lastName),
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
                  CustomButton(text: 'Sign Up', onPressed: () {
                    String email = emailInput.inputValue;
                    String password = passwordInput.inputValue;
                    print('Email: $email, Password: $password');
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
