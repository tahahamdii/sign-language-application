import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messagerie/controllers/profile_controller/chat_controller.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/screens/chat/chat_page.dart';
import 'package:messagerie/screens/chat/new_message_page.dart';
import 'package:messagerie/screens/profile/profile_page.dart';
import 'package:messagerie/screens/profile/update_profil_page.dart';
import 'package:messagerie/core/storage/app_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationlistPage extends StatefulWidget {
  const ConversationlistPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _ConversationlistPageState createState() => _ConversationlistPageState();
}

class _ConversationlistPageState extends State<ConversationlistPage> {
  final ProfileController profileController = Get.find();
  int _currentIndex = 0;
  ChatController chatController = Get.put(ChatController());
  late StreamController<List<Contact>> _contactsStreamController;
  List<Contact> contacts = [];
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    _contactsStreamController = StreamController<List<Contact>>.broadcast();
    _fetchContacts();
    currentUserId = profileController.currentUserId.value;
    print(currentUserId); // Fetch current user ID when the page initializes
  }

  @override
  void dispose() {
    _contactsStreamController.close();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.45:8085/api/users/contacts/${widget.id}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          contacts = data.map((contact) => Contact.fromJson(contact)).toList();
        });
         fetchContactsImages(); // Call function to fetch images
        _contactsStreamController.add(contacts);
      } else {
        print('Failed to fetch contacts');
      }
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  Future<void> fetchContactsImages() async {
    for (Contact contact in contacts) {
      try {
        final response = await http.get(Uri.parse(
            'http://192.168.1.45:8085/api/users/imageByEmail/${contact.email}'));
        if (response.statusCode == 200) {
          contact.imageUrl = response.body;
        } else {
          print('Failed to fetch image for email: ${contact.email}');
        }
      } catch (e) {
        print('Error fetching image for email: ${contact.email} - $e');
      }
    }
    _contactsStreamController
        .add(contacts); // Update the stream with image URLs
  }

  Future<void> _deleteContact(String email) async {
    for (Contact contact in contacts) {
      try {
        final response = await http.delete(Uri.parse(
            'http://192.168.1.45:8085/api/users/removeContacts/${widget.id}/${contact.email}'));
        if (response.statusCode == 200) {
          setState(() {
            contacts.removeWhere((contact) => contact.email == email);
          });
          _contactsStreamController.add(contacts);
        } else {
          print('Failed to delete contact');
        }
      } catch (e) {
        print('Error deleting contact: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id); // Print widget ID (currentUserId)
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation List",
        style: TextStyle(color : Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 16, 9, 74),
        iconTheme: IconThemeData(color: Colors.white), // Change back arrow color to white

      ),
      drawer: ProfilePage(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Conversations",
                  style: TextStyle(
                      color: Colors.black,
                    fontSize: 24, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(NewMessagePage(currentUserId: currentUserId));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 212, 83, 175),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Add New",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Contact>>(
              stream: _contactsStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ChatUserWidget(
                        name: snapshot.data![index].name,
                        email: snapshot.data![index].email,
                        image: snapshot.data![index]
                             .imageUrl, // Use image URL from contact
                        time: "", // You can change this to match your design
                        currentUserId: widget.id, // Pass currentUserId
                        onTap: () {}, // Add an empty callback for now
                        onDelete: () => _deleteContact(
                            snapshot.data![index].email), // Add delete callback
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 16, 9, 74),
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              // Action to perform when "Chats" tab is selected
              break;
            case 1:
              // Navigate to ScreenChat with currentUserId and contactId

              break;
            case 2:
              Get.to(UpdateProfilPage());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final String email;
  String? imageUrl;

  Contact({required this.name, required this.email,});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      email: json['email'],
    );
  }
}

class ChatUserWidget extends StatelessWidget {
  final String name;
  final String email;
  final String time;
  final VoidCallback onTap;
  final VoidCallback onDelete; // Add delete callback
  final String currentUserId; // Add currentUserId parameter
 final String? image;

  const ChatUserWidget({
    required this.name,
    required this.email,
    required this.image,
    required this.time,
    required this.onTap,
    required this.onDelete, // Update constructor
    required this.currentUserId, // Update constructor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String contactId = await _fetchContactId(email); // Fetch contact ID
        if (contactId.isNotEmpty) {
          Get.to(ScreenChat(
            currentUserId: currentUserId, // Use currentUserId from state
            contactId: contactId,
          ));
          print(currentUserId); // Print currentUserId
        } else {
          print('Failed to fetch contact ID for email: $email');
        }
      },
      child: ListTile(
        leading: CircleAvatar(
         // backgroundImage: AssetImage("assets/images/avatarr.jpg"),
          backgroundImage: image != null
              ? NetworkImage(image!)
              : AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(time),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, 
              color: Colors.pink),
              onPressed: onDelete, // Handle delete
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _fetchContactId(String email) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.45:8085/api/users/idByEmail?email=$email'));
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        String contactId = data['id'] as String;
        print(contactId);
        return contactId;
      } else {
        print('Failed to fetch contact ID for email: $email');
        return '';
      }
    } catch (e) {
      print('Error fetching contact ID for email: $email - $e');
      return '';
    }
  }
}
