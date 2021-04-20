import 'package:diary/model/user.dart';
import 'package:diary/util/services.dart';
import 'package:flutter/material.dart';

class UpdateUserProfileDialog extends StatelessWidget {
  const UpdateUserProfileDialog({
    Key? key,
    required MUser? user,
    required TextEditingController? avatarUrlTextController,
    required TextEditingController? displayNameTextController,
    // required String? currDocId,
  })   : _user = user,
        _avatarUrlTextController = avatarUrlTextController,
        _displayNameTextController = displayNameTextController,
        // _currDocId = currDocId,
        super(key: key);

  final MUser? _user;
  final TextEditingController? _avatarUrlTextController;
  final TextEditingController? _displayNameTextController;
  // final String? _currDocId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //left side
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Edit ${_user!.displayName}',
                  style: Theme.of(context).textTheme.headline5,
                ),
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
                        children: [],
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Form(
                                  child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {},
                                    controller: _avatarUrlTextController,
                                    decoration: InputDecoration(
                                      hintText:
                                          'https://twitter.com/buildappswithme/photo',
                                    ),
                                  ),
                                  TextFormField(
                                    // make this null so that we have true multiline
                                    validator: (value) {},
                                    keyboardType: TextInputType.multiline,
                                    controller: _displayNameTextController,
                                    decoration:
                                        InputDecoration(hintText: 'Alexandre'),
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.green,
                                          onSurface: Colors.blueGrey,
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              side: BorderSide(
                                                  color: Colors.green,
                                                  width: 1))),
                                      onPressed: () {
                                        final _fieldsNotEmpty =
                                            _avatarUrlTextController!
                                                    .text.isNotEmpty &&
                                                _displayNameTextController!
                                                    .text.isNotEmpty;

                                        if (_fieldsNotEmpty) {
                                          DiaryService().update(
                                              _user!,
                                              _displayNameTextController!.text,
                                              _avatarUrlTextController!.text,
                                              context);

                                          Future.delayed(
                                            Duration(milliseconds: 200),
                                          ).then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Update'),
                                      ))
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

// class UpdateUserProfileDialog extends StatelessWidget {
//   const UpdateUserProfileDialog({
//     Key? key,
//     required User? user,
//     required TextEditingController? avatarUrlTextController,
//     required TextEditingController? displayNameTextController,
//     required String? currDocId,
//   })   : _user = user,
//         _avatarUrlTextController = avatarUrlTextController,
//         _displayNameTextController = displayNameTextController,
//         _currDocId = currDocId,
//         super(key: key);

//   final User? _user;
//   final TextEditingController? _avatarUrlTextController;
//   final TextEditingController? _displayNameTextController;
//   final String? _currDocId;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       elevation: 5,
//       content: Container(
//         width: MediaQuery.of(context).size.width * 0.40,
//         height: MediaQuery.of(context).size.height * 0.40,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             //left side
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   'Edit ${_user!.email!.split("@")[0].toUpperCase()}',
//                   style: Theme.of(context).textTheme.headline5,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Expanded(
//                 flex: 1,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height,
//                       color: Colors.white12,
//                       child: Column(
//                         children: [],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 50,
//                     ),
//                     Expanded(
//                         flex: 3,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.5,
//                               child: Form(
//                                   child: Column(
//                                 children: [
//                                   TextFormField(
//                                     validator: (value) {},
//                                     controller: _avatarUrlTextController,
//                                     decoration: InputDecoration(
//                                       hintText:
//                                           'https://twitter.com/buildappswithme/photo',
//                                     ),
//                                   ),
//                                   TextFormField(
//                                     // make this null so that we have true multiline
//                                     validator: (value) {},
//                                     keyboardType: TextInputType.multiline,
//                                     controller: _displayNameTextController,
//                                     decoration:
//                                         InputDecoration(hintText: 'Alexandre'),
//                                   ),
//                                   TextButton(
//                                       style: TextButton.styleFrom(
//                                           primary: Colors.white,
//                                           backgroundColor: Colors.green,
//                                           onSurface: Colors.blueGrey,
//                                           elevation: 4,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(15)),
//                                               side: BorderSide(
//                                                   color: Colors.green,
//                                                   width: 1))),
//                                       onPressed: () {
//                                         final _fieldsNotEmpty =
//                                             _avatarUrlTextController!
//                                                     .text.isNotEmpty &&
//                                                 _displayNameTextController!
//                                                     .text.isNotEmpty;

//                                         if (_fieldsNotEmpty) {
//                                           DiaryService().update(
//                                               _currDocId!,
//                                               _displayNameTextController!.text,
//                                               _avatarUrlTextController!.text,
//                                               context);

//                                           Future.delayed(
//                                             Duration(milliseconds: 200),
//                                           ).then((value) {
//                                             Navigator.of(context).pop();
//                                           });
//                                         }
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Text('Update'),
//                                       ))
//                                 ],
//                               )),
//                             ),
//                             Spacer()
//                           ],
//                         )),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//       contentPadding: EdgeInsets.all(18),
//     );
//   }
// }
