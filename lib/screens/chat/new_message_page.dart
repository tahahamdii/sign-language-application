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
  TextEditingController emailcontactController = TextEditingController();

  Future<void> addContact(String recipientEmail) async {
    // final String recipientEmail = emailcontactController.text.trim();
    final String recipientName = controller.nameController.text;
    final int randomId = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> payload = {
      'id': randomId,
      'name': recipientName,
      'email': recipientEmail,
      'currentUserId': currentUserId,
    };

    final Uri uri = Uri.parse(
        'http://192.168.1.45:8085/api/users/addContacts/$currentUserId');

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
        title: Text(
          'Add Contact',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 16, 9, 74),
        iconTheme: IconThemeData(color: Colors.white),
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
              controller: emailcontactController,
              decoration: InputDecoration(
                labelText: 'Contact Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await addContact(emailcontactController.text);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 16, 9, 74),
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
