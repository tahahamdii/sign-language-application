import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messagerie/camera_view.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:camera/camera.dart';

class ScreenChat extends StatefulWidget {
  final String currentUserId;
  final String contactId;
  const ScreenChat({
    Key? key,
    required this.currentUserId,
    required this.contactId,
  }) : super(key: key);

  @override
  _ScreenChatState createState() => _ScreenChatState();
}

class _ScreenChatState extends State<ScreenChat> {
  late StompClient _client;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String contactUsername = '';
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;
  bool _isDetecting = false;
  List<dynamic>? _recognitions;

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

    // Fetch chat history and contact username when the screen initializes
    fetchChatHistory();
    fetchContactUsername();

    // Load TFLite model
  }

  void _onConnectCallback(StompFrame connectFrame) {
    _client.subscribe(
      destination: '/user/${widget.currentUserId}/queue/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          Map<String, dynamic> receivedMessage = json.decode(frame.body!);
          if ((receivedMessage['senderId'] == widget.currentUserId &&
                  receivedMessage['recipientId'] == widget.contactId) ||
              (receivedMessage['senderId'] == widget.contactId &&
                  receivedMessage['recipientId'] == widget.currentUserId)) {
            setState(() {
              messages.add(receivedMessage);
            });
          }
        }
      },
    );
  }

  void _sendMessage(String messageContent) {
    if (messageContent.isNotEmpty) {
      final messageJson = {
        'content': messageContent,
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
    }
  }

  // Function to fetch chat history from the backend
  void fetchChatHistory() {
    final url =
        'http://192.168.56.1:8080/messages/${widget.currentUserId}/${widget.contactId}';
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> chatHistory =
            List<Map<String, dynamic>>.from(jsonResponse);

        setState(() {
          messages.addAll(chatHistory);
        });
      } else {
        print('Failed to fetch chat history: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching chat history: $error');
    });
  }

  // Function to fetch contact's username
  void fetchContactUsername() {
    final url =
        'http://192.168.56.1:8080/api/users/username/${widget.contactId}';
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          contactUsername = response.body;
        });
      } else {
        print('Failed to fetch contact username: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching contact username: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $contactUsername'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = messages[index];
                  bool isCurrentUser = item['senderId'] == widget.currentUserId;
                  CrossAxisAlignment alignment = isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start;
                  Color backgroundColor =
                      isCurrentUser ? Colors.blue : Colors.grey;

                  return Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['content'] ?? 'No content',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['timestamp'] ?? 'No timestamp',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Send a message',
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraApp(
                              currentUserId: widget.currentUserId,
                              contactId: widget.contactId,
                            ),
                          ));
                    },
                    icon: const Icon(Icons.camera_rounded),
                    label: Container()),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
            if (_recognitions != null)
              ..._recognitions!.map((recog) {
                return Text(
                    "${recog['label']} ${(recog['confidence'] * 100).toStringAsFixed(0)}%");
              }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _client.deactivate();
    _controller.dispose();
    _cameraController.dispose(); // Dispose camera controller
    // Tflite.close(); // Close TFLite
    super.dispose();
  }
}
