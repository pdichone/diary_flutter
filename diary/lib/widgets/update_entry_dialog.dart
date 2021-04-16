import 'dart:typed_data';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:mime_type/mime_type.dart';
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/utils/date_formatter.dart';
import 'package:diary/widgets/delete_entry_dialog.dart';
import 'package:diary/widgets/inner_list_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class UpdateEntryDialog extends StatefulWidget {
  const UpdateEntryDialog({
    Key? key,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
    required this.currDiary,
    required CollectionReference linkReference,
    required this.widget,
    this.cloudFile,
    this.fileBytes,
    this.imageWidget,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        _linkReference = linkReference,
        _imageWidget = imageWidget,
        _cloudFile = cloudFile,
        _fileBytes = fileBytes,
        super(key: key);

  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final Diary currDiary;
  final CollectionReference _linkReference;
  final InnerListCard widget;
  final html.File? cloudFile;
  final fileBytes;
  final Image? imageWidget;

  final html.File? _cloudFile;
  final _fileBytes;
  final Image? _imageWidget;

  @override
  _UpdateEntryDialogState createState() => _UpdateEntryDialogState();
}

class _UpdateEntryDialogState extends State<UpdateEntryDialog> {
  html.File? _cloudFile;
  var _fileBytes;
  Image? _imageWidget;
  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      final _fieldsNotEmpty =
                          widget._titleTextController.text.isNotEmpty &&
                              widget._descriptionTextController.text.isNotEmpty;
                      final diaryTitleChanged = widget.currDiary.title !=
                          widget._titleTextController.text;
                      final diaryEntryChanged = widget.currDiary.entry !=
                          widget._descriptionTextController.text;

                      final diaryUpdate = diaryTitleChanged ||
                          diaryEntryChanged ||
                          _fileBytes != null;

                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;

                      final dateTime = DateTime.now();
                      final path = '$dateTime';

                      if (_fieldsNotEmpty && diaryUpdate) {
                        print('Running inside for update');
                        widget._linkReference
                            .doc(widget.currDiary.id)
                            .update(Diary(
                              author: "current user!",
                              entryTime: Timestamp.fromDate(
                                  widget.widget.selectedDate!),
                              entry: widget._descriptionTextController.text,
                              title: widget._titleTextController.text,
                              photoUrls: (widget.currDiary.photoUrls != null)
                                  ? widget.currDiary.photoUrls.toString()
                                  : null,
                            ).toMap());
                        // only update image if it's not null
                        if (_fileBytes != null) {
                          print('Running inside for filebytes update');
                          firebase_storage.SettableMetadata? metadata =
                              firebase_storage.SettableMetadata(
                                  contentType: 'image/jpeg',
                                  customMetadata: {'picked-file-path': path});

                          fs
                              .ref()
                              .child('images/$path')
                              .putData(_fileBytes, metadata)
                              .then((value) {
                            return value.ref.getDownloadURL().then((value) {
                              widget._linkReference
                                  .doc(widget.currDiary.id!)
                                  .update({'photo_list': value.toString()});
                              print(value.toString());
                            });
                          });
                        }

                        Navigator.of(context).pop();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Done'),
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
                                onPressed: () async {
                                  // pick image from system!
                                  await getMultipleImageInfos();
                                },
                                icon: Icon(Icons.image_rounded)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                splashRadius: 26,
                                hoverColor: Colors.red,
                                onPressed: () {
                                  //delete item!

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteEntryDialog(
                                          currDiary: widget.currDiary,
                                          linkReference: widget._linkReference);
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
                            Text(
                                "${formatDateFromTimestamp(widget.currDiary.entryTime)}"),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.60,
                              height: MediaQuery.of(context).size.height * 0.40,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (_imageWidget != null)
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _imageWidget,
                                      )
                                    : Image.network(
                                        (widget.currDiary.photoUrls == null)
                                            ? 'https://picsum.photos/400/200'
                                            : widget.currDiary.photoUrls!
                                                .toString(),
                                      ),
                              ),
                            ),
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

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    String? mimeType = mime(Path.basename(mediaData.fileName!));
    html.File mediaFile =
        new html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    setState(() {
      _cloudFile = mediaFile;
      _fileBytes = mediaData.data;
      _imageWidget = Image.memory(mediaData.data!);
    });
  }
}
