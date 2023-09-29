import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/widgets/ui/chat_card.dart';
import 'package:client/models/user_profile.dart';

class ChatsScreen extends StatefulWidget {
  final List<UserProfile> profiles;
  final Function updateChats;

  const ChatsScreen({super.key, required this.profiles, required this.updateChats});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  
  @override
  void initState() {
    super.initState();
    refreshChats();
  }

  void refreshChats() {
    widget.updateChats();
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
      body: RefreshIndicator(
        onRefresh: () async {
          widget.updateChats();
        },
        child: RefreshIndicator(
          onRefresh: () async {
            refreshChats();
          },
          child: _buildChatsList(widget.profiles),
        ),
      ),
    );
  }

  Widget _buildChatsList(List<UserProfile> profiles) {
    if (profiles.isNotEmpty) {
      profiles.sort((a, b) {
        final aTime = a.messages.last.createdAt;
        final bTime = b.messages.last.createdAt;
        return bTime.compareTo(aTime);
      });

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: profiles.length,
        itemBuilder: (context, index) => ChatCard(profile: profiles[index], updateChats: widget.updateChats),
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
  }
}