import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;

  Scaffold authScreen() {
    return Scaffold(
      body: Text('Authorised User'),
    );
  }

  Scaffold unAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.teal),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Kenso',
              style: TextStyle(
                fontFamily: "Satisfy",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () => print('clicked'),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: Container(
                  alignment: Alignment.center,
                  // width: 200.0,
                  // height: 50.0,
                  child: ListTile(
                    leading: Icon(EvaIcons.google),
                    title: Text('Sign-In with Google',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/google.png'),
                    //   // fit: BoxFit.cover,
                    // ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? authScreen() : unAuthScreen();
  }
}
