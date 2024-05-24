import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:messagerie/chat_screen.dart';
import 'package:messagerie/core/bindings/bindings.dart';
import 'package:messagerie/screens/chat/chat_page.dart';

import 'package:flutter/material.dart'; // Import the library that defines 'bodyText1'

import 'package:messagerie/screens/profile/code_page.dart';
import 'package:messagerie/screens/profile/new_password.dart';
import 'package:messagerie/screens/profile/signin_page.dart';
import 'package:messagerie/socket_connection.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:stomp_dart_client/stomp_dart_client.dart';




final socketUrl = 'http://localhost:8085/socket';


Future<void> main() async {
  await GetStorage.init();
  //socket.onConnect((_) 
  {
    print('connect');};
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AllBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
    );
  }

}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StompClient? stompClient;

  String message = '';

  void onConnect(StompClient client, StompFrame frame) {
    print("connnect");
    // client.subscribe(
    //     destination: '/topic/message',
    //     callback: (StompFrame frame) {
    //       if (frame.body != null) {
    //         Map<String, dynamic> result = json.decode(frame.body);
    //         //print(result['message']);
    //         setState(() => message = result['message']);
    //       }
    //     });
  }

  @override
  void initState() {
    super.initState();
  print ("");
    if (stompClient == null) {
      print("*********");
      stompClient = StompClient(
        config: StompConfig.sockJS(
        url: socketUrl,
        onConnect: (p0) => print("connect=$p0"),

        onWebSocketError: (dynamic error) => print(error.toString()),
      ));

      stompClient!.activate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your message from server:',
            ),
            Text(
              '$message',

              // ...

              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient!.deactivate();
    }

    super.dispose();
  }
}