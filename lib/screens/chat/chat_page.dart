import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/src/stomp.dart';
import 'package:stomp_dart_client/src/stomp_config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ScreenChat extends StatefulWidget {
  final String currentUserId;
  final String contactId;
  const ScreenChat(
      {super.key, required this.currentUserId, required this.contactId});

  @override
  ScreenChatState createState() => ScreenChatState();
}

class ScreenChatState extends State<ScreenChat> {
  final String webSocketUrl = 'ws://192.168.56.1:8080/socket';
  late StompClient _client;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _client = StompClient(
      config: StompConfig(
        url: webSocketUrl,
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    _client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    _client.subscribe(
      destination: '/user/chatt/${widget.currentUserId}/queue/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          Map<String, dynamic> receivedMessage = json.decode(frame.body!);
          if (receivedMessage['senderId'] == widget.contactId ||
              receivedMessage['recipientId'] == widget.contactId) {
            setState(() {
              messages.add(receivedMessage);
            });
          }
        }
      },
    );
  }

  void _sendMessage() {
    final message = _controller.text;
    if (message.isNotEmpty) {
      final messageJson = {
        'data': message,
        'userId': widget.currentUserId,
        'timestamp': DateTime.now().toIso8601String(),
      };
      _client.send(
        destination: '/app/chatt',
        body: json.encode(messageJson),
      );
      setState(() {
        messages.add(messageJson);
        print(messages);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - 250;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.currentUserId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = messages[index];
                  return ListTile(
                    title: Text(item['data']),
                    subtitle: Text(item['timestamp']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    _client.deactivate();
    _controller.dispose();
    super.dispose();
  }
}
