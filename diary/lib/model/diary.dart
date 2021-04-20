import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String? id;
  final String? userId;
  final String? title;
  final String? author;
  final Timestamp? entryTime;
  final String? photoUrls;
  final String? entry;

// ? null safety - must add ?
  Diary(
      {this.id,
      this.userId,
      this.author,
      this.entryTime,
      this.photoUrls,
      this.title,
      this.entry});

  factory Diary.fromDocument(QueryDocumentSnapshot data) {
    return Diary(
        id: data.id,
        userId: data.data()['user_id'],
        author: data.data()['author'],
        entryTime: data.data()['entry_time'],
        photoUrls: data.data()['photo_list'],
        title: data.data()['title'],
        entry: data.data()['entry']);
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'author': author,
      'entry': entry,
      'photo_list': photoUrls,
      'entry_time': entryTime,
    };
  }
}
