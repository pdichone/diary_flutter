import 'dart:html';
import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteEntryDialog extends StatefulWidget {
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
  _WriteEntryDialogState createState() => _WriteEntryDialogState();
}

class _WriteEntryDialogState extends State<WriteEntryDialog> {
  var _buttonText = 'Done';
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
                      onPressed: () {
                        Navigator.of(context).pop();
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return AlertDialog(
                        //       title: Text(
                        //         'Unsaved Changes',
                        //         style: TextStyle(color: Colors.red),
                        //       ),
                        //       content: Text(
                        //           'Are you sure you want to discard all your changes? If you click \'discard\', you will not be able to see the changes.'),
                        //       actions: [
                        //         TextButton(
                        //             onPressed: () => Navigator.of(context).pop(),
                        //             child: Text('Cancel')),
                        //         TextButton(
                        //             onPressed: () {

                        //             },
                        //             child: Text(
                        //               'Discard',
                        //               style: TextStyle(color: Colors.red),
                        //             ))
                        //       ],
                        //     );
                        //   },
                        // );
                      },
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
                          widget._titleTextController.text.isNotEmpty &&
                              widget._descriptionTextController.text.isNotEmpty;

                      if (_fieldsNotEmpty) {
                        _linkReference.add(Diary(
                                author: "current user!",
                                entryTime:
                                    Timestamp.fromDate(widget.selectedDate),
                                entry: widget._descriptionTextController.text,
                                title: widget._titleTextController.text)
                            .toMap());

                        setState(() {
                          _buttonText = 'Saving...';
                        });
                        Future.delayed(
                          Duration(milliseconds: 2500),
                        ).then((value) {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_buttonText),
                    ))
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Text('');
                                      // return AlertDialog(
                                      //   title: Text(
                                    },
                                  );
                                },
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
                            Text("${formattDate(widget.selectedDate)}"),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Form(
                                  child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {},
                                    controller: widget._titleTextController,
                                    decoration: InputDecoration(
                                      hintText: 'Title...',
                                    ),
                                  ),
                                  TextFormField(
                                    maxLines:
                                        null, // make this null so that we have true multiline
                                    validator: (value) {},
                                    keyboardType: TextInputType.multiline,
                                    controller:
                                        widget._descriptionTextController,
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
