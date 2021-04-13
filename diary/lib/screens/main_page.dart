import 'package:diary/model/diary.dart';
import 'package:diary/widgets/diary_list_view.dart';
import 'package:diary/widgets/write_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _searchController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _listOfDiaries = Provider.of<List<Diary>>(context);

    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _descriptionTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 12,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                'Diary',
                style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
              ),
            ),
            //pill button
            Padding(
              padding: const EdgeInsets.only(top: 38),
              child: TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    child: Text(
                      'Today',
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: _screenSize.width * 0.4,
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _searchController,
                      onChanged: (value) {
                        print(value.toString());
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)),
                        suffixIcon: TextButton(
                            onPressed: () {
                              //print("list==> ${_listOfDiaries.length}");
                            },
                            child: SizedBox(
                              child: Icon(Icons.check),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                items: <String>['Latest', 'Earliest'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }).toList(),
                hint: Text('Select'),
                onChanged: (_) {},
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {},
                    tooltip: 'Notifications',
                    icon: Icon(
                      Icons.notifications,
                      size: 29,
                      color: Colors.grey,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/a-/AOh14GgCEsNF3Km22DLGypw0c2ON86I8v58YGwiHhpHHIgo=s96-c'),
                  backgroundColor: Colors.transparent,
                ),
              ),
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
                  //color: HexColor('#ffffff'),
                  shape: BoxShape.rectangle,
                  border: Border(
                      right: BorderSide(
                    width: 0.4,
                    color: Colors.blueGrey,
                  ))),
              //color: Colors.white,
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
                        });
                        //print(selectedDate.toLocal().toIso8601String());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Card(
                      elevation: 4,
                      child: TextButton.icon(
                          // style: ButtonStyle(
                          //     shape: MaterialStateProperty.all<
                          //             RoundedRectangleBorder>(
                          //         RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(18.0),
                          //             side: BorderSide(color: Colors.red)))),
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
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Write New',
                              style: TextStyle(fontSize: 19),
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
    );
  }
}
