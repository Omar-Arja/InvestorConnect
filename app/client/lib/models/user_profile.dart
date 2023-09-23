import 'package:client/models/message.dart';

class UserProfile {
  final int id;
  final String fullName;
  final String profilePictureUrl;
  final List<Message> messages;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.profilePictureUrl,
    required this.messages,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profileData = json['profile'];
    final messagesData = json['messages'] as List<dynamic>;

    final profile = UserProfile(
      id: profileData['id'],
      fullName: profileData['full_name'],
      profilePictureUrl: profileData['profile_picture_url'],
      messages: messagesData.map((messageJson) {
        return Message.fromJson(messageJson);
      }).toList(),
    );

    return profile;
  }
}
