import 'package:messagerie/core/storage/secure_storage.dart';

class AppStorage {
  static const keyId = "id";
  static const keyUsername = "username";
  static const keyEmail = "email";
  static const keyResetCode = "resetCode";
  static const keyPhoto = "photo";

  static void clear() {
    SecureStorage.deleteAll(); // Clear all stored data from secure storage
  }

  static void saveId(String id) {
    SecureStorage.writeSecureData(key: keyId, value: id);
  }

  static String? readId() {
    return SecureStorage.readSecureData(keyId);
  }

  static void saveUsername(String username) {
    SecureStorage.writeSecureData(key: keyUsername, value: username);
  }

  static String? readUsername() {
    return SecureStorage.readSecureData(keyUsername);
  }

  static void saveEmail(String email) {
    SecureStorage.writeSecureData(key: keyEmail, value: email);
  }

  static String? readEmail() {
    return SecureStorage.readSecureData(keyEmail);
  }

  static void saveResetCode(String resetCode) {
    SecureStorage.writeSecureData(key: keyResetCode, value: resetCode);
  }

  static String? readResetCode() {
    return SecureStorage.readSecureData(keyResetCode);
  }

  static void savePhoto(String photo) {
    SecureStorage.writeSecureData(key: keyPhoto, value: photo);
  }

  static String? readPhoto() {
    return SecureStorage.readSecureData(keyPhoto);
  }
}
