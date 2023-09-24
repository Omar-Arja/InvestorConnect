import 'package:intl/intl.dart';

class Message {
  final int? id;
  final int? senderId;
  final int receiverId;
  final String message;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSender;
  final String time;

  Message({
    this.id,
    this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    this.updatedAt,
    required this.isSender,
  }) : time = DateFormat.jm().format(createdAt);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      isSender: json['is_sender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId?.toString(),
      'receiver_id': receiverId.toString(),
      'message': message,
    };
  }
}
