import 'package:flutter/material.dart';

List<Map> users = [];

Widget defaultTextField({
  required TextEditingController? controller,
  required TextInputType? type,
  Function()? onTap,
  Function(String)? onChange,
  required String? Function(String?)? onValidate,
  String Function(String?)? onSubmit,
  bool isPassword = false,
  required String? label,
  required IconData? prefix,
  IconData? suffix,
  Function()? suffixPress,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onChanged: onChange,
    onTap: onTap,
    onFieldSubmitted: onSubmit,
    validator: onValidate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix, color: Colors.green),
      suffixIcon: suffix != null
          ? IconButton(onPressed: suffixPress, icon: Icon(suffix))
          : null,
      border: const OutlineInputBorder(),
    ),
  );
}

Widget defaultButton({
  double width = double.infinity,
  Color? background,
  Color? textColor,
  bool isUpper = true,
  required VoidCallback onTap,
  required String text,
}) =>
    Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      width: width,
      height: 55,
      // color: background,
      child: MaterialButton(
        onPressed: onTap,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
