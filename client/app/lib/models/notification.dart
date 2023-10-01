import 'package:intl/intl.dart';

class NotificationModel {
  final String title;
  final String body;
  final DateTime createdAt;
  final String time;

  NotificationModel({
    required this.title,
    required this.body,
    required this.createdAt,
  }) : time = DateFormat.jm().format(createdAt);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
}