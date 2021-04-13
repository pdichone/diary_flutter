import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:flutter/material.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.currDiary,
    required CollectionReference linkReference,
  })   : _linkReference = linkReference,
        super(key: key);

  final Diary currDiary;
  final CollectionReference _linkReference;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Entry?',
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
          'Are you sure you want to delete the entry? \n This action cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel')),
        TextButton(
            onPressed: () {
              // Let's delete!!
              _linkReference
                  .doc(currDiary.id)
                  .delete()
                  .then((value) => Navigator.of(context).pop());
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            )),
      ],
    );
  }
}
