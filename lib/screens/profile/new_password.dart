import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/core/components/input_text.dart';
import 'package:messagerie/core/components/my_button.dart';
import 'package:messagerie/core/storage/app_storage.dart';

class NewPasswordPage extends GetView<ProfileController> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Password'),
        
        backgroundColor: const Color.fromARGB(255, 232, 228, 232),
        
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/img.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                
              ),
               constraints: BoxConstraints(maxWidth: 360, maxHeight: 500), // Largeur maximale

              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create a new password',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    InputText(
                      hintText: 'New Password',
                      controller: newPasswordController,
                      icon: Icons.lock,
                      validator: (p0) => controller.validatorPassword(p0),
                    ),
                    SizedBox(height: 20.0),
                    InputText(
                      hintText: 'Confirm New Password',
                      controller: confirmNewPasswordController,
                      icon: Icons.lock,
                      validator: (p0) => controller.validatorConfirmPassword(p0, newPasswordController.text),
                    ),
                    SizedBox(height: 20.0),
                    MyButton(
                      onTap: () {
                        if (keyForm.currentState!.validate()) {
                          // Call the method to save the new password
                          controller.saveNewPassword(
                            AppStorge.readresetCode().toString(),
                            newPasswordController.text,
                            confirmNewPasswordController.text,
                          );
                        }
                      },
                      text: 'Save Password',
                      backgroundColor: Colors.purple,
                      width: 20, // Utiliser 80% de la largeur de l'écran
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
