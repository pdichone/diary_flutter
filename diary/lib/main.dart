import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/model/user.dart';
import 'package:diary/screens/get_started_page.dart';
import 'package:diary/screens/login_page.dart';
import 'package:diary/screens/main_page.dart';
import 'package:diary/screens/page_not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final usersListStream = FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshots) {
    return snapshots.docs.map((user) {
      return MUser.fromDocument(user);
    }).where((element) {
      return (element.uid ==
          FirebaseAuth.instance.currentUser!
              .uid); //authuser must match one user in the list of users!
    }).toList();
  });

  final userDiaryDataStream =
      FirebaseFirestore.instance.collection('diaries').snapshots()
          // ignore: top_level_function_literal_block
          .map((snapshot) {
    return snapshot.docs.map((diary) {
      //print(diary.data()['photo_list']);
      return Diary.fromDocument(diary);
    }).toList();
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<MUser?>>(
            create: (context) => usersListStream, initialData: []),
        StreamProvider<User?>(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
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
        title: 'Diary Book',
        theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: '/',
        // routes: {
        //   '/main': (context) => MainPage(),
        //   '/login': (context) => LoginPage()
        // },

        /* advanced routing */
        onGenerateRoute: (settings) {
          print(settings.name);
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingsName: settings.name!);
            },
          );
        },
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => PageNotFound()),

        // home: MyHomePage(
        //   title: 'hello',
        // ),
        // home: MainPage(),
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String settingsName;
  const RouteController({
    Key? key,
    required this.settingsName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;

    print('User is signed in: ==> $userSignedIn');

    final signedInGotoMain =
        userSignedIn && settingsName == '/main'; // they are good to go!
    final notSignedInGotoMain = !userSignedIn &&
        settingsName == '/main'; //not signed in user trying to go to mainPage
    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (settingsName == '/login' || notSignedInGotoMain) {
      return LoginPage();
    } else if (signedInGotoMain) {
      return MainPage();
    } else {
      return PageNotFound();
    }
  }
}
