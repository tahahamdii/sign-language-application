import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final IconData? icon;
  final bool? obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final Icon? iconData;
  final IconButton? suffixIcon; // Ajout du paramètre suffixIcon

  const InputText({
    Key? key,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.iconData,
    this.suffixIcon, // Déclaration du paramètre suffixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        
        fillColor: Color.fromARGB(255, 241, 232, 243),
        filled: true,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon, // Utilisation du paramètre suffixIcon
      ),
      obscureText: obscureText!,
    );
  }
}
