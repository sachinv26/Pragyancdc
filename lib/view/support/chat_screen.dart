import 'package:flutter/material.dart';
import 'package:pragyan_cdc/constants/styles/styles.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png'),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Support',
              style: kTextStyle1,
            ),
            SizedBox(
              width: 8,
            ),
            Icon(Icons.call),
            Icon(Icons.video_call_sharp),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                ChatMessage(
                  messageContent: "Hi Dr. Amrita",
                  isSentByMe: true,
                  profileImagePath: 'assets/images/cute_little_girl.png',
                ),
                ChatMessage(
                  messageContent: "Hello! Arun",
                  isSentByMe: false,
                  profileImagePath:
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png',
                ),
                ChatMessage(
                  messageContent:
                      "Today's session went well, and my child enjoyed it. I've noticed significant positive changes in my child's behavior and activities during this one-week training.",
                  isSentByMe: true,
                  profileImagePath: 'assets/images/cute_little_girl.png',
                ),
                ChatMessage(
                  messageContent:
                      "I'm glad to hear that the session went well, and your child enjoyed it. It's great to see significant positive changes in their behavior and activities after just one week of training.",
                  isSentByMe: false,
                  profileImagePath:
                      'assets/images/psychologist-cute-young-professional-brunette-lady-providing-online-sessions-glasses 1.png',
                ),
                ChatMessage(
                  messageContent: "Hello! I am good today",
                  isSentByMe: true,
                  profileImagePath: 'assets/images/cute_little_girl.png',
                ),
              ],
            ),
          ),
          // Input field and icons
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type here',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // Handle mic icon press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // Handle camera icon press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Handle attach file icon press
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String messageContent;
  final bool isSentByMe;
  final String profileImagePath;

  const ChatMessage({
    super.key,
    required this.messageContent,
    required this.isSentByMe,
    required this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: isSentByMe
                  ? const EdgeInsets.only(left: 8.0)
                  : const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                messageContent,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          CircleAvatar(
            backgroundImage: AssetImage(profileImagePath),
          ),
        ],
      ),
    );
  }
}
