import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/screens/auth/authentication_screen.dart';
import 'package:client/screens/auth/login_screen.dart';
import 'package:client/screens/auth/signup_screen.dart';
import 'package:client/screens/profile/setup_profile_screen.dart';
import 'package:client/screens/profile/usertype_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(App(prefs));
}

class App extends StatelessWidget {
  final SharedPreferences prefs;

  const App(this.prefs, {super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color.fromARGB(255, 76, 104, 175), 
      ),
      debugShowCheckedModeBanner: false,
      title: 'InvestorConnect',
      initialRoute: '/usertype_selection',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/login': (context) => LoginScreen(prefs),
        '/signup': (context) => const SignupScreen(),
        '/setup_profile':(context) => const SetupProfileScreen(),
        '/usertype_selection':(context) => const UsertypeSelectionScreen(),
      },
    );
  }
}