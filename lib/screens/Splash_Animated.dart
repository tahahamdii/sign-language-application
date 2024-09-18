import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:messagerie/screens/profile/signin_page.dart'; // Assurez-vous que cette importation est correcte

class SplashAnimated extends StatelessWidget {
  const SplashAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 200,
      backgroundColor: Colors.white,
      pageTransitionType: PageTransitionType.topToBottom,
      splashTransition: SplashTransition.rotationTransition,
      splash: const CircleAvatar(
        radius: 90,
        backgroundImage: AssetImage("assets/images/Kifna.png"),
      ),
      nextScreen:  LoginPage(), // Assurez-vous que `SignInPage` est correctement importée et définie

      duration: 2000, // 

      animationDuration: const Duration(seconds: 2),
    );
  }
}
