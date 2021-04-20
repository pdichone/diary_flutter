import 'package:delayed_display/delayed_display.dart';
import 'package:diary/model/diary.dart';

import 'package:diary/utils/date_formatter.dart';
import 'package:diary/widgets/inner_list_card.dart';
import 'package:diary/widgets/write_entry_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiaryListView extends StatefulWidget {
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
  _DiaryListViewState createState() => _DiaryListViewState();
}

class _DiaryListViewState extends State<DiaryListView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _descriptionTextController = TextEditingController();
    final _user = Provider.of<User?>(context);

    var _diaryList = widget._listOfDiaries;
    var filteredList = _diaryList.where((element) =>
        element.userId == _user!.uid); //only get diaries for this current user!

    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: widget._screenSize.width * 0.4,
            child: (filteredList.isNotEmpty)
                ? ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      //final diary = _listOfDiaries[index];

//used this plugin:https://pub.dev/packages/delayed_display
                      return DelayedDisplay(
                        delay: Duration(milliseconds: 1),
                        fadeIn: true,
                        child: Card(
                          elevation: 4,
                          child: Column(
                            children: [
                              InnerListCard(
                                  selectedDate: widget.selectedDate,
                                  screenSize: widget._screenSize,
                                  listOfDiaries: filteredList.toList(),
                                  index: index),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : DelayedDisplay(
                    delay: Duration(milliseconds: 2),
                    fadeIn: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: widget._screenSize.width * 0.3,
                                  height: widget._screenSize.height * 0.2,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Safeguard your memory on ${formattDate(widget.selectedDate)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        TextButton.icon(
                                          icon: Icon(Icons.lock_outline_sharp),
                                          label: Text('Click to Add an Entry'),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return WriteEntryDialog(
                                                    selectedDate:
                                                        widget.selectedDate,
                                                    titleTextController:
                                                        _titleTextController,
                                                    descriptionTextController:
                                                        _descriptionTextController);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
