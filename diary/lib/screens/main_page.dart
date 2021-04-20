import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/model/user.dart';
import 'package:diary/util/services.dart';
import 'package:diary/widgets/create_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:diary/widgets/widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //TextEditingController _searchController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  String? _dropDownText;

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _listOfDiaries = Provider.of<List<Diary>>(context);
    var userDiaryFilteredEntriesListStream;
    final authUser = Provider.of<User?>(context);

    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _descriptionTextController = TextEditingController();

    final _user = Provider.of<User?>(context);

    return WillPopScope(
      onWillPop: () async =>
          false, // to get rid of the back button: https://stackoverflow.com/questions/45916658/how-to-deactivate-or-override-the-android-back-button-in-flutter
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          toolbarHeight: 100,
          elevation: 4,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Diary',
                style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
              ),
              Text(
                'Book',
                style: TextStyle(fontSize: 39, color: Colors.green),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 108.0),
                  child: DropdownButton<String>(
                    items: <String>['Latest', 'Earliest'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                    hint: (_dropDownText == null)
                        ? Text('Select')
                        : Text(_dropDownText!),
                    onChanged: (value) {
                      if (value == 'Latest') {
                        setState(() {
                          _dropDownText = value;
                        });
                        _listOfDiaries.clear(); // clear list first!

                        userDiaryFilteredEntriesListStream =
                            DiaryService().getLatestDiaries(_user!.uid);

                        userDiaryFilteredEntriesListStream.then((value) {
                          //print('---> ${value.toString()}');
                          for (var item in value) {
                            setState(() {
                              _listOfDiaries
                                  .add(item); //_filteredList.add(item);
                            });
                            // print(
                            //     '---> ${formatDateFromTimestamp(item.entryTime)}');
                          }
                        });
                      } else if (value == 'Earliest') {
                        setState(() {
                          _dropDownText = value;
                        });
                        //clear list before adding new items.
                        _listOfDiaries.clear();

                        userDiaryFilteredEntriesListStream =
                            DiaryService().getEarliestDiaries(_user!.uid);

                        userDiaryFilteredEntriesListStream.then((value) {
                          //print('---> ${value.toString()}');
                          for (var item in value) {
                            setState(() {
                              _listOfDiaries
                                  .add(item); //_filteredList.add(item);
                            });
                            // print(
                            //     '---> ${formatDateFromTimestamp(item.entryTime)}');
                          }
                        });
                      }
                    },
                  ),
                ),

                //Create profile - needs fixing!
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final usersListStream = snapshot.data!.docs.map((docs) {
                        return MUser.fromDocument(docs);
                      }).where((element) {
                        return (element.uid == authUser!.uid);
                      }).toList();

                      return usersListStream.isNotEmpty
                          ? createProfile(context, usersListStream, authUser)
                          : Text('nope');
                    }),
              ],
            )
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                height: _screenSize.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(
                      width: 0.4,
                      color: Colors.blueGrey,
                    ))),
                child: Column(
                  children: [
                    //calendar: https://pub.dev/packages/syncfusion_flutter_datepicker
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                        onSelectionChanged:
                            (dateRangePickerSelectionChangedArgs) {
                          setState(() {
                            selectedDate =
                                dateRangePickerSelectionChangedArgs.value;
                            //clear list first
                            _listOfDiaries.clear();
                            userDiaryFilteredEntriesListStream = DiaryService()
                                .getSameDateDiaries(
                                    Timestamp.fromDate(selectedDate).toDate(),
                                    Timestamp.fromDate(selectedDate).toDate(),
                                    _user!.uid);

                            userDiaryFilteredEntriesListStream.then((value) {
                              for (var item in value) {
                                setState(() {
                                  _listOfDiaries
                                      .add(item); //_filteredList.add(item);
                                });
                              }
                            });

                            // print(Timestamp.fromDate(selectedDate)
                            //     .toDate()
                            //     .toString()
                            //     .split(' '));
                            // print(Timestamp.fromDate(
                            //         selectedDate.add(Duration(days: 1)))
                            //     .toDate()
                            //     .toString()
                            //     .split(' '));
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Card(
                        elevation: 4,
                        child: TextButton.icon(
                            icon: Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.greenAccent,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return WriteEntryDialog(
                                      selectedDate: selectedDate,
                                      titleTextController: _titleTextController,
                                      descriptionTextController:
                                          _descriptionTextController);
                                },
                              );
                            },
                            label: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Write New',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(25),
                      height: _screenSize.height,
                      // color: Colors.pink,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: DiaryListView(
                                  screenSize: _screenSize,
                                  listOfDiaries: _listOfDiaries,
                                  selectedDate: selectedDate))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return WriteEntryDialog(
                    selectedDate: selectedDate,
                    titleTextController: _titleTextController,
                    descriptionTextController: _descriptionTextController);
              },
            );
          },
          tooltip: 'Add',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
