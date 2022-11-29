import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kLightColor = Color.fromARGB(255, 161, 83, 234);
const kPrimaryLightColor = Color(0xFFF1E6FF);

class Constants {
  static String uid = "";
  static String email = "";
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
