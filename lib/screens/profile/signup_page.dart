import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/core/components/input_text.dart';
import 'package:messagerie/core/components/my_button.dart';
import 'package:messagerie/screens/profile/signin_page.dart';

class SignupPage extends GetView<ProfileController> {
  SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/img.jpg"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), // Ajouter un padding horizontal
                child: Container(
                  padding: const EdgeInsets.all(20), // Ajouter un padding interne
                  decoration: BoxDecoration(
                  color: Color.fromARGB(255, 212, 83, 175).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40), // Coins arrondis
                  ),
                  constraints: BoxConstraints(maxWidth: 400), // Largeur maximale
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFF060B8A),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Create your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      GetBuilder<ProfileController>(
                        builder: (controller) {
                          return Form(
                            key: controller.keyForm,
                            child: Column(
                              children: <Widget>[
                                InputText(
                                  hintText: "username",
                                  icon: Icons.person,
                                  controller: controller.userNameController,
                                  validator: (p0) => controller.validatorUserName(p0),
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  hintText: "email",
                                  icon: Icons.email,
                                  controller: controller.emailController,
                                  validator: (value) => controller.validatorEmail(value),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    controller.selectDate(context);
                                  },
                                  child: AbsorbPointer(
                                    child: InputText(
                                      hintText: "Birthday",
                                      icon: Icons.calendar_today,
                                      controller: controller.birthdayController,
                                      validator: (p0) => controller.validatorBirthday(p0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  hintText: "password",
                                  controller: controller.passwordController,
                                  icon: Icons.password,
                                  obscureText: !controller.passwordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.passwordVisible ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => controller.showPassword(),
                                  ),
                                  validator: (p0) => controller.validatorPassword(p0),
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  hintText: "confirm password",
                                  controller: controller.confirmpasswordController,
                                  icon: Icons.password,
                                  obscureText: !controller.confirmPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.confirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => controller.showConfirmPassword(),
                                  ),
                                  validator: (p0) =>
                                      controller.validatorConfirmPassword(p0, controller.passwordController.text),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.camera_alt,
                          //     size: 24,
                          //     color: Colors.purple,
                          //   ),
                          //   onPressed: () async {
                          //     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          //     // if (pickedFile != null) {
                          //     //   controller.selectedPhoto = File(pickedFile.path);
                          //     // }
                          //   },
                          // ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                  color: Color(0xFF060B8A),

                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (controller.keyForm.currentState!.validate()) {
                                    controller.signUp();
                                  }
                                },
                                child: Text(
                                  "Signup",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20), // Espacement entre le bouton et le texte "Or"
                      // Text(
                      //   "Or",
                      //   textAlign: TextAlign.center,
                      // ),
                      // Container(
                      //   height: 45,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(25),
                      //     border: Border.all(
                      //       color: Colors.purple,
                      //     ),
                      //     // boxShadow: [
                      //     //   // BoxShadow(
                      //     //   //   color: Colors.white.withOpacity(0.5),
                      //     //   //   spreadRadius: 1,
                      //     //   //   blurRadius: 1,
                      //     //   //   offset: const Offset(0, 1),
                      //     //   // ),
                      //     // ],
                      //   ),
                        // child: TextButton(
                        //   onPressed: () {},
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       const SizedBox(width: 18),
                        //       const Text(
                        //         "Sign In with Google",
                        //         style: TextStyle(
                        //           fontSize: 16,
                        //           color: Colors.purple,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      //),
                      const SizedBox(height: 5), // Espacement entre le bouton "Sign In with Google" et le texte "Already have an account?"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Get.to(() => LoginPage());
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(   color: Color(0xFF060B8A),
                                ),    
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
