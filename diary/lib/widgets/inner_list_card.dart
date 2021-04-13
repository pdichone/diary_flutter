import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/utils/date_formatter.dart';
import 'package:diary/widgets/delete_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InnerListCard extends StatelessWidget {
  const InnerListCard({
    Key? key,
    required this.selectedDate,
    required Size screenSize,
    required List<Diary> listOfDiaries,
    required int index,
    required bool isSameEntry,
  })   : _screenSize = screenSize,
        _listOfDiaries = listOfDiaries,
        _index = index,
        super(key: key);

  final DateTime selectedDate;
  final Size _screenSize;
  final List<Diary> _listOfDiaries;
  final int _index;

  @override
  Widget build(BuildContext context) {
    final _linkReference = Provider.of<CollectionReference>(context);
    Diary currDiary = _listOfDiaries[_index];

    // for (var item in filteredList) {
    //   print("Same date___ ${formatDateFromTimestampHour(item.entryTime)}");
    // }
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              //'${formattDate(selectedDate)}',
              '${formatDateFromTimestamp(currDiary.entryTime)}',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DeleteEntryDialog(
                          currDiary: currDiary, linkReference: _linkReference);
                    },
                  );
                },
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.grey,
                ),
                label: Text(''))
          ],
        ),
      ),
      subtitle: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              '• ${formatDateFromTimestampHour(currDiary.entryTime)}',
              style: TextStyle(color: Colors.green),
            ),
            TextButton.icon(
                onPressed: () {}, icon: Icon(Icons.more_horiz), label: Text(''))
          ]),

          Image.network(
            (currDiary.photoUrls == null || currDiary.photoUrls!.length == 0)
                ? 'https://picsum.photos/400/200'
                : currDiary.photoUrls![0].toString(),
            //width: _screenSize.width * 0.9,
            //height: 100,
          ),
          // SizedBox(
          //   width: _screenSize.width * 0.8,
          //   height: _screenSize.height * 0.3,
          //   child: Image.network(
          //     (currDiary.photoUrls == null)
          //         ? 'https://picsum.photos/400/200'
          //         : currDiary.photoUrls![0].toString(),
          //     //width: _screenSize.width * 0.9,
          //     //height: 100,
          //   ),
          // ),
          Row(
            children: [
              Flexible(
                //  use flexible to avoid the text to cut off!
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${currDiary.title}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      //using
                      child: Text(
                        '${currDiary.entry}',
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          //_isSameEntry ? Text('Same Entry => add to the same card') : Text(''),
        ],
      ),
      onTap: () {
        //show entryDetailsAlert
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: _screenSize.width * 0.3,
                    child: Row(
                      children: [
                        Text(
                          '${formatDateFromTimestamp(currDiary.entryTime)}',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.delete_forever_sharp),
                            onPressed: () {})
                      ],
                    ),
                  ),
                ],
              ),
              content: ListTile(
                subtitle: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• ${formatDateFromTimestampHour(currDiary.entryTime)}',
                            style: TextStyle(color: Colors.green),
                          ),
                        ]),

                    Image.network(
                      (currDiary.photoUrls == null ||
                              currDiary.photoUrls!.length == 0)
                          ? 'https://picsum.photos/400/200'
                          : currDiary.photoUrls![0].toString(),
                      //width: _screenSize.width * 0.9,
                      //height: 100,
                    ),

                    Row(
                      children: [
                        Flexible(
                          //  use flexible to avoid the text to cut off!
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${currDiary.title}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                //using
                                child: Text(
                                  '${currDiary.entry}',
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    //_isSameEntry ? Text('Same Entry => add to the same card') : Text(''),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'))
              ],
            );
          },
        );
        print('list taped and item is ==> ${currDiary.entry}');
      },
    );
  }
}
