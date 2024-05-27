import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class SocketIOExample extends StatefulWidget {
  @override
  SocketIOExampleState createState() => SocketIOExampleState();
}

class SocketIOExampleState extends State<SocketIOExample> {
  final String serverUrl = 'http://localhost:8080/ws';
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    print('Initializing WebSocket connection');

    // Initialize and connect to the socket server.
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();
    
    socket.onConnect((_) {
      print('Connected to the WebSocket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the WebSocket server');
    });

    socket.on('message', (data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  // Function to send a message to the server.
  void sendMessage() {
    String message = messageController.text;
    if (message.isNotEmpty) {
      socket.emit('chat', jsonEncode({
        'senderId': 'sender_id_here',
        'recipientId': 'recipient_id_here',
        'content': message,
      }));
      messageController.clear();
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Chat Example'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
