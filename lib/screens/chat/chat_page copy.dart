// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart';
// import 'package:messagerie/controllers/profile_controller/chat_controller.dart';
// import 'package:messagerie/core/networking/api_constants.dart';
// import 'package:messagerie/core/storage/app_storage.dart';
// import 'package:messagerie/models/all_message_model.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:whatsapp_camera/whatsapp_camera.dart';

// class ScreenChat extends StatefulWidget {
//   const ScreenChat({Key? key}) : super(key: key);

//   @override
//   _ScreenChatState createState() => _ScreenChatState();
// }

// class _ScreenChatState extends State<ScreenChat> {
//   bool showEmoji = false;
//   final files = ValueNotifier<List<File>>([]);
//   final SpeechToText speech = SpeechToText();
//   bool isMe = false;
//   List<Message> messages = [
//     Message(
//       content: "Hello!",
//       sender: "Manel",
//       time: "10:00 AM",
//       isMe: true,
//     ),
//     Message(
//       content: "Hi there!",
//       sender: "John",
//       time: "10:01 AM",
//       isMe: false,
//     ),
//   ];

//   void listenForPermissions() async {
//     final status = await Permission.microphone.status;
//     switch (status) {
//       case PermissionStatus.denied:
//         requestForPermission();
//         break;
//       case PermissionStatus.granted:
//         break;
//       case PermissionStatus.limited:
//         break;
//       case PermissionStatus.permanentlyDenied:
//         break;
//       case PermissionStatus.restricted:
//         break;
//       case PermissionStatus.provisional:
//         break;
//     }
//   }

//   Future<void> requestForPermission() async {
//     await Permission.microphone.request();
//   }

//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   String _lastWords = "";
//   double level = 0.0;
//   final TextEditingController _textController = TextEditingController();

//   void _initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//   }

//   void _startListening() async {
//     isMe = true;
//     await _speechToText.listen(
//       onResult: resultListener,
//       listenFor: const Duration(seconds: 10),
//       localeId: "en_En",
//       cancelOnError: false,
//       partialResults: false,
//       listenMode: ListenMode.confirmation,
//       onSoundLevelChange: soundLevelListener,
//     );

//     setState(() {
//       _textController.text = " ";
//       isMe = false;
//     });
//   }

//   ChatController chatController = Get.put(ChatController());

//   void soundLevelListener(double level) {
//     setState(() {
//       this.level = level;
//     });
//   }

//   void resultListener(SpeechRecognitionResult result) {
//     setState(() {
//       _lastWords = '${result.recognizedWords}';
//     });
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   @override
//   void dispose() {
//     files.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     chatController.getAllMsg();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 200, 126, 213),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: const Color.fromARGB(255, 227, 223, 223),
//               backgroundImage: AssetImage("asset/images/avatarr.jpg"),
//               radius: 16,
//             ),
//             SizedBox(width: 5),
//             Text(
//               "Manel",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(
//               Icons.video_call_outlined,
//               size: 30,
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: Icon(
//               Icons.more_vert,
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             GetBuilder<ChatController>(
//               builder: (controller) => FutureBuilder(
//                 future: controller.getAllMsg(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasData) {
//                     if (controller.allMessagesModel!.data == null ||
//                         controller.allMessagesModel!.data!.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           "Aucun message à afficher",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       );
//                     } else {
//                       return Expanded(
//                         child: ListView.separated(
//                           itemCount: controller.allMessagesModel!.data!.length,
//                           itemBuilder: (context, index) {
//                             final message = controller
//                                 .allMessagesModel!.data![index].message;
//                             return Align(
//                               alignment: message!.senderId == AppStorge.readId()
//                                   ? Alignment.topLeft
//                                   : Alignment.topRight,
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 5, horizontal: 10),
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: message.senderId ==
//                                           AppStorge.readId()
//                                       ? Color.fromARGB(255, 128, 108, 207)
//                                       : const Color.fromARGB(255, 174, 172, 172),
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: const Radius.circular(12),
//                                     topRight: const Radius.circular(12),
//                                     bottomLeft: message.senderId ==
//                                             AppStorge.readId()
//                                         ? const Radius.circular(0)
//                                         : const Radius.circular(18),
//                                     bottomRight: message.senderId ==
//                                             AppStorge.readId()
//                                         ? const Radius.circular(18)
//                                         : const Radius.circular(0),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   message.message!,
//                                   style: TextStyle(
//                                     color: message.senderId ==
//                                             AppStorge.readId()
//                                         ? Colors.white
//                                         : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return Center(
//                               child: Text(
//                                 "${chatController.allMessagesModel!.data![index].timestamp.toString().substring(11, 16)}",
//                                 style: TextStyle(
//                                     color: Colors.grey[150], fontSize: 10),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: "Type here",
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 15,
//                         ),
//                         prefixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               showEmoji = !showEmoji;
//                             });
//                           },
//                           icon: Icon(
//                             showEmoji
//                                 ? Icons.keyboard
//                                 : Icons.emoji_emotions_rounded,
//                             color: Colors.purple,
//                           ),
//                         ),
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             _openCamera();
//                           },
//                           icon: Icon(
//                             Icons.camera_alt_outlined,
//                             color: Colors.purple,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Container(
//                     width: 40,
//                     height: 40,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           blurRadius: .26,
//                           spreadRadius:
//                               _speechToText.isNotListening ? 0.0 : level * 1.5,
//                           color: Colors.black.withOpacity(.05),
//                         )
//                       ],
//                       color: Colors.grey[200],
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(50),
//                       ),
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
//                         color: Colors.purple,
//                       ),
//                       onPressed: () {
//                         listenForPermissions();
//                         if (!_speechEnabled) {
//                           _initSpeech();
//                         }
//                         _speechToText.isNotListening
//                             ? _startListening()
//                             : _stopListening;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Offstage(
//               offstage: !showEmoji,
//               child: SizedBox(
//                 height: 250,
//                 child: EmojiPicker(
//                   onEmojiSelected: (category, emoji) {
//                     _textController.text += emoji.emoji;
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }



// class Message {
//   final String content;
//   final String sender;
//   final String time;
//   final bool isMe;

//   Message({
//     required this.content,
//     required this.sender,
//     required this.time,
//     required this.isMe,
//   });
// }

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:stomp_dart_client/stomp_dart_client.dart';

class ScreenChat extends StatefulWidget {
  final String chatId;
  final String userId;
  const ScreenChat({super.key, required this.chatId, required this.userId});

  @override
  ScreenChatState createState() => ScreenChatState();
}

class ScreenChatState extends State<ScreenChat> {
  final String webSocketUrl = 'ws://192.168.56.1:8080/socket';
  late StompClient _client;
  final TextEditingController _controller = TextEditingController();
  List<dynamic> messages = List.empty();
  @override
  void initState() {
    super.initState();
    _client = StompClient(
        config: StompConfig(url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    _client.subscribe(
        destination: '/chat/messages',
        headers: {},
        callback: (frame) {
          print(frame.body);
          // Received a frame for this subscription
          messages = jsonDecode(frame.body!).reversed.toList();
        });
  }

  void _sendMessage() {
    final message = _controller.text;
    if (message.isNotEmpty) {
      _client.send(
        destination: '/app/chats', // Replace with your chat ID
        body: json.encode({
          
          'data': message,
          'userId': widget.userId
        }), // Format the message as needed
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - 250;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
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
            SingleChildScrollView(
              child: Container(
                height: screenHeight, // Set a fixed height here
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    // Extract the item from the list
                    Map<String, dynamic> item = messages[index];

                    // Create a Text widget for the item
                    return ListTile(
                      title: Text(item['data']),
                      // You can add more widgets here, e.g., icons, buttons, etc.
                    );
                  },
                ),
              ),
            )
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
