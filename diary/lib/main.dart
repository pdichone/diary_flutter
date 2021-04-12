import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/screens/main_page.dart';
import 'package:diary/screens/test_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final linkCollection = FirebaseFirestore.instance.collection('diaries');

  final userDiaryDataStream = FirebaseFirestore.instance
      .collection('diaries')
      .snapshots()
      .map((QuerySnapshot snapshot) {
    return snapshot.docs.map((diary) {
      //print(diary.data()['photo_list']);
      return Diary.fromDocument(diary);
    }).toList();
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CollectionReference>(
          create: (context) => linkCollection,
        ),
        StreamProvider<List<Diary>>(
          initialData: [],
          catchError: (context, error) {
            return [];
          },
          create: (context) => userDiaryDataStream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MainPage(),
      ),
    );
  }
}
