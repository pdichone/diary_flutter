// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';

class DiaryService {
  // for this to work must have indexs setup in the cloud firestore:
  // https://console.firebase.google.com/u/0/project/diary-flutter-test/firestore/indexes?create_composite=ClJwcm9qZWN0cy9kaWFyeS1mbHV0dGVyLXRlc3QvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2RpYXJpZXMvaW5kZXhlcy9fEAEaCgoGYXV0aG9yEAEaDgoKZW50cnlfdGltZRACGgwKCF9fbmFtZV9fEAI
  getLatestDiaries(String author) {
    return FirebaseFirestore.instance
        .collection('diaries')
        .where('author', isEqualTo: author)
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

  getEarliestDiaries(String author) {
    return FirebaseFirestore.instance
        .collection('diaries')
        .where('author', isEqualTo: author)
        .orderBy('entry_time', descending: false)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        //print(diary.data().entries.first);
        return Diary.fromDocument(diary);
      });
    });
  }

  getSameDateDiaries(DateTime first, DateTime second) {
    return FirebaseFirestore.instance
        .collection('diaries')
        .where('entry_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
        .where('entry_time',
            isLessThan:
                Timestamp.fromDate(second.add(Duration(days: 1))).toDate())
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }
}
