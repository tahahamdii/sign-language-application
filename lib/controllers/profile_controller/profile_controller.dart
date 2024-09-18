import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messagerie/core/helperes/app_validators.dart';
import 'package:messagerie/core/networking/api_constants.dart';
import 'package:messagerie/core/networking/dio_singleton.dart';
import 'package:messagerie/core/storage/app_storage.dart';
import 'package:messagerie/models/data_user_model.dart';
import 'package:messagerie/models/get_user_model.dart';
import 'package:messagerie/models/user_model.dart';
import 'package:messagerie/screens/chat/conversationlist_page.dart';
import 'package:messagerie/screens/profile/code_page.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:messagerie/screens/profile/signin_page.dart';

class ProfileController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController resetCodeController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  RxString imageUrl = RxString('');

  final keyForm = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool darkModeEnabled = false;

  DioSingleton dioSingleton = DioSingleton();

  RxString currentUserId = "".obs;

  get contactController => null;

  @override
  void onInit() {
    super.onInit();
    getUserImage();
  }

  void setCurrentUserId(String userId) {
    currentUserId.value = userId;
  }

  void toggleDarkMode() {
    darkModeEnabled = !darkModeEnabled;
    update();
  }

  bool showPassword() {
    passwordVisible = !passwordVisible;
    update();
    return passwordVisible;
  }

  bool showConfirmPassword() {
    confirmPasswordVisible = !confirmPasswordVisible;
    update();
    return confirmPasswordVisible;
  }

  String? validatorUserName(String? value) {
    if (value!.isEmpty) {
      return "Enter your username";
    }
    return null;
  }

  String? validatorPassword(String? value) {
    if (value!.isEmpty) {
      return "Enter your password";
    } else if (AppValidators.isPasswordValid(value)) {
      return "Enter a valid password";
    }
    return null;
  }

  String? validatorEmail(String? value) {
    if (value!.isEmpty) {
      return "Enter your email";
    } else if (!AppValidators.isEmailValid(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatorBirthday(String? value) {
    if (value!.isEmpty) {
      return "Enter your birthday";
    }
    return null;
  }

  String? validatorConfirmPassword(String? value, String password) {
    if (value!.isEmpty) {
      return "Confirm your password";
    } else if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  String? validatorOldPassword(String? value) {
    if (value!.isEmpty) {
      return "Enter your current password";
    } else if (value != oldPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  String? validatorNewPassword(String? value) {
    if (value!.isEmpty) {
      return "Enter your new password";
    }
    return null;
  }

  String? validatorConfirmNewPassword(String? value) {
    if (value!.isEmpty) {
      return "Confirm your password";
    } else if (value != newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color.fromARGB(255, 222, 53, 205), // Couleur principale du calendrier
            hintColor: Colors.blueAccent, // Couleur d'accentuation du calendrier
            colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 2, 27, 78)), // Couleur de la barre supérieure du calendrier
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Couleur du texte des boutons
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      birthdayController.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  UserLoginModel? userModel;

  void signIn() async {
    Map<String, dynamic> data = {
      "username": userNameController.text,
      "password": passwordController.text,
    };
    try {
      final response =
          await dioSingleton.dio.post(ApiConstants.singinUrl, data: data);
      userModel = UserLoginModel.fromJson(response.data);
      if (userModel != null) {
        AppStorage.saveId("${userModel!.userDetails!.id}");
        setCurrentUserId(userModel!.userDetails!.id.toString());
        print(currentUserId.value);
        AppStorage.saveUsername("${userModel!.userDetails!.username}");
        AppStorage.saveEmail("${userModel!.userDetails!.email}");
        print(AppStorage.readId());
        print("username=================>${userModel!.userDetails!.id}");
        userNameController.text = userModel!.userDetails!.username!;
        emailController.text = userModel!.userDetails!.email!;
        birthdayController.text = userModel!.userDetails!.birthday!;
        getUser(AppStorage.readId().toString());
        Get.to(ConversationlistPage(id: currentUserId.value));
      } else {
      }
    } catch (error) {
      print("error=====> $error");
    }
  }

  DataUserModel? dataUserModel;

  void getUser(String id) async {
    try {
      final response =
          await dioSingleton.dio.get("${ApiConstants.userDataUrl}$id");
      if (response.statusCode == 200) {
        dataUserModel = DataUserModel.fromJson(response.data);
        print('username=======>${dataUserModel!.username}');
      } else {
        print('error=================');
      }
    } catch (e) {
      print('errorget  user ===========================>$e');
    }
  }

  final TextEditingController messageController = TextEditingController();
  GetUserModel? getUserModel;
  void getUserByEmail() async {
    Map<String, dynamic> data = {"email": emailController.text.trim()};
    try {
      final response = await dioSingleton.dio
          .get(ApiConstants.getUserByEmailUrl, queryParameters: data);
      if (response.statusCode == 200) {
        getUserModel = GetUserModel.fromJson(response.data);
        print('username=======>${getUserModel!.email}');
      } else {
        print('error=================');
      }
    } catch (e) {
      print('e===========================>$e');
    }
  }

  void updateProfil() async {
    Map<String, dynamic> data = {
      "username": userNameController.text,
      "email": emailController.text,
      "birthday": birthdayController.text,
    };

    try {
      final response =
          await dioSingleton.dio.put(ApiConstants.updateProfilUrl, data: data);

      if (response.statusCode == 200) {
        Get.snackbar("****", "update profil succes");
      } else {
        Get.snackbar("Erreur", "profil cannot updated");
      }
    } catch (erreur) {
      Get.snackbar("Erreur", "profil cannot updated");

      print("$erreur");
    }
  }

  void signUp() async {
    Map<String, dynamic> data = {
      "role": "user",
      "username": userNameController.text,
      "email": emailController.text,
      "birthday": birthdayController.text,
      "password": passwordController.text,
      "confirmPassword": confirmpasswordController.text,
    };
    try {
      final response =
          await dioSingleton.dio.post(ApiConstants.signupUrl, data: data);
      Get.to(LoginPage());
    } catch (error) {
      print("error=====> $error");
    }
  }

  void changePassword() async {
    Map<String, dynamic> data = {
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text,
      "confirmPassword": confirmNewPasswordController.text,
    };

    try {
      await dioSingleton.dio.post(ApiConstants.changePasswordUrl, data: data);
      Get.to(LoginPage());
      print("Password changed successfully");
    } catch (e) {
      print("error========> $e");
    }
  }

  void resetPassword() async {
    Map<String, dynamic> data = {
      "email": emailController.text,
    };
    try {
      await dioSingleton.dio
          .post(ApiConstants.forgotPasswordUrl, data: data)
          .then((value) {
        print('Password reset instructions sent to your email.');
        Get.to(EnterCodePage()); // Naviguer vers la page de saisie du code
      }).onError((error, stackTrace) {
        print("error=====> $error");
      });
    } catch (e) {
      print("error========> $e");
    }
  }

  Future<void> saveNewPassword(
      String resetCode, String newPassword, String confirmNewPassword) async {
    print("resetcode**************$resetCode");

    // Créez les données à envoyer à l'API
    Map<String, String> data = {
      "newPassword": newPassword,
      "confirmNewPassword": confirmNewPassword,
      "resetCode": resetCode,
    };

    try {
      // Effectuez la demande POST vers l'API
      final response =
          await dioSingleton.dio.post(ApiConstants.newPasswordUrl, data: data);

      // Vérifiez si la réponse est réussie
      if (response.statusCode == 200) {
        // Si le mot de passe est enregistré avec succès, naviguez vers la page de connexion
        print("response*********************${response.data}");
        Get.offAll(LoginPage());
      } else {
        // Afficher un message d'erreur si la demande échoue
        Get.snackbar(
            "Erreur", "Échec de l'enregistrement du nouveau mot de passe");
      }
    } catch (e) {
      // Gérer les erreurs
      print("Error saving new password: $e");
      Get.snackbar("Erreur",
          "Une erreur s'est produite lors de l'enregistrement du nouveau mot de passe");
    }
  }

  void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Form(
            key: keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                  ),
                  obscureText: true,
                  validator: validatorOldPassword,
                ),
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                  ),
                  obscureText: true,
                  validator: validatorNewPassword,
                ),
                TextFormField(
                  controller: confirmNewPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                  ),
                  obscureText: true,
                  validator: validatorConfirmNewPassword,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (keyForm.currentState!.validate()) {
                  changePassword();
                  Get.back();
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void signOut() {}

  Future<void> getUserImage() async {
    String currentUserId = AppStorage.readId().toString();
    String apiUrl = 'http://192.168.1.45:8085/api/users/image/$currentUserId';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        imageUrl.value = response.body;
        print(imageUrl);
      } else {
        print('Failed to fetch image URL');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> uploadImage(BuildContext context, PickedFile pickedFile) async {
    String currentUserId = AppStorage.readId().toString();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.45:8085/cloudinary/upload/$currentUserId'),
    );

    // Read the file as bytes
    List<int> bytes = await pickedFile.readAsBytes();

    // Create a MultipartFile from bytes
    var multipartFile = http.MultipartFile.fromBytes(
      'multipartFile',
      bytes,
      filename: pickedFile.path.split('/').last,
    );

    // Add the MultipartFile to the request
    request.files.add(multipartFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Image uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully!'),
          ),
        );
        // Fetch the updated image URL after uploading
        getUserImage();
      } else {
        // Error uploading image
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image!'),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    String userId = currentUserId.value;
    String deleteUrl = "${ApiConstants.deleteUrl}/$userId";

    try {
      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode == 204) {
        // Account successfully deleted
        AppStorage.clear(); // Clear stored user data
        Get.offAll(LoginPage()); // Navigate to sign-in page
        Get.snackbar("Success", "Account deleted successfully");
      } else {
        // Handle error
        Get.snackbar("Error", "Failed to delete account");
      }
    } catch (e) {
      print("Error deleting account: $e");
      Get.snackbar("Error", "An error occurred while deleting the account");
    }
  }
}
