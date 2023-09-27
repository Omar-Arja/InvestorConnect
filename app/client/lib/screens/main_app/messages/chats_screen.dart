import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/services/api_service.dart';
import 'package:client/widgets/ui/chat_card.dart';
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

  void updateChats() {
    setState(() {
      fetchChats();
    });
  }

  void fetchChats() async {
    final data = await ApiService.getChats();

    if (data['status'] == 'success') {
      if (mounted) {
        setState(() {
          profiles = data['profiles'].map((profile) => UserProfile.fromJson(profile)).toList();
        });
      }
    } else {
      print('Error fetching chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    profiles.sort((a, b) {
      final aTime = a.messages.last.createdAt;
      final bTime = b.messages.last.createdAt;
      return bTime.compareTo(aTime);
    });
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
      body: FutureBuilder(
        future: ApiService.getChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (profiles.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 60),
                itemCount: profiles.length,
                itemBuilder: (context, index) => ChatCard(profile: profiles[index], updateChats: updateChats,),
              );
            } else {
              return const Center(
                child: Text(
                  'No chats yet',
                  style: TextStyle(
                    color: Color.fromARGB(255, 61, 78, 129),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading chats'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Loading...'));
          }
        },
      )
    );
  }
}