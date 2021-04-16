import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image/image.dart' as IMG;
import 'package:firebase/firebase.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/model/diary.dart';
import 'package:diary/utils/date_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class WriteEntryDialog extends StatefulWidget {
  const WriteEntryDialog({
    Key? key,
    this.selectedDate,
    Diary? diary,
    TextEditingController? titleTextController,
    TextEditingController? descriptionTextController,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final DateTime? selectedDate;
  final TextEditingController? _titleTextController;
  final TextEditingController? _descriptionTextController;

  @override
  _WriteEntryDialogState createState() => _WriteEntryDialogState();
}

class _WriteEntryDialogState extends State<WriteEntryDialog> {
  var _buttonText = 'Done';

  Image? pickedImage;
  Uint8List? pickedImageFile;

  html.File? _cloudFile;
  var _fileBytes;
  Image? _imageWidget;
  final _controller = CropController();

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
                      final _fieldsNotEmpty = widget
                              ._titleTextController!.text.isNotEmpty &&
                          widget._descriptionTextController!.text.isNotEmpty;

                      firebase_storage.FirebaseStorage fs =
                          firebase_storage.FirebaseStorage.instance;

                      final dateTime = DateTime.now();
                      final path = '$dateTime';

                      String? currId;

                      if (_fieldsNotEmpty) {
                        _linkReference
                            .add(Diary(
                          author: "current user!",
                          entryTime: Timestamp.fromDate(widget.selectedDate!),
                          entry: widget._descriptionTextController!.text,
                          title: widget._titleTextController!.text,
                        ).toMap())
                            .then((value) {
                          setState(() {
                            currId = value.id;
                          });
                          return null;
                        });

                        if (_fileBytes != null) {
                          //compress fileBytes

                          // Crop(
                          //   image: _fileBytes,
                          //   onCropped: (value) {
                          //     print(value.length);
                          //   },
                          // );
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
                              _linkReference
                                  .doc(currId!)
                                  .update({'photo_list': value.toString()});
                              print(value.toString());
                            });
                          });
                        }

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
                                onPressed: () async {
                                  await getMultipleImageInfos();
                                },
                                icon: Icon(Icons.image_rounded)),
                          ),
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
                            Text("${formattDate(widget.selectedDate!)}"),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Form(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _imageWidget,
                                  ),
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
      _fileBytes = mediaData.data!;
      // _fileBytes = resizeImage(
      //     mediaData.data!); // using resize stalls the app a bit - trade offs?!
      _imageWidget = Image.memory(mediaData.data!);
    });
  }

  Uint8List resizeImage(Uint8List data) {
    //source: https://stackoverflow.com/questions/62526213/change-image-size-from-uint8list-data-in-flutter
    print('image Before resized -=> ${data.length}');
    Uint8List? resizedData = data;
    IMG.Image img = IMG.decodeImage(data)!;
    IMG.Image resized = IMG.copyResize(img,
        width: img.width * 0.5 as int, height: img.height * 0.5 as int);
    resizedData = IMG.encodeJpg(resized) as Uint8List;
    print('image resized -=> ${resizedData.length}');
    return resizedData;
  }
}
