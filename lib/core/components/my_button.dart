import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({ 
  super.key,
  required this.onTap,
  required this.text, required MaterialColor backgroundColor, required int width,
}) ;


  @override
  Widget build(BuildContext context){
    return  ElevatedButton(
            onPressed: onTap,
            
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.purple,
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.white,),
              
              
            ),
          );
  }
}