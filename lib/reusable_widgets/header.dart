import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "Kenso" : titleText,
      style: TextStyle(
          color: Colors.white,
          fontFamily: isAppTitle ? "Satisfy" : "Alegreya",
          fontSize: isAppTitle ? 50.0 : 22.0,
          fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.purple,
  );
}
