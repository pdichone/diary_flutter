// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiaryService {
  // for this to work must have indexs setup in the cloud firestore:
  // https://console.firebase.google.com/u/0/project/diary-flutter-test/firestore/indexes?create_composite=ClJwcm9qZWN0cy9kaWFyeS1mbHV0dGVyLXRlc3QvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2RpYXJpZXMvaW5kZXhlcy9fEAEaCgoGYXV0aG9yEAEaDgoKZW50cnlfdGltZRACGgwKCF9fbmFtZV9fEAI
  getLatestDiaries(String userId) {
    return FirebaseFirestore.instance
        .collection('diaries')
        //.where('author', isEqualTo: author)
        .where('user_id', isEqualTo: userId)
        .orderBy('entry_time', descending: true)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        //print(diary.data().entries.first);
        return Diary.fromDocument(diary);
      });
    });

    // .snapshots(); // or getDocuments if we don't want to use streams
  }

  getEarliestDiaries(String userId) {
    return FirebaseFirestore.instance
        .collection('diaries')
        //.where('author', isEqualTo: author)
        .where('user_id', isEqualTo: userId)
        .orderBy('entry_time', descending: false)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        //print(diary.data().entries.first);
        return Diary.fromDocument(diary);
      });
    });
  }

  getSameDateDiaries(DateTime first, DateTime second, String userId) {
    return FirebaseFirestore.instance
        .collection('diaries')
        .where('entry_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
        .where('entry_time',
            isLessThan:
                Timestamp.fromDate(second.add(Duration(days: 1))).toDate())
        .where('user_id', isEqualTo: userId)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }

  getCurrentSignedUser() {
    final userStream = FirebaseAuth.instance.authStateChanges();

    final _user = userStream.map((event) {
      return event;
    });
    return _user;
  }

  Future<void> createUser(String displayName, BuildContext context) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    MUser user = MUser(
        avatarUrl:
            'https://i.pravatar.cc/300', //must add a default avatar to fix null issues
        displayName: displayName,
        uid: uid);

    userCollection.add(user.toMap());
    return; // since it's a future void type
  }

  Future<void> update(MUser user, String displayName, String avatarUrl,
      BuildContext context) async {
    final userCollection = FirebaseFirestore.instance.collection('users');

    MUser updateUser =
        MUser(displayName: displayName, avatarUrl: avatarUrl, uid: user.uid);

    userCollection.doc(user.id).update(updateUser.toMap());

    return; // since it's a future void type
  }
}
