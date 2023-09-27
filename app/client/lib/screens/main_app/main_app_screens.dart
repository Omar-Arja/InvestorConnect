import 'package:client/models/investor_profile.dart';
import 'package:client/models/startup_profile.dart';
import 'package:client/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/ui/bottom_navbar.dart';
import 'package:client/screens/main_app/home_screen.dart';
import 'package:client/screens/main_app/messages/chats_screen.dart';
import 'package:client/screens/main_app/calendar_screen.dart';
import 'package:client/screens/main_app/notifications_screen.dart';
import 'package:client/screens/main_app/profile/profile_screen.dart';

class MainAppScreens extends StatefulWidget {
  const MainAppScreens({super.key});

  @override
  _MainAppScreensState createState() => _MainAppScreensState();
}

class _MainAppScreensState extends State<MainAppScreens> {
  int _currentIndex = 0;
  List<StartupProfileModel> startupProfiles = [];
  List<InvestorProfileModel> investorProfiles = [];
  
  void getPotentialMatches() async {
    final response = await ApiService.getPotentialMatches();
    if (response['status'] == 'success') {
      final List potentialMatches = response['potential_matches'];
      for (final match in potentialMatches) {
        if (response['usertype_name'] == 'investor') {
          investorProfiles.add(InvestorProfileModel.fromJson(match));
        } else if (response['usertype_name'] == 'startup') {
          startupProfiles.add(StartupProfileModel.fromJson(match));
        }
      }
        
      setState(() {
        investorProfiles;
        startupProfiles;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPotentialMatches();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      extendBody: true,
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        if (investorProfiles.isNotEmpty || startupProfiles.isNotEmpty) {
          return HomeScreen(investorProfiles: investorProfiles, startupProfiles: startupProfiles);
        } else {
          return PotentialMatchesLoader(investorProfiles: investorProfiles, startupProfiles: startupProfiles);
        }
      case 1:
        return const ChatsScreen();
      case 2:
        return const CalendarScreen();
      case 3:
        return const NotificationsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return HomeScreen(investorProfiles: investorProfiles, startupProfiles: startupProfiles);
    }
  }
}

class PotentialMatchesLoader extends StatelessWidget {
  const PotentialMatchesLoader({
    super.key,
    required this.investorProfiles,
    required this.startupProfiles,
  });

  final List<InvestorProfileModel> investorProfiles;
  final List<StartupProfileModel> startupProfiles;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getPotentialMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return HomeScreen(investorProfiles: investorProfiles, startupProfiles: startupProfiles);
          
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading potential matches'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
