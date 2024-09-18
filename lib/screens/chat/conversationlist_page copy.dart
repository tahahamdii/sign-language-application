import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConversationlistPage extends StatefulWidget {
  const ConversationlistPage({Key? key}) : super(key: key);

  @override
  _ConversationlistPageState createState() => _ConversationlistPageState();
}

class _ConversationlistPageState extends State<ConversationlistPage> {
  List<String> contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.45:8085/api/contacts/get'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        contacts = data.map((contact) => contact['email'] as String).toList();
      });
    } else {
      // Handle error
      print('Failed to fetch contacts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation List"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Conversations",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      // Handle contact tap
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            contacts[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
