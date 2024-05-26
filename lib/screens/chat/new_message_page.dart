import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:messagerie/controllers/profile_controller/chat_controller.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/screens/chat/conversationlist_page%20copy.dart';

class NewMessagePage extends GetView<ProfileController> {
  NewMessagePage({super.key});
  final ChatController chatController = Get.put(ChatController());

  Future<void> sendMessage() async {
    final String recipientEmail = controller.emailController.text;
    final int randomId =
        DateTime.now().millisecondsSinceEpoch; // Generate a random ID

    final Map<String, dynamic> payload = {
      'id': randomId,
      'email': recipientEmail,
    };

    final Uri uri = Uri.parse('http://localhost:8080/api/contacts/add');

    try {
      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
        // Optionally, you can navigate back or show a success message here
      } else {
        print('Failed to send message');
        // Handle error, show error message, etc.
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Recipient Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: controller.messageController,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await sendMessage();
                Get.to(ConversationlistPage());
              },
              child: const Text('Send', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:messagerie/controllers/profile_controller/chat_controller.dart';
// import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
// import 'package:messagerie/screens/chat/chat_page.dart';

// class NewMessagePage extends GetView<ProfileController> {

//   NewMessagePage({Key? key}) : super(key: key);
//   final ChatController chatController = Get.put(ChatController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Message'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: controller.emailController,
//               decoration: const InputDecoration(labelText: 'Recipient Email'),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: controller.messageController,
//               decoration: const InputDecoration(labelText: 'Message'),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 print("send msg---------------------------------------");
//                 controller.getUserByEmail();
//                 chatController.sendMessage(controller.messageController.text, controller.getUserModel!.id.toString());
//                 // Create channel and navigate to chat screen
//                // chatController.createChannel(controller.getUserModel!.id.toString());
//                 Get.to(ScreenChat());
//               },
//               child: const Text('Send', style: TextStyle(color: Colors.black),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

