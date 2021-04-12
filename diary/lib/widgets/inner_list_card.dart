import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/utils/date_formatter.dart';
import 'package:flutter/material.dart';

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
        _isSameEntry = isSameEntry,
        super(key: key);

  final DateTime selectedDate;
  final Size _screenSize;
  final List<Diary> _listOfDiaries;
  final int _index;
  final bool _isSameEntry;

  @override
  Widget build(BuildContext context) {
    //formatDateFromTimestamp(_listOfDiaries[_index].entryTime);
    //
    List<Diary> filteredList = [];
    filteredList = _listOfDiaries
        .where((element) =>
            element.entryTime?.toDate().toString().split(' ')[0] ==
            element.entryTime?.toDate().toString().split(' ')[0])
        .toList();

    for (var item in filteredList) {
      print("Same date___ ${item.entryTime?.toDate().toString()}");
    }
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              //'${formattDate(selectedDate)}',
              '${formatDateFromTimestamp(_listOfDiaries[_index].entryTime)}',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
                label: Text(''))
          ],
        ),
      ),
      subtitle: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('time added'),
            TextButton.icon(
                onPressed: () {}, icon: Icon(Icons.more_horiz), label: Text(''))
          ]),
          SizedBox(
            width: _screenSize.width * 0.8,
            height: _screenSize.height * 0.3,
            child: Image.network(
              'https://picsum.photos/400/200',
              //width: _screenSize.width * 0.9,
              //height: 100,
            ),
          ),
          Text('${_listOfDiaries[_index].entry}'),

          //_isSameEntry ? Text('Same Entry => add to the same card') : Text(''),
        ],
      ),
    );
  }
}
