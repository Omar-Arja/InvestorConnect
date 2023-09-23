import 'package:flutter/material.dart';
import 'package:client/models/user_profile.dart';
import 'package:client/screens/main_app/messages/conversation_screen.dart';

class ChatCard extends StatelessWidget {
  final UserProfile profile;

  const ChatCard({super.key, required this.profile});

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
          foregroundImage: NetworkImage(profile.profilePictureUrl),
          backgroundImage: const AssetImage('assets/images/founder.png'),
          onBackgroundImageError: (exception, stackTrace) => const AssetImage('assets/images/founder.png'),
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
            profile.messages.last.message,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
            ),
          ),
        ),
        trailing: Text(profile.messages.last.time),
        tileColor: Colors.white,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(profile: profile),
            ),
          );
        },
      ),
    );
  }
}
