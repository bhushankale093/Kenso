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
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("displayName", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.purple,
      title: TextFormField(
        controller: searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search for a user...",
          hintStyle: Theme.of(context).textTheme.caption.copyWith(
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
            onPressed: clearSearch,
            color: Colors.white,
          ),
        ),
        onFieldSubmitted: handleSearch,
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

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          AppUser user = AppUser.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final AppUser user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 2.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => showProfile(context, profileId: user.id),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: user?.photoUrl != null
                      ? NetworkImage(user.photoUrl)
                      : AssetImage('assets/images/defaultUser.png'),
                ),
                title: Text(
                  user?.displayName ?? '',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user?.username ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
