// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:messagerie/core/components/message_bubble.dart'; // Importez votre widget MessageBubble
// import 'package:messagerie/core/storage/app_storage.dart';
// import 'dart:convert';

// class ChatScreen extends StatefulWidget {
//   get senderId => AppStorage.readId( );
  
//   get recipientId => '';

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Message> messages = [];
//   TextEditingController messageController = TextEditingController();
//   late String userId; // Déclarer userId

//   @override
//   void initState() {
//     super.initState();
//     fetchUserId(); // Appeler fetchUserId lors de l'initialisation
//     fetchMessages(); // Appeler fetchMessages lors de l'initialisation
//   }

//   Future<void> fetchUserId() async {
//     userId = AppStorage.readId() ?? ''; // Lire l'ID de l'utilisateur depuis AppStorage
//   }

//   Future<void> sendMessage(String text, String recipientId) async {
//     // String channelId = await checkChannelExistence(userId, recipientId);
//     final response = await http.post(
//       Uri.parse('http://192.168.1.45:8080/chats'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(<String, String>{
//         'message': text,
//         'recipientId': recipientId,
//         'senderId': userId, // Utilisez l'ID de l'utilisateur actuel
//       }),
//     );
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       setState(() {
//         messages.add(Message.fromJson(responseData));
//       });
//     } else {
//       throw Exception('Failed to send message');
//     }
//   }

//  // Méthode pour récupérer les messages de l'utilisateur actuellement connecté
//   Future<void> fetchMessages() async {
//     final response = await http.get(Uri.parse('http://192.168.1.45:8080/chats?userId=$userId'));
//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = jsonDecode(response.body);
//       setState(() {
//         messages = responseData.map((json) => Message.fromJson(json)).toList();
//       });
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }

//   // Future<void> fetchMessages() async {
//   //   final response = await http.get(Uri.parse(
//   //       'http://192.168.1.45:8080/chats/conversation/${widget.senderId}/${widget.recipientId}'));
//   //   if (response.statusCode == 200) {
//   //     final List<dynamic> responseData = jsonDecode(response.body);
//   //     setState(() {
//   //       messages =
//   //           responseData.map((json) => Message.fromJson(json)).toList();
//   //     });
//   //   } else {
//   //     throw Exception('Failed to load messages');
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 final bool isSentByCurrentUser = message.senderId == userId;

//                 return MessageBubble(
//                   message: message.message,
//                   isSentByCurrentUser: isSentByCurrentUser, senderId: '', currentUserId: '',
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     sendMessage(messageController.text, '');
//                     messageController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Message {
//   final String id;
//   final String message;
//   final String senderId;
//   final String recipientId;

//   Message({
//     required this.id,
//     required this.message,
//     required this.senderId,
//     required this.recipientId,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['id'] ?? '',
//       message: json['message'] ?? '',
//       senderId: json['senderId'] ?? '',
//       recipientId: json['recipientId'] ?? '',
//     );
//   }
// }
