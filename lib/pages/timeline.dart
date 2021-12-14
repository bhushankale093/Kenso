import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kenso/models/AppUser.dart';
import 'package:kenso/pages/home.dart';
import 'package:kenso/reusable_widgets/header.dart';
import 'package:kenso/reusable_widgets/post.dart';
import 'package:kenso/reusable_widgets/progress.dart';

class Timeline extends StatefulWidget {
  final AppUser currentUser;
  Timeline({this.currentUser});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    List<String> followingList = await getFollowing();
    for (String uid in followingList) {
      QuerySnapshot snapshot = await postsRef
          .doc(uid)
          .collection('userPosts')
          .orderBy('timestamp', descending: true)
          .get();
      List<Post> tempPosts = [];
      snapshot.docs.forEach((doc) {
        Post post = Post.fromDocument(doc);
        tempPosts.add(post);
      });
      for (Post post in tempPosts) {
        setState(() {
          this.posts.add(post);
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<List<String>> getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(currentUser.id)
        .collection('userFollowing')
        .get();
    List<String> followingList = [currentUser.id];
    snapshot.docs.forEach((element) {
      setState(() {
        followingList.add(element.id);
      });
    });
    print(followingList);
    return followingList;
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Text('None');
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: header(context, isAppTitle: true),
      body: isLoading ? circularProgress() : buildTimeline(),
    );
  }
}
