import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  AppUser({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  });

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      displayName: doc['displayName'],
      bio: doc['bio'],
    );
  }
}
