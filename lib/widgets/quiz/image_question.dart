import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';

class ImageQuestion extends StatefulWidget {
  final QuizQuestion question;
  final List<VoidCallback> onTaps;

  ImageQuestion({this.question, this.onTaps});

  @override
  _ImageQuestionState createState() => _ImageQuestionState();
}

class _ImageQuestionState extends State<ImageQuestion> {
  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0, bottom: 25),
                child: Container(
                  color: Color.fromARGB(190, 0, 0, 0),
                  height: (MediaQuery.of(context).size.height / 100) * 20,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.question.text,
                        style: Theme.of(context).textTheme.headline,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: widget.question.audio != null
                            ? OutlineButton.icon(
                                onPressed: () {
                                  player.play(
                                    widget.question.audio.path,
                                    isLocal: true,
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
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    QuizImageButton(
                      onTap: widget.onTaps[0],
                      imagePath: widget.question.answers[0].image.path,
                      title: widget.question.answers[0].text,
                    ),
                    QuizImageButton(
                      onTap: widget.onTaps[1],
                      imagePath: widget.question.answers[1].image.path,
                      title: widget.question.answers[1].text,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  QuizImageButton(
                    onTap: widget.onTaps[2],
                    imagePath: widget.question.answers[2].image.path,
                    title: widget.question.answers[2].text,
                  ),
                  QuizImageButton(
                    onTap: widget.onTaps[3],
                    imagePath: widget.question.answers[3].image.path,
                    title: widget.question.answers[3].text,
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
}
