import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/utils/date_formatter.dart';
import 'package:diary/widgets/inner_list_card.dart';
import 'package:flutter/material.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
    required Size screenSize,
    required List<Diary> listOfDiaries,
    required this.selectedDate,
  })   : _screenSize = screenSize,
        _listOfDiaries = listOfDiaries,
        super(key: key);

  final Size _screenSize;
  final List<Diary> _listOfDiaries;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _screenSize.width * 0.4,
      child: ListView.builder(
        itemCount: _listOfDiaries.length,
        itemBuilder: (context, index) {
          final diary = _listOfDiaries[index];
          final isSameEntryDate = (DateTime.now().toString().split(' ')[0] ==
              diary.entryTime?.toDate().toString().split(' ')[0]);
          print(
              "Diary --> Date now: ${DateTime.now().toString().split(' ')[0]} \n Date entry: ${diary.entryTime?.toDate().toString().split(' ')[0]}");
          return Card(
            elevation: 4,
            child: Column(
              children: [
                InnerListCard(
                    isSameEntry: isSameEntryDate,
                    selectedDate: selectedDate,
                    screenSize: _screenSize,
                    listOfDiaries: _listOfDiaries,
                    index: index),
              ],
            ),
          );
        },
      ),
    );
  }
}
