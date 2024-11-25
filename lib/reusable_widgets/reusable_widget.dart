import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Image logoWidget(String imageName, double h, double w) {
  return Image.asset(imageName, fit: BoxFit.fitWidth, height: h, width: w);
}

TextField textFieldWidget(
    {required String text,
    required IconData icon,
    TextInputType? textInputType,
    int? maximumL,
    String? hint,
    required bool isPasswordType,
    required TextEditingController controller,
    Widget? suffixIcon,
    required void Function() onComplete,
    required Function(String) onChange}) {
  return TextField(
    onChanged: onChange,
    onEditingComplete: onComplete,
    keyboardAppearance: Brightness.dark,
    controller: controller,
    keyboardType: textInputType,
    obscureText: isPasswordType,
    maxLength: maximumL,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        suffixIcon: suffixIcon,
        labelText: text,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
              width: 0.2, style: BorderStyle.solid, color: Color(0xff1C4374)),
        )),
  );
}

CupertinoButton cupertinoButtonWidget(String text, Function onpressd) {
  return CupertinoButton(
    color: const Color(0xff1C4374),
    onPressed: () async {
      onpressd();
    },
    borderRadius: const BorderRadius.all(
      Radius.circular(15),
    ),
    pressedOpacity: 0.3,
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
    ),
  );
}

SizedBox elevatedButton(String text, Function onPressed,
    {BuildContext? context}) {
  return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1C4374),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          onPressed: () {
            onPressed();
          },
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
          )));
}

DropdownButtonFormField dropDown({
  required String text,
  required dynamic value,
  required IconData icon,
  Function(dynamic)? onSaved,
  required String? Function(dynamic)? validator, // Update here
  required Function(dynamic)? onChanged, // Update here
  required List<DropdownMenuItem<dynamic>>? items,
}) {
  return DropdownButtonFormField(
    decoration: InputDecoration(
      errorStyle: const TextStyle(color: Colors.red),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(15),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
      labelText: text,
      prefixIcon: Icon(icon),
    ),
    value: value,
    items: items,
    onSaved: onSaved,
    dropdownColor: const Color(0xFF97C5FF),
    validator: validator, // No need for null check
    onChanged: onChanged,
  );
}

TextFormField textFormField(String text, IconData icon, bool obscuredText,
    {required Function onChanged,
    required TextInputType keyboard,
    required TextEditingController controller,
    required String? Function(String?) validator,
    IconButton? suffixIcon,int? length,}) {
  return TextFormField(
    onChanged: onChanged(),
    obscureText: obscuredText,
    keyboardType: keyboard,
    maxLength: length,
    decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1C4374)),
            borderRadius: BorderRadius.circular(15)),
        labelText: text,
        suffixIcon: suffixIcon,
        prefixIcon: Icon(icon)),
    validator: validator,
    controller: controller,
  );
}

ElevatedButton elevatedButtons(
    {required Function onPressed, required Widget widget}) {
  return ElevatedButton(style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(const Color(0xff1C4374)),
    foregroundColor: WidgetStateProperty.all(const Color(0xff1C4374)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(width: 2, color:  Color(0xff1C4374)),
      ),
    ),
  ),onPressed: onPressed(), child: widget);
}
