import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:InvestorConnect/services/auth_service.dart';
import 'package:InvestorConnect/screens/auth/authentication_screen.dart';
import 'package:InvestorConnect/screens/auth/login_screen.dart';
import 'package:InvestorConnect/screens/auth/signup_screen.dart';
import 'package:InvestorConnect/screens/profile/setup_profile_screen.dart';
import 'package:InvestorConnect/screens/profile/usertype_selection_screen.dart';
import 'package:InvestorConnect/screens/profile/startup/startup_setup_profile.dart';
import 'package:InvestorConnect/screens/profile/startup/startup_setup_profile_2.dart';
import 'package:InvestorConnect/screens/profile/startup/startup_setup_profile_3.dart';
import 'package:InvestorConnect/screens/profile/investor/investor_setup_profile.dart';
import 'package:InvestorConnect/screens/profile/investor/investor_setup_profile_2.dart';
import 'package:InvestorConnect/screens/main_app/main_app_screens.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 await Firebase.initializeApp();

 if (kDebugMode) {
   print("Handling a background message: ${message.messageId}");
   print('Message data: ${message.data}');
   print('Message notification: ${message.notification?.title}');
   print('Message notification: ${message.notification?.body}');
 }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }

  String? token = await messaging.getToken();
  AuthService.saveDeviceToken(token);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
   _messageStreamController.sink.add(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   
  final bool tokenValid = await AuthService.isTokenValid();
  runApp(App(tokenValid));
}

class App extends StatefulWidget {
  final bool tokenValid;

  const App(this.tokenValid, {Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  _AppState() {
    _messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {

          Fluttertoast.showToast(
            msg: message.notification?.body ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color.fromARGB(255, 76, 104, 175), 
      ),
      debugShowCheckedModeBanner: false,
      title: 'InvestorConnect',
      home: widget.tokenValid ? const MainAppScreens() : const AuthScreen(),
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