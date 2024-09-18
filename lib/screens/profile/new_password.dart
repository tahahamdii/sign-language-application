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
        title: Text('Create New Password', 
        style: TextStyle(color: Colors.white),),
        
       backgroundColor: Color.fromARGB(255, 16, 9, 74),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/img.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
              color: Color.fromARGB(255, 212, 83, 175).withOpacity(0.3),
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

                      style: TextStyle(
                      color: Color(0xFF060B8A),

                        fontSize: 24.0, fontWeight: FontWeight.bold),
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
                            AppStorage.readResetCode().toString(),
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
