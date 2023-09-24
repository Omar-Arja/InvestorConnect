import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/services/api_service.dart';
import 'package:client/widgets/chat_card.dart';
import 'package:client/models/user_profile.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List profiles = [];

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  void fetchChats() async {
    final data = await ApiService.getChats();

    if (data['status'] == 'success') {
      setState(() {
        profiles = data['profiles'].map((profile) => UserProfile.fromJson(profile)).toList();
      });
    } else {
      print('Error fetching chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Color.fromARGB(255, 61, 78, 129),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 231, 234, 239),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: profiles.length,
        itemBuilder: (context, index) => ChatCard(profile: profiles[index]),
      )
    );
  }
}
