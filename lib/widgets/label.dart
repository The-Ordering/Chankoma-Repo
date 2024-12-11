import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Label {
  static Text label(String txt,
      {required BuildContext context, Color? color, bool fade = false}) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: kDefaultFontSize * 1.5,
        fontWeight: FontWeight.w500,
        color: fade
            ? Theme.of(context).textTheme.titleSmall?.color?.withOpacity(0.5)
            : (color),
      ),
    );
  }
}

class AppInput {
  static Container textField( { required BuildContext context ,  required  TextEditingController controller , String? hint , bool? isHide} ) {
    return Container(
      padding: const  EdgeInsets.symmetric(horizontal: kDefaultFontSize),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(50)
      ),
      child: TextField(
        obscureText: isHide ?? false,
        controller: controller,
        decoration: InputDecoration(
          label: hint != null ? Text(hint) : null,
          border:const OutlineInputBorder(
              borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }
}
