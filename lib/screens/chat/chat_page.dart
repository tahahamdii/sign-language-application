import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messagerie/camera_view.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:camera/camera.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

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

  late SpeechToText _speechToText;
  bool _isListening = false;
  String _text = "";
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.45:8085/socket',
        onConnect: _onConnectCallback,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    _client.activate();

    fetchChatHistory();
    fetchContactUsername();

    _speechToText = SpeechToText();
    _initSpeech();

    flutterTts = FlutterTts();
    configureTts();
  }
  

  Future<void> configureTts() async {
    await flutterTts.setLanguage("fr-FR");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
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
        'timestamp': DateTime.now().toString().substring(11, 16),
      };
      _client.send(
        destination: '/app/chatt',
        body: json.encode(messageJson),
      );
      setState(() {
        messages.add(messageJson);
      });
      _controller.clear();

      // Convertir le texte en parole
      _speak(messageContent);
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  void fetchChatHistory() {
    final url =
        'http://192.168.1.45:8085/messages/${widget.currentUserId}/${widget.contactId}';
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

  Future<void> _deleteMessage(String messageId, int index) async {
    final url = 'http://192.168.1.45:8085/messages/$messageId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 204) {
      setState(() {
        messages.removeAt(index);
      });
    } else {
      print('Failed to delete message. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _confirmDeleteMessage(String messageId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteMessage(messageId, index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void fetchContactUsername() {
    final url =
        'http://192.168.1.45:8085/api/users/username/${widget.contactId}';
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

  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() {});
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _startListening() async {
    await _requestMicrophonePermission();
    if (_speechToText.isAvailable && !_isListening) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(
        onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            _controller.text = _text;
          });
        },
      );
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactUsername,
        style: TextStyle(
          color: Colors.white,
        ),),
        
        backgroundColor: Color.fromARGB(255, 16, 9, 74),
        iconTheme: IconThemeData(color: Colors.white), // Change back arrow color to white


      ),
      body : Padding(
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
                  Color? backgroundColor =
                      isCurrentUser ? Color.fromARGB(255, 212, 83, 175) : Colors.grey;

                  return GestureDetector(
                    onTap: () {
                      _speak(item['content'] ?? 'No content');
                    },
                    onLongPress: () {
                      _confirmDeleteMessage(item['id'], index); // Utiliser 'id' comme identifiant du message
                    },
                    child: Align(
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
                          crossAxisAlignment: alignment,
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
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Send a message',
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  // Trigger a rebuild to show/hide send button
                                });
                              },
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () => _sendMessage(_controller.text),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraApp(
                          currentUserId: widget.currentUserId,
                          contactId: widget.contactId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _client.deactivate();
    _controller.dispose();
    flutterTts.stop(); // Arrêter toute lecture en cours
    super.dispose();
  }
}

