import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:flutter/material.dart';

class Tester extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final _documents = snapshot.data!.docs.map((diary) {
            print('===> ${diary.data()['entry']}');
            return Diary.fromDocument(diary);
          }).toList();
          print('doc==> ${_documents.length}');

          return ListView.builder(
            itemCount: _documents.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${_documents[index].entry}'),
              );
            },
          );
        },
      ),
    );
  }
}
