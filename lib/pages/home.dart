import 'dart:io';

import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kenso/pages/activityFeed.dart';
import 'package:kenso/pages/profile.dart';
import 'package:kenso/pages/search.dart';
import 'package:kenso/pages/timeline.dart';
import 'package:kenso/pages/upload.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('user signed in');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold authScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CircleBottomNavigation(
          initialSelection: pageIndex,
          onTabChangedListener: onTap,
          barBackgroundColor: Colors.white,
          circleColor: Colors.purpleAccent,
          inactiveIconColor: Colors.purple,
          // activeColor: Theme.of(context).primaryColor,
          tabs: [
            TabData(icon: Icons.whatshot),
            TabData(icon: Icons.notifications_active),
            TabData(icon: Icons.photo_camera),
            TabData(icon: Icons.search),
            TabData(icon: Icons.account_circle),
          ]),
    );
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
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
              onTap: login,
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
