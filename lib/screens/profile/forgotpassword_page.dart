import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/screens/profile/code_page.dart';
import 'package:messagerie/core/components/input_text.dart';
import 'package:messagerie/core/components/my_button.dart';

class ForgotPasswordPage extends GetView<ProfileController> {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 16, 9, 74),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("asset/images/img.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
              color: Color.fromARGB(255, 212, 83, 175).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: Color(0xFF060B8A),

                      fontSize: 24.0, fontWeight: FontWeight.bold, ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Enter your email address below to reset your password.',

                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF060B8A),
                      fontSize: 16.0,),
                  ),
                  SizedBox(height: 20.0),
                  InputText(
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    controller: controller.emailController,
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: 200.0, // Définir une largeur fixe pour le bouton
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.emailController.text.isNotEmpty) {
                          controller.resetPassword();
                        }
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:  Color(0xFF060B8A),

                        // Couleur du texte
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0), // Bord arrondi du bouton
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
