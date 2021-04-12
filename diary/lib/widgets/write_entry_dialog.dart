import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteEntryDialog extends StatelessWidget {
  const WriteEntryDialog({
    Key? key,
    required this.selectedDate,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
  })   : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final DateTime selectedDate;
  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;

  @override
  Widget build(BuildContext context) {
    final _linkReference = Provider.of<CollectionReference>(context);

    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //left side
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {},
                      child: Text('Discard')),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                        onSurface: Colors.blueGrey,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(color: Colors.green, width: 1))),
                    // style: ButtonStyle(
                    //   textStyle: MaterialStateProperty.all<TextStyle>(

                    //   ),
                    //     backgroundColor:
                    //         MaterialStateProperty
                    //             .all<Color>(
                    //                 Colors.greenAccent),
                    //     shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //         RoundedRectangleBorder(
                    //             borderRadius:
                    //                 BorderRadius.circular(
                    //                     13),
                    //             side: BorderSide(
                    //                 color: Colors.green)))),
                    onPressed: () {
                      final _fieldsNotEmpty =
                          _titleTextController.text.isNotEmpty &&
                              _descriptionTextController.text.isNotEmpty;

                      if (_fieldsNotEmpty) {
                        _linkReference.add(Diary(
                                author: "current user!",
                                entryTime: Timestamp.fromDate(selectedDate),
                                entry: _descriptionTextController.text,
                                title: _titleTextController.text)
                            .toMap());
                      }
                    },
                    child: Text('Done'))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white12,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                splashRadius: 26,
                                onPressed: () {},
                                icon: Icon(Icons.image_rounded)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                splashRadius: 26,
                                hoverColor: Colors.red,
                                onPressed: () {},
                                icon: Icon(Icons.delete_outline_rounded)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${formattDate(selectedDate)}"),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Form(
                                  child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {},
                                    controller: _titleTextController,
                                    decoration: InputDecoration(
                                      hintText: 'Title...',
                                    ),
                                  ),
                                  TextFormField(
                                    maxLines:
                                        null, // make this null so that we have true multiline
                                    validator: (value) {},
                                    keyboardType: TextInputType.multiline,
                                    controller: _descriptionTextController,
                                    decoration: InputDecoration(
                                        hintText:
                                            'Writy your thoughts here...'),
                                  )
                                ],
                              )),
                            ),
                            Spacer()
                          ],
                        )),
                  ],
                )),
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(18),
    );
  }
}
