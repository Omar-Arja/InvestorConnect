import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/services/api_service.dart';
import 'package:client/models/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void updateNotifications() {
    setState(() {
      fetchNotifications();
    });
  }

  void fetchNotifications() async {
    final data = await ApiService.getNotifications();

    if (data['status'] == 'success') {
      if (mounted) {
        notifications = (data['notifications'] as List<dynamic>).map((notification) => NotificationModel.fromJson(notification)).toList();
        notifications.sort((a, b) {
            final aTime = a.createdAt;
            final bTime = b.createdAt;
            return bTime.compareTo(aTime);
          });
        setState(() {
          notifications;
        });
      }
    } else {
      print('Error fetching notifications');
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
      body: FutureBuilder(
        future: ApiService.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (notifications.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 60),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading notifications'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}
