import 'package:messagerie/core/storage/app_storage.dart';

class ApiConstants {
  static const String baseUrl = "http://localhost:8080/";
  static const String signupUrl = "${baseUrl}api/users/register";
  static const String singinUrl = "${baseUrl}api/users/login";
  static const String forgotPasswordUrl = "${baseUrl}api/users/forgot-password";
  static const String resetUrl = "${baseUrl}api/users/reset-password";
  static final String changePasswordUrl ="${baseUrl}api/users/${AppStorge.readId()}/change-password";
  static const String newPasswordUrl = "${baseUrl}api/users/save-new-password";
  static const String userDataUrl = "${baseUrl}api/users/";
  static final String updateProfilUrl = "${baseUrl}api/users/${AppStorge.readId()}/edit-profile";
  static const String sendMessageUrl = "${baseUrl}chats";
  static const String createChanelUrl = "${baseUrl}chats/create";
  static const String getUserByEmailUrl = "${baseUrl}api/users/email";
  static final String getListRecipientUrl = "${baseUrl}chats/messages/by-sender/${AppStorge.readId()}";
  static final String getAllMsg="${baseUrl}chats/conversation/${AppStorge.readId()}/660407b84857cc4d9bbf6265";
  static String photoUrl ="${baseUrl}api/users/${AppStorge.readId()}/photo}";
  static  String createChannelUrl = '$baseUrl/chanels/create';





}
