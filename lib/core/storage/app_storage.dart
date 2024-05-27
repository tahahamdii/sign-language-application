
import 'package:messagerie/core/storage/secure_storage.dart';

class AppStorge{
  static const keyId = "id";
  static const keyUsername ="username";
  static const keyEmail ="email";
  static const keyResetCode="resetCode";
  static const keyPhoto = "photo";

   static saveId(String id) {
    SecureStorage.writeSecureData(key: keyId, value: id);
  }

  static String? readId() {
    return SecureStorage.readSecureData(keyId);
  }
  
   static saveUsername(String username) {
    SecureStorage.writeSecureData(key: keyUsername, value: username);
   }

static String? readUsername() {
    return SecureStorage.readSecureData(keyUsername);
  }

 static saveEmail(String email) {
    SecureStorage.writeSecureData(key: keyEmail, value: email);
  }

  static String? readEmail() {
    return SecureStorage.readSecureData(keyEmail);
  }
  static saveresetCode(String resetCode) {
    SecureStorage.writeSecureData(key: keyResetCode, value: resetCode);
  }

  static String? readresetCode() {
    return SecureStorage.readSecureData(keyResetCode);
  }
  
  static savePhoto(String photo) {
    SecureStorage.writeSecureData(key: keyPhoto, value: photo);
  }

  static String? readPhoto() {
    return SecureStorage.readSecureData(keyPhoto);
  }



}