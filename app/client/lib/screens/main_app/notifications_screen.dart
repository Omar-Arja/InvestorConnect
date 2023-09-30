import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/models/notification.dart';

class NotificationsScreen extends StatefulWidget {
  final List<NotificationModel> notifications;
  final Function updateNotifications;

  const NotificationsScreen({super.key, required this.notifications, required this.updateNotifications});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  void initState() {
    super.initState();
    refreshNotifications();
  }

  void refreshNotifications() {
    widget.updateNotifications();
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
          'Notifications',
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
          refreshNotifications();
        },
        child: _buildNotificationsList(widget.notifications),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {

    if (notifications.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 2),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notification.body,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Text(
                  notification.time,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 61, 78, 129),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          'No notifications yet',
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
