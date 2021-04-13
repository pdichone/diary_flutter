import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Diary {
  final String? id;
  final String? title;
  final String? author;
  final Timestamp? entryTime;
  final List<dynamic>? photoUrls;
  final String? entry;

// ? null safety - must add ?
  Diary(
      {this.id,
      @required this.author,
      @required this.entryTime,
      this.photoUrls,
      this.title,
      this.entry});

  factory Diary.fromDocument(QueryDocumentSnapshot data) {
    return Diary(
        id: data.id,
        author: data.data()['author'],
        entryTime: data.data()['entry_time'],
        photoUrls: data.data()['photo_list'],
        title: data.data()['title'],
        entry: data.data()['entry']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'entry': entry,
      'photo_list': photoUrls,
      'entry_time': entryTime,
    };
  }
}
