import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:flutter/material.dart';

class QuizResult extends StatelessWidget {
  final String name;
  final int score;
  final int outOf;
  final bool highscore;

  ///takes in a [string], two [ints] and a bool and
  ///returns the view displaying the correct information.
  QuizResult({this.name, this.score, this.outOf, this.highscore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
              ),
              BodyText(
                "Quiz Completed!",
                align: TextAlign.center,
              ),
              SizedBox(
                height: Screen.height(context, percentage: 5.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: Screen.height(context, percentage: 37.0),
                  width: Screen.width(context),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: BodyText(
                          "Your Score:",
                        ),
                      ),
                      Text(
                        "$score/$outOf",
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 100),
                      ),
                      highscore
                          ? BodyText(
                              "New Highscore!",
                            )
                          : null,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BodyText(
                          setMessage(),
                          align: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          BottomBackButton(),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  setMessage() {
    if (score == outOf) {
      return "Congratulations you got every question correct!";
    } else if (((score / outOf) * 100) >= 50) {
      return "Almost there keep up the good work!";
    } else if (((score / outOf) * 100) >= 0 && ((score / outOf) * 100) <= 49) {
      return "You are improving keep up the good work";
    } else {
      return "You can do better, keep trying!";
    }
  }
}