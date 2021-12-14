import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kenso/models/AppUser.dart';
import 'package:kenso/pages/activityFeed.dart';
import 'package:kenso/pages/add_account.dart';
import 'package:kenso/pages/profile.dart';
import 'package:kenso/pages/search.dart';
import 'package:kenso/pages/timeline.dart';
import 'package:kenso/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final DateTime timestamp = DateTime.now();
AppUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
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
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1) check if user is already present in database
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if (!doc.exists) {
      // 2) if not , lead them to add account
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddAccount()));

      // 3) take username and add user info in database
      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });
      // make new user their own follower to include their posts in their timeline
      await followersRef
          .doc(user.id)
          .collection('userFollowers')
          .doc(user.id)
          .set({});

      doc = await usersRef.doc(user.id).get();
    }
    currentUser = AppUser.fromDocument(doc);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
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

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(currentUser: currentUser),
          ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CircleBottomNavigation(
          circleSize: 40.0,
          arcHeight: 30,
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

  Scaffold buildUnAuthScreen() {
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
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
