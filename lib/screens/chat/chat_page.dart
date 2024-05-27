import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messagerie/ui_detect/detector_widget.dart';
import 'package:stomp_dart_client/src/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ScreenChat extends StatefulWidget {
  final String currentUserId;
  final String contactId;
  const ScreenChat(
      {Key? key, required this.currentUserId, required this.contactId})
      : super(key: key);

  @override
  _ScreenChatState createState() => _ScreenChatState();
}

class _ScreenChatState extends State<ScreenChat> {
  late StompClient _client;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.56.1:8080/socket',
        onConnect: _onConnectCallback,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    _client.activate();
  }

  void _onConnectCallback(StompFrame connectFrame) {
    print("/user/chatt/${widget.currentUserId}/queue/messages");
    _client.subscribe(
      destination: '/user/chatt/${widget.currentUserId}/queue/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          Map<String, dynamic> receivedMessage = json.decode(frame.body!);
          if ((receivedMessage['senderId'] == widget.currentUserId &&
                  receivedMessage['recipientId'] == widget.contactId) ||
              (receivedMessage['senderId'] == widget.contactId &&
                  receivedMessage['recipientId'] == widget.currentUserId)) {
            setState(() {
              messages.add(receivedMessage);
              print(widget.currentUserId);
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
        'content': message,
        'senderId': widget.currentUserId,
        'recipientId': widget.contactId,
        'timestamp': DateTime.now().toIso8601String(),
      };
      _client.send(
        destination: '/app/chatt',
        body: json.encode(messageJson),
      );
      setState(() {
        messages.add(messageJson);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - 250;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat withh ${widget.contactId}'),
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
            SizedBox(
              height: 300,
              child: DetectorWidget(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = messages[index];
                  return ListTile(
                    title: Text(item['content'] ?? 'No content'),
                    subtitle: Text(item['timestamp'] ?? 'No timestamp'),
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
