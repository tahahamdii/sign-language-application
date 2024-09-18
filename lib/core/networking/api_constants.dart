import 'package:messagerie/core/storage/app_storage.dart';

class ApiConstants {
  static const String baseUrl = "http://192.168.1.45:8085/";
  static const String signupUrl = "${baseUrl}api/users/register";
  static const String singinUrl = "${baseUrl}api/users/login";
  static const String forgotPasswordUrl = "${baseUrl}api/users/forgot-password";
  static const String resetUrl = "${baseUrl}api/users/reset-password";
  static final String changePasswordUrl ="${baseUrl}api/users/${AppStorage.readId()}/change-password";
  static const String newPasswordUrl = "${baseUrl}api/users/save-new-password";
  static const String userDataUrl = "${baseUrl}api/users/";
  static final String updateProfilUrl = "${baseUrl}api/users/${AppStorage.readId()}/edit-profile";
  static const String sendMessageUrl = "${baseUrl}chats";
  static const String createChanelUrl = "${baseUrl}chats/create";
  static const String getUserByEmailUrl = "${baseUrl}api/users/email";
  static final String getListRecipientUrl = "${baseUrl}chats/messages/by-sender/${AppStorage.readId()}";
  static final String getAllMsg="${baseUrl}chats/conversation/${AppStorage.readId()}/660407b84857cc4d9bbf6265";
  static String photoUrl ="${baseUrl}api/users/${AppStorage.readId()}/photo}";
  static  String createChannelUrl = '$baseUrl/chanels/create';
  static  String predictionUrl = 'http://192.168.1.45:5000/predict';
  static final String deleteUrl ="${baseUrl}api/users/${AppStorage.readId()}";





}
