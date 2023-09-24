import 'dart:async';
import 'package:client/services/api_service.dart';
import 'package:client/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:client/models/user_profile.dart';
import 'package:client/models/message.dart';
import 'package:flutter/services.dart';

class ConversationScreen extends StatefulWidget {
  final UserProfile profile;
  final Function? updateChats;

  const ConversationScreen({Key? key, required this.profile, this.updateChats}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  String chatId = '';

  @override
  void initState() {
    super.initState();
    initializeChat();
    scrollToLastMessage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollToLastMessage();
  }

  Future<void> initializeChat() async {
    messages = widget.profile.messages;
    final userId = await AuthService.getUserId();
    final profileId = widget.profile.id;
    final chatIds = [userId, profileId];
    chatIds.sort();
    chatId = chatIds.join('_');

    final messagesCollection = FirebaseFirestore.instance
        .collection('conversations')
        .doc(chatId)
        .collection('messages');

    messagesCollection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((querySnapshot) {
      final messages = querySnapshot.docs.map((e) => Message(
        senderId: e['senderId'],
        receiverId: e['receiverId'],
        message: e['message'],
        isSender: e['senderId'] == userId,
        createdAt: e['createdAt'].toDate(),
      )).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      setState(() {
        this.messages = messages;
        scrollToLastMessage();
      });
    });
  }

  void scrollToLastMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage(String message) async {
    final newMessage = Message(
      senderId: await AuthService.getUserId(),
      receiverId: widget.profile.id,
      message: message,
      isSender: true,
      createdAt: DateTime.now(),     
    );

    setState(() {
      messages.add(newMessage);
      _messageController.clear();
      Timer(
        const Duration(milliseconds: 300),
        () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
      );
    });

    final data = await ApiService.sendMessage(newMessage);
    if (data['status'] == 'success') {

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': newMessage.senderId,
            'receiverId': newMessage.receiverId,
            'message': newMessage.message,
            'createdAt': newMessage.createdAt,
          });
    } else {
      print('Error sending message');
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 231, 234, 239),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 50, 65, 110),
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.updateChats != null) {
              widget.updateChats!();
            }
            Navigator.of(context).pop();
          },
        ),
        elevation: 1,
        title: Text(widget.profile.fullName),
        backgroundColor: const Color.fromARGB(255, 61, 78, 129),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color.fromARGB(255, 76, 104, 175),
              child: IconButton(
                icon: const Icon(Icons.video_chat_outlined),
                iconSize: 28,
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatId.isNotEmpty ? FirebaseFirestore.instance
                .collection('conversations')
                .doc(chatId)
                .collection('messages')
                .orderBy('createdAt', descending: false)
                .snapshots() : null,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  scrollToLastMessage();
              return ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isSender = message.isSender;
                  final messageBubbleColor = isSender ? const Color.fromARGB(255, 61, 78, 129) : Colors.white;
                  final messageTextColor = isSender ? Colors.white : Colors.black;
                  final messageTimeColor = isSender ? const Color.fromARGB(255, 177, 177, 177) : const Color.fromARGB(255, 134, 134, 134);
                  
                  return ChatBubble(isSender: isSender, widget: widget, messageBubbleColor: messageBubbleColor, message: message, messageTextColor: messageTextColor, messageTimeColor: messageTimeColor);
                },
              );
              }
            }
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0, MediaQuery.of(context).size.width * 0.02, 8),
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(28),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 61, 78, 129),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          final newMessage = _messageController.text;
                          if (newMessage.isNotEmpty) {
                            sendMessage(newMessage);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isSender,
    required this.widget,
    required this.messageBubbleColor,
    required this.message,
    required this.messageTextColor,
    required this.messageTimeColor,
  });

  final bool isSender;
  final ConversationScreen widget;
  final Color messageBubbleColor;
  final Message message;
  final Color messageTextColor;
  final Color messageTimeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender)
          ...[
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: CircleAvatar(
                radius: 21,
                backgroundImage: NetworkImage(widget.profile.profilePictureUrl),
              ),
            )
          ],
        const SizedBox(width: 8),
        Expanded(
          child: Align(
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              margin: const EdgeInsets.only(top: 8, right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: messageBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSender ? 15 : 1),
                  topRight: Radius.circular(isSender ? 1 : 15),
                  bottomLeft: const Radius.circular(15),
                  bottomRight: const Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(color: messageTextColor, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: TextStyle(color: messageTimeColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
