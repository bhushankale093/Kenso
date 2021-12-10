import 'package:flutter/material.dart';
import 'package:kenso/models/AppUser.dart';
import 'package:kenso/pages/edit_profile.dart';
import 'package:kenso/pages/home.dart';
import 'package:kenso/reusable_widgets/header.dart';
import 'package:kenso/reusable_widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              // color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUserId)));
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  profileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return GestureDetector(
        onTap: editProfile,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.edit),
          ),
        ),
      );
    }
  }

  profileHeader() {
    return FutureBuilder(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          AppUser user = AppUser.fromDocument(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: user?.photoUrl != null
                              ? NetworkImage(user?.photoUrl)
                              : AssetImage('assets/images/defaultUser.png'),
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 12.0),
                          child: Center(
                            child: Text(
                              user?.username ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 4.0),
                          child: Center(
                            child: Text(
                              user?.displayName ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                buildCountColumn("posts", 0),
                                buildCountColumn("followers", 0),
                                buildCountColumn("following", 0),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text(user?.bio ?? ''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: profileButton(),
                  top: 10.0,
                  right: 10.0,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[
          profileHeader(),
        ],
      ),
    );
  }
}
