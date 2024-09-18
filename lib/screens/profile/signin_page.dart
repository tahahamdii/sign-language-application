import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/core/components/input_text.dart';
import 'package:messagerie/core/components/my_button.dart';
import 'package:messagerie/screens/chat/chat_page.dart';
import 'package:messagerie/screens/chat/conversationlist_page.dart';
import 'package:messagerie/screens/profile/signup_page.dart';
import 'package:messagerie/screens/profile/forgotpassword_page.dart';
import 'package:messagerie/screens/profile/update_profil_page.dart';

class LoginPage extends GetView<ProfileController> {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: Color(0xFF060B8A),
          //     // image: DecorationImage(
          //     //   image: AssetImage("assets/images/img.jpg"),
          //     //   fit: BoxFit.cover,
          //     // ),
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 212, 83, 175).withOpacity(0.3),

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(40), // Coin en bas à gauche
                bottomRight: Radius.circular(40), // Coin en bas à droite
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _header(context),
                  _inputField(context),
                  _signup(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(context) {
    return Column(
      children: [
        Text(
          "Login",
          style: TextStyle(
            color: Color(0xFF060B8A),
            fontSize: 40, fontWeight: FontWeight.bold),
          
        ),
        Text(
          "Enter your credentials to login",
          style: TextStyle(
            color: Color(0xFF060B8A),)
          ),
      ],
    );
  }

  Widget _inputField(context) {
    return Form(
      key: controller.keyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputText(
            hintText: "username",
            icon: Icons.person,
            controller: controller.userNameController,
            validator: (p0) => controller.validatorUserName(p0),
          ),
          SizedBox(height: 25),
          GetBuilder<ProfileController>(
            builder: (controller) {
              return InputText(
                hintText: "password",
                controller: controller.passwordController,
                icon: Icons.password,
                obscureText: !controller.passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => controller.showPassword(),
                ),
                validator: (p0) => controller.validatorPassword(p0),
              );
            },
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(color: Color(0xFF060B8A)),
              ),
            ),
          ),
          SizedBox(height: 10),
          MyButton(
            onTap: () {
              print("ontap");
              if (controller.keyForm.currentState!.validate()) {
                controller.signIn();}
              // } Get.to(ScreenChat(
              //   contactId: "6675030dccc5259c51c4890b",
              //   currentUserId: "6675030dccc5259c51c4890b",
              // ));
            },
            text: "Login",
            backgroundColor: Colors.blue,
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? "),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(color: Color(0xFF060B8A)),
          ),
        )
      ],
    );
  }
}
