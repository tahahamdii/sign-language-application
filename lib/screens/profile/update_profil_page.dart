import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/core/components/input_text.dart';
import 'package:messagerie/core/components/my_button.dart';
import 'package:messagerie/core/storage/app_storage.dart';
import 'package:messagerie/screens/chat/chat_page.dart';
import 'package:messagerie/screens/chat/conversationlist_page.dart';
import 'package:messagerie/screens/profile/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UpdateProfilPage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final picker = ImagePicker();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 50),
              Text(
                "Personal Details",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          image: controller.imageUrl.value != null
                              ? DecorationImage(
                                  image:
                                      NetworkImage(controller.imageUrl.value!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: CircleAvatar(
                          radius: 55,
                           backgroundImage: controller.imageUrl.value != null
                               ? NetworkImage(controller.imageUrl.value!)
                             : AssetImage('avatarr.png') as ImageProvider,
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (pickedFile != null) {
                            await _uploadImage(
                                context, PickedFile(pickedFile.path));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Image picking canceled!'),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF060B8A),

                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _keyForm,
                child: Column(
                  children: <Widget>[
                    InputText(
                      hintText: "Username",
                      icon: Icons.person,
                      controller: controller.userNameController,
                      validator: (value) => controller.validatorUserName(value),
                    ),
                    SizedBox(height: 20),
                    InputText(
                      hintText: "Email",
                      icon: Icons.email,
                      controller: controller.emailController,
                      validator: (value) => controller.validatorEmail(value),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        controller.selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: InputText(
                          hintText: "Birthday",
                          icon: Icons.calendar_today,
                          controller: controller.birthdayController,
                          validator: (value) =>
                              controller.validatorBirthday(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              MyButton(
                onTap: () {
                  if (_keyForm.currentState!.validate()) {
                    controller.updateProfil();
                  }
                },
                text: "Save",
                backgroundColor: Colors.purple,
                width: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.grey.shade600,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.to(ConversationlistPage(
                id: controller.currentUserId.value,
              ));
              break;
            case 1:
              break;
            case 2:
              Get.to(UpdateProfilPage());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Future<void> _uploadImage(BuildContext context, PickedFile pickedFile) async {
    String currentUserId = AppStorage.readId().toString();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.45:8085/cloudinary/upload/$currentUserId'),
    );

    List<int> bytes = await pickedFile.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'multipartFile',
      bytes,
      filename: pickedFile.path.split('/').last,
    );

    request.files.add(multipartFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully!'),
          ),
        );
      } else {
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
}
