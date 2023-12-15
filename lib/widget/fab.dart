import 'package:flutter/material.dart';

fab(String childText,Function onPressed,IconData icon) {
  return FloatingActionButton.extended(
    elevation: 0,
    backgroundColor: Colors.white.withOpacity(.5),
    onPressed: () {
      onPressed();
    },
    label: Text(
      childText,
    ),
    icon: Icon(
      icon,
    )
  );
}