import 'package:audioplayers/audio_cache.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';

class FactFilesDetails extends StatefulWidget {
  final FactFileEntry entry;
  final String heroTag;
  static final AudioCache callPlayer = new AudioCache();
  static final AudioCache pronunciationsPlayer = new AudioCache();

  ///Takes in a [FactFileEntry] and a [String]and returns the view
  FactFilesDetails({this.entry, this.heroTag});

  @override
  _FactFilesDetailsState createState() => _FactFilesDetailsState();
}

class _FactFilesDetailsState extends State<FactFilesDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry.primaryName),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Scrollbar(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: (MediaQuery.of(context).size.height / 100) * 51.58,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    boxFit: BoxFit.fill,
                    autoplay: false,
                    images: [
                      // Todo: load image paths from database
                    ],
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 2000),
                    overlayShadow: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Column(
                    children: <Widget>[
                      Heading(
                        text: widget.entry.primaryName,
                      ),
                      //TODO: add a maori name into db and put here
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Māori name",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            widget.entry.pronounceAudio != null ? OutlineButton.icon(
                              onPressed: () {
                                FactFilesDetails.pronunciationsPlayer.play(
                                  widget.entry.pronounceAudio.path
                                      .substring(
                                    widget.entry.pronounceAudio.path
                                            .indexOf('/') +
                                        1,
                                  ),
                                );
                              },
                              label: Text(
                                "Pronounce",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5),
                              icon: Icon(
                                FontAwesomeIcons.volumeUp,
                                color: Colors.white,
                              ),
                            ) : Container(),
                            widget.entry.listenAudio != null ? OutlineButton.icon(
                              onPressed: () {
                                FactFilesDetails.callPlayer.play(
                                  widget.entry.listenAudio.path.substring(
                                      widget.entry.listenAudio.path
                                              .indexOf('/') +
                                          1),
                                );
                              },
                              label: Text(
                                "Listen",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5),
                              icon: Icon(
                                FontAwesomeIcons.music,
                                color: Colors.white,
                              ),
                            ) : null,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              child: Column(
                children: <Widget>[
                  BodyText(
                    text: widget.entry.primaryName,
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height / 100) * 2.5,
                  ),
                  BodyText(
                    text: widget.entry.bodyText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
