import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:messagerie/controllers/profile_controller/chat_controller.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/screens/chat/conversationlist_page.dart';

class NewMessagePage extends GetView<ProfileController> {
  final String currentUserId;
  NewMessagePage({Key? key, required this.currentUserId}) : super(key: key);
  final ChatController chatController = Get.put(ChatController());

  Future<void> addContact() async {
    final String recipientEmail = controller.emailController.text;
    final String recipientName = controller.nameController.text; // Get name
    final int randomId =
        DateTime.now().millisecondsSinceEpoch; // Generate a random ID

    final Map<String, dynamic> payload = {
      'id': randomId,
      'name': recipientName, // Include name in payload
      'email': recipientEmail,
      'currentUserId': currentUserId,
    };

    final Uri uri =
        Uri.parse('http://localhost:8080/api/users/addContacts/$currentUserId');

    try {
      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Contact added successfully');
        // Optionally, you can navigate back or show a success message here
        Get.to(ConversationlistPage(id: currentUserId));
      } else {
        print('Failed to add contact');
        // Handle error, show error message, etc.
      }
    } catch (e) {
      print('Error adding contact: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Contact Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Contact Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await addContact();
              },
              child: const Text('Add Contact',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
