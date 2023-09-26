import 'package:flutter/material.dart';
import 'package:client/models/user_profile.dart';
import 'package:client/screens/main_app/messages/conversation_screen.dart';

class ChatCard extends StatelessWidget {
  final UserProfile profile;
  final Function? updateChats;

  const ChatCard({super.key, required this.profile, this.updateChats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        shape: const CircleBorder(eccentricity: 1),
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color.fromARGB(255, 76, 104, 175),
          foregroundImage: NetworkImage(profile.profilePictureUrl),
          backgroundImage: const AssetImage('assets/images/founder.png'),
          onForegroundImageError: (exception, stackTrace) => const AssetImage('assets/images/founder.png'),
        ),
        title: Text(
          profile.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            fontSize: 18,
            color: Color.fromARGB(255, 66, 66, 66)
          ),
        ),
        subtitle: Container(
          constraints: const BoxConstraints(
            maxHeight: 30,
          ),
          child: Text(
            profile.messages.lastOrNull?.message ?? 'Start a conversation',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontStyle: profile.messages.lastOrNull?.message != null ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
        trailing: Text(profile.messages.lastOrNull?.time ?? ''),
        tileColor: Colors.white,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(profile: profile, updateChats: updateChats),
            ),
          );
        },
      ),
    );
  }
}
