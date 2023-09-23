import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:client/services/auth_service.dart';
import 'package:client/screens/auth/authentication_screen.dart';
import 'package:client/screens/auth/login_screen.dart';
import 'package:client/screens/auth/signup_screen.dart';
import 'package:client/screens/profile/setup_profile_screen.dart';
import 'package:client/screens/profile/usertype_selection_screen.dart';
import 'package:client/screens/profile/startup/startup_setup_profile.dart';
import 'package:client/screens/profile/startup/startup_setup_profile_2.dart';
import 'package:client/screens/profile/startup/startup_setup_profile_3.dart';
import 'package:client/screens/profile/investor/investor_setup_profile.dart';
import 'package:client/screens/profile/investor/investor_setup_profile_2.dart';
import 'package:client/screens/main_app/main_app_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color.fromARGB(255, 76, 104, 175), 
      ),
      debugShowCheckedModeBanner: false,
      title: 'InvestorConnect',
      initialRoute: '/auth',
      home: FutureBuilder(
        future: AuthService.isTokenValid(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainAppScreens();
          } else {
            return const AuthScreen();
          }
        },
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/setup_profile': (context) => const SetupProfileScreen(),
        '/usertype_selection': (context) => const UsertypeSelectionScreen(),
        '/startup_setup_profile': (context) => const StartupSetupProfileScreen(),
        '/startup_setup_profile_2': (context) => const StartupSetupProfileScreen2(),
        '/startup_setup_profile_3': (context) => const StartupPreferencesScreen(),
        '/investor_setup_profile': (context) => const InvestorSetupProfileScreen(),
        '/investor_setup_profile_2': (context) => const InvestorPreferencesScreen(),
        '/home': (context) => const MainAppScreens(),
      },
    );
  }
}