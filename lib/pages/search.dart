import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kenso/models/AppUser.dart';
import 'package:kenso/pages/activityFeed.dart';
import 'package:kenso/pages/home.dart';
import 'package:kenso/reusable_widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.purple,
      title: TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search for a user...",
          hintStyle: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            size: 28.0,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: null,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Image.asset(
                'assets/images/search.png',
                height: orientation == Orientation.portrait ? 300.0 : 200.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: buildSearchField(),
      body: buildNoContent(),
    );
  }
}
