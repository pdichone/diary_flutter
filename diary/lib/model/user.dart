import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String? id;
  final String? uid;
  final String? displayName;
  final String? profession;
  final String? avatarUrl;

  MUser(
      {this.id,
      this.uid,
      this.displayName,
      this.profession,
      required this.avatarUrl});

  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    return MUser(
      id: data.id,
      uid: data.data()['uid'],
      displayName: data.data()['display_name'],
      profession: data.data()['profession'],
      avatarUrl: data.data()['avatar_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'profession': profession,
      'avatar_url': avatarUrl,
    };
  }
}
