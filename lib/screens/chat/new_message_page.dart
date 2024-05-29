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
    final String recipientName = controller.nameController.text;
    final int randomId = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> payload = {
      'id': randomId,
      'name': recipientName,
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
        Get.to(ConversationlistPage(id: currentUserId));
      } else if (response.statusCode == 400) {
        print('Failed to add contact. You are Already Friends :)');
        // Show alert dialog or snackbar with the message
        // Example of showing snackbar:
        Get.snackbar(
          'Failed to add contact',
          'You are Already Friends :)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('Failed to add contact');
      }
    } catch (e) {
      print('Error adding contact: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Contact Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: 'Contact Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await addContact();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Add Contact',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
