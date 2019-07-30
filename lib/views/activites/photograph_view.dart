import 'dart:async';
import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/custom_fab.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class PhotographView extends StatefulWidget {
  final Activity activity;
  final bool fromMap;

  ///Takes in a [PhotographActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PhotographView({this.activity, this.fromMap});

  @override
  _PhotographViewState createState() => _PhotographViewState();
}

class _PhotographViewState extends State<PhotographView> {
  File _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  void _onImageButtonPressed(ImageSource source) async {
    try {
      _imageFile = await ImagePicker.pickImage(source: source);
    } catch (e) {
      _pickImageError = e;
    }
    setState(() {});
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not taken a photo yet.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Heading(
           widget.activity.title,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Text(widget.activity.description),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: Text(widget.activity.task),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Divider(color: Color(0xFF777777)),
          ),
          widget.fromMap
              ? Column(
                  children: <Widget>[
                    BodyText(
                       "Your photo:",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        height: (MediaQuery.of(context).size.height / 100) * 45.2,
                        width: (MediaQuery.of(context).size.width / 4) * 3.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: FileImage(
                              File(widget.activity.userPhoto.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                  child: Column(
                    children: <Widget>[
                      FutureBuilder<void>(
                        future: retrieveLostData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return BodyText(
                                 'You have not taken a photo yet.',
                                align: TextAlign.center,
                              );
                            case ConnectionState.done:
                              return _previewImage();
                            default:
                              if (snapshot.hasError) {
                                return Text(
                                  'Pick image error: ${snapshot.error}}',
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return BodyText(
                                   'You have not taken a photo yet.',
                                  align: TextAlign.center,
                                );
                              }
                          }
                        },
                      ),
                    ],
                  ),
                ),
          Expanded(child: Container()),
          widget.fromMap
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
                  child: Text(
                    "To edit your answer, re-scan the QR code.",
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: Color(0xFF777777),
                        ),
                  ),
                )
              : null,
          Expanded(child: Container()),
          widget.fromMap
              ? BottomBackButton()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColorDark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: BodyText(
                             "Pass",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            if (_imageFile != null) {
                              // Todo: Make saving photos work.
                              Navigator.of(context).pop();
                            } else {
                              Toast.show(
                                "Please take a photo!",
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM,
                                backgroundColor: Theme.of(context).primaryColor,
                                textColor: Colors.black,
                              );
                            }
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: BodyText(
                             "Save",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: widget.fromMap
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomFab(
                icon: FontAwesomeIcons.camera,
                 text: "I see it!",
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera);
                },
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
