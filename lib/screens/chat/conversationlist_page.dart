import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messagerie/controllers/profile_controller/chat_controller.dart';
import 'package:messagerie/screens/chat/chat_page.dart';
import 'package:messagerie/screens/chat/new_message_page.dart';
import 'package:messagerie/screens/profile/profile_page.dart';
import 'package:messagerie/screens/profile/update_profil_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationlistPage extends StatefulWidget {
  const ConversationlistPage({Key? key}) : super(key: key);

  @override
  _ConversationlistPageState createState() => _ConversationlistPageState();
}

class _ConversationlistPageState extends State<ConversationlistPage> {
  int _currentIndex = 0;
  ChatController chatController = Get.put(ChatController());
  late StreamController<List<String>> _contactsStreamController;
  List<String> contacts = [];

  @override
  void initState() {
    super.initState();
    _contactsStreamController = StreamController<List<String>>.broadcast();
    _fetchContacts();
  }

  @override
  void dispose() {
    _contactsStreamController.close();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/contacts/get'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          contacts = data.map((contact) => contact['email'] as String).toList();
        });
        _contactsStreamController.add(contacts);
      } else {
        print('Failed to fetch contacts');
      }
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation List"),
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(NewMessagePage());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
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
            child: StreamBuilder<List<String>>(
              stream: _contactsStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ChatUserWidget(
                        text: snapshot.data![index],
                        secondaryText: "Tap to view messages",
                        image: "asset/images/avatar.png", // You can change this to match your design
                        time: "Now", // You can change this to match your design
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
          switch (index) {
            case 0:
              // Action to perform when "Chats" tab is selected
              break;
            case 1:
              Get.to(ScreenChat());
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

class ChatUserWidget extends StatelessWidget {
  final String text;
  final String secondaryText;
  final String image;
  final String time;

  const ChatUserWidget({
    required this.text,
    required this.secondaryText,
    required this.image,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle contact tap
        // You can navigate to a chat screen here if needed
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(image),
        ),
        title: Text(text),
        subtitle: Text(secondaryText),
        trailing: Text(time),
      ),
    );
  }
}