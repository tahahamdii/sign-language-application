import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:messagerie/main.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:async';
/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({
    super.key,
    required this.currentUserId,
    required this.contactId,
  });

  final String currentUserId;
  final String contactId;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late StompClient _client;

  CameraImage? cameraImage;
  late CameraController controller;
  String aux = '';
  String output = '';
  CameraDescription cameraId = cameras[1];
  Timer? timer;
  void _sendMessage(String messageContent) {
    if (messageContent.isNotEmpty) {
      final messageJson = {
        'content': messageContent,
        'senderId': widget.currentUserId,
        'recipientId': widget.contactId,
        'timestamp': DateTime.now().toString().substring(11,16),
      };
      _client.send(
        destination: '/app/chatt',
        body: json.encode(messageJson),
      );
      setState(() {
        messages.add(messageJson);
      });
    }
  }

  List<Map<String, dynamic>> messages = [];

  void _onConnectCallback(StompFrame connectFrame) {
    _client.subscribe(
      destination: '/user/${widget.currentUserId}/queue/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          Map<String, dynamic> receivedMessage = json.decode(frame.body!);
          if ((receivedMessage['senderId'] == widget.currentUserId &&
                  receivedMessage['recipientId'] == widget.contactId) ||
              (receivedMessage['senderId'] == widget.contactId &&
                  receivedMessage['recipientId'] == widget.currentUserId)) {
            setState(() {
              messages.add(receivedMessage);
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.45:8085/socket',
        onConnect: _onConnectCallback,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
   
   
    _client.activate();
   
    loadModel();
    controller = CameraController(cameraId, ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller.startImageStream((imageStream) {
          cameraImage = imageStream;
        });
      });

      // Start processing the output every 3 seconds
      timer =
          Timer.periodic(const Duration(seconds: 2), (Timer t) => runModel());
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  runModel() async {
    if (cameraImage != null) {
      var pred = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((e) => e.bytes).toList(),
          imageHeight: 48,
          imageWidth: 48,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 0,
          numResults: 1,
          threshold: .1,
          asynch: true);

      if (pred != null && pred.isNotEmpty) {
        String newOutput = pred.first['label'];
        processOutput(newOutput);
      }
    }
  }

  void processOutput(String detectedEmotion) {
    if (detectedEmotion != 'Neutral') {
      setState(() {
        output = detectedEmotion;
        if (aux != output) {
          sendEmotionMessage(output);
          aux = output;
        }
      });
    }
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true,
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );

    print('RESULTSSSSSSSS - $res');
  }

  void sendEmotionMessage(String variable) {
    _sendMessage(variable);
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        maintainBottomViewPadding: true,
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // alignment: AlignmentDirectional.bottomCenter,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.all(20).copyWith(bottom: 0, top: 0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: controller.buildPreview()),
              ),
            ),
            // const SizedBox(height: ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    shape: const StadiumBorder(),
                    avatar: const Icon(Icons.emoji_emotions_rounded),
                    label: Text(
                      // output is the variable that holds different emotions
                      output,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}