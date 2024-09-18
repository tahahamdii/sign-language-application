import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/core/networking/api_constants.dart';
import 'package:messagerie/core/networking/dio_singleton.dart';
import 'package:messagerie/core/storage/app_storage.dart';
import 'package:messagerie/models/all_message_model.dart';
import 'package:messagerie/models/list_message_by_sender.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  TextEditingController setMessage = TextEditingController();
  TextEditingController setSenderId = TextEditingController();
  TextEditingController setRecipientId = TextEditingController();

  DioSingleton dioSingleton = DioSingleton();

  bool showEmoji = false;
  final files = ValueNotifier<List<File>>([]);
  final SpeechToText speech = SpeechToText();

  bool isMe = false;
  List<Message> messages = [
    Message(
      content: "Hello! ",
      sender: "Manel",
      time: "10:00 AM",
      isMe: true,
    ),
    Message(
      content: "Hi there!",
      sender: "John",
      time: "10:01 AM",
      isMe: false,
    ),
    // Add other static messages here
  ];
  ProfileController profileController = Get.put(ProfileController());
  Future<void> sendMessage(String text, String recipientId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.45:8085/chats'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'message': text,
          'recipientId': recipientId,
          'senderId': AppStorage.readId().toString(), // Assurez-vous que AppStorage.readId() renvoie l'ID de l'utilisateur actuel
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Traitez la réponse ici si nécessaire
        print('Message sent successfully: $responseData');
      } else {
        print('Failed to send message: ${response.statusCode}');
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }



  ListMessageBySender? listMessageBySender;
  List<String>? listRecipient;
  List<String>? listRecipientName;

  void getMessageBySender() async {
    try {
      final response =
          await dioSingleton.dio.get(ApiConstants.getListRecipientUrl);
      if (response.statusCode == 200) {
        listMessageBySender = ListMessageBySender.fromJson(response.data);
        print('username=======>${listMessageBySender!.data?.length}');

        listRecipient = listMessageBySender?.getListRecipient();
        print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        // for (int i = 0; i <= listRecipient!.length; i++) {
        //   print('lisr res=========================>${listRecipient![i]}');
        //   profileController.getUser(listRecipient![i]);
        //   print(
        //       '++++++++++++++++++++++++++++++++++++++++++++for+++++++++++++++');
        // //  listRecipientName!.add(profileController.dataUserModel!.username!);
        // }
        print('list ==================$listRecipientName');
      } else {
        print('error=================');
      }
    } catch (e) {
      print('e===========================>$e');
    }
  }
  // Autres méthodes et propriétés du contrôleur


 Dio dio=Dio();
AllMessagesModel? allMessagesModel;
    Future<AllMessagesModel?> getAllMsg()async{
  print('=====================================get all msg');
try{

var response=await dio.get("${ApiConstants.getAllMsg}");
if(response.statusCode==200 && response.data != null){
  allMessagesModel=AllMessagesModel.fromJson(response.data);
  print('data=========================$allMessagesModel');
  print('bollwsxdcfv========================${ allMessagesModel!.data}');
  return allMessagesModel!;
}else{
  print('error=========================');
  update();
return null;
}


}catch(e){
  print('error=========================$e');
  return null;
}
}
@override
  void onInit() {
   getAllMsg();
    super.onInit();
  }
}

class Message {
  final String content;
  final String sender;
  final String time;
  final bool isMe;

  Message({
    required this.content,
    required this.sender,
    required this.time,
    required this.isMe,
  });
}
