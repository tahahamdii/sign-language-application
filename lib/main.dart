import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:messagerie/core/bindings/bindings.dart';
import 'package:messagerie/screens/Splash_Animated.dart';
import 'package:camera/camera.dart';
import 'package:camera_web/camera_web.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final socketUrl = 'http://192.168.1.45:8085/socket';

late List<CameraDescription> cameras;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Error fetching cameras: $e');
  }
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AllBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Kifna Messagerie',
      theme: ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashAnimated(),
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
    print("");
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
