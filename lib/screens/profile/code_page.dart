import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messagerie/controllers/profile_controller/profile_controller.dart';
import 'package:messagerie/core/storage/app_storage.dart';
import 'package:messagerie/screens/profile/new_password.dart'; 
import 'package:messagerie/core/components/my_button.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({Key? key}) : super(key: key);

  @override
  _EnterCodePageState createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final ProfileController profileController = ProfileController();
  final keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Verification Code'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/img.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please enter the verification code sent to your email',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter code";
                              }
                              return null;
                            },
                            controller: _controller1,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              filled: true,
                              fillColor: Colors.purple.withOpacity(0.1),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter code";
                              }
                              return null;
                            },
                            controller: _controller2,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              filled: true,
                              fillColor: Colors.purple.withOpacity(0.1),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter code";
                              }
                              return null;
                            },
                            controller: _controller3,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              filled: true,
                              fillColor: Colors.purple.withOpacity(0.1),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter code";
                              }
                              return null;
                            },
                            controller: _controller4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              filled: true,
                              fillColor: Colors.purple.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    MyButton(
                      onTap: () {
                        if (keyForm.currentState!.validate()) {
                          profileController.resetCodeController.text = "${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}";
                          print("resetcode=${profileController.resetCodeController.text}");

                          AppStorge.saveresetCode("${profileController.resetCodeController.text}");

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewPasswordPage()),
                          );
                        }
                      },
                      text: 'Verify',
                      backgroundColor: Colors.purple,
                      width: 20,
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
