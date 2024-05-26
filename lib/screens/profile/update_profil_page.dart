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

class UpdateProfilPage extends GetView<ProfileController> {
  UpdateProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;

    controller.getUser(AppStorge.readId().toString());
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
                "Personnal Details",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage('asset/images/mm.jpg'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.camera);

                          if (pickedFile != null) {
                            // L'utilisateur a sélectionné une image, vous pouvez la traiter ici
                            // Par exemple, vous pouvez mettre à jour l'image de profil avec la nouvelle image
                            // L'image est disponible dans pickedFile.path
                          } else {
                            // L'utilisateur a annulé la sélection de l'image
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple,
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
                key: controller.keyForm,
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
                  if (controller.keyForm.currentState!.validate()) {
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.to(ConversationlistPage());
              break;
            case 1:
              Get.to(ScreenChat(currentUserId: "specificChatId", contactId:  "currentUserId"));
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
}
