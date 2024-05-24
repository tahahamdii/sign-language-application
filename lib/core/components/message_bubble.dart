import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String senderId;
  final String currentUserId;

  MessageBubble({
    required this.message,
    required this.senderId,
    required this.currentUserId, required bool isSentByCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: senderId == currentUserId ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: senderId == currentUserId ? Color.fromARGB(255, 87, 112, 142) : Colors.grey,
          borderRadius: BorderRadius.circular(15.0),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
