import 'dart:async';
import 'package:InvestorConnect/models/investor_profile.dart';
import 'package:InvestorConnect/models/notification.dart';
import 'package:InvestorConnect/models/startup_profile.dart';
import 'package:InvestorConnect/models/user_profile.dart';
import 'package:InvestorConnect/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:InvestorConnect/widgets/ui/bottom_navbar.dart';
import 'package:InvestorConnect/screens/main_app/home_screen.dart';
import 'package:InvestorConnect/screens/main_app/messages/chats_screen.dart';
import 'package:InvestorConnect/screens/main_app/notifications_screen.dart';
import 'package:InvestorConnect/screens/main_app/profile_screen.dart';

class MainAppScreens extends StatefulWidget {
  const MainAppScreens({super.key});

  @override
  _MainAppScreensState createState() => _MainAppScreensState();
}

class _MainAppScreensState extends State<MainAppScreens> {
  int _currentIndex = 0;
  List<InvestorProfileModel> investorProfiles = [];
  List<StartupProfileModel> startupProfiles = [];
  List<NotificationModel> notifications = [];
  List<UserProfile> profiles = [];
  Map<String, dynamic> profile = {};
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllData() async {
    await Future.wait([
      getPotentialMatches(),
      getChats(),
      getNotifications(),
      getProfile(),
    ]);
  }

  Future<void> getPotentialMatches() async {
    final List<StartupProfileModel> newStartupProfiles = [];
    final List<InvestorProfileModel> newInvestorProfiles = [];
    final response = await ApiService.getPotentialMatches();

    if (response['status'] == 'success') {
      final potentialMatches = response['potential_matches'];
      for (final match in potentialMatches) {
        if (response['usertype_name'] == 'investor') {
          final investorProfile = InvestorProfileModel.fromJson(match);
          newInvestorProfiles.add(investorProfile);
        } else if (response['usertype_name'] == 'startup') {
          final startupProfile = StartupProfileModel.fromJson(match);
          newStartupProfiles.add(startupProfile);
        }
      }

      setState(() {
        investorProfiles = newInvestorProfiles;
        startupProfiles = newStartupProfiles;
        isDataLoaded = true;
      });
    }
  }

  Future<void> getChats() async {
    final List<UserProfile> newProfiles = [];
    final response = await ApiService.getChats();

    if (response['status'] == 'success') {
      final List chatsData = response['profiles'];
      for (final chat in chatsData) {
        final profile = UserProfile.fromJson(chat);
        newProfiles.add(profile);
      }
      
      setState(() {
        profiles = newProfiles;
      });
    }
  }

  Future<void> getNotifications() async {
    final List<NotificationModel> newNotifications = [];
    final response = await ApiService.getNotifications();

    if (response['status'] == 'success') {
      final List notificationsData = response['notifications'];
      for (final notification in notificationsData) {
        final notificationModel = NotificationModel.fromJson(notification);
        newNotifications.add(notificationModel);
      }
      newNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        notifications = newNotifications;
      });
    }
  }

  Future<void> getProfile() async {
    final response = await ApiService.getProfile();

    if (response['status'] == 'success') {
      if (response['usertype_name'] == 'investor') {
        InvestorProfileModel currentProfile;
        currentProfile = InvestorProfileModel.fromJson(response['profile']);
        profile['fullName'] = currentProfile.fullName;
        profile['location'] = currentProfile.location;
        profile['profilePictureUrl'] = currentProfile.profilePictureUrl;
        profile['description'] = currentProfile.bio;
      } else if (response['usertype_name'] == 'startup') {
        StartupProfileModel currentProfile;
        currentProfile = StartupProfileModel.fromJson(response['profile']);
        profile['fullName'] = currentProfile.fullName;
        profile['location'] = currentProfile.location;
        profile['profilePictureUrl'] = currentProfile.companyLogoUrl;
        profile['description'] = currentProfile.companyDescription;
      }
      setState(() {
        profile = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 61, 78, 129),
            semanticsLabel: 'Loading',
          ),
        ),
      );
    }

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
        return HomeScreen(
            investorProfiles: investorProfiles,
            startupProfiles: startupProfiles,
            updateMatches: getPotentialMatches);
      case 1:
        return ChatsScreen(profiles: profiles, updateChats: getChats);
      case 2:
        return NotificationsScreen(
            notifications: notifications,
            updateNotifications: getNotifications);
      case 3:
        return ProfileScreen(profile: profile);
      default:
        return HomeScreen(
            investorProfiles: investorProfiles,
            startupProfiles: startupProfiles,
            updateMatches: getPotentialMatches);
    }
  }
}
