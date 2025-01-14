import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // snackbar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // push
  void push(Widget widget) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => widget));
  }
}
