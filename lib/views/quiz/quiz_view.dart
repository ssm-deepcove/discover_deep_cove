import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/views/quiz/quiz_result.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:discover_deep_cove/widgets/quiz/correct_wrong_overlay.dart';
import 'package:discover_deep_cove/widgets/quiz/image_question.dart';
import 'package:discover_deep_cove/widgets/quiz/text_question.dart';
import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  QuizView({this.quiz});

  final Quiz quiz;

  @override
  State createState() => QuizViewState();
}

class QuizViewState extends State<QuizView> {
  bool questionsLoaded = false;

  QuizQuestion get currentQuestion => widget.quiz.questions[questionIndex];
  bool isCorrect;
  String guess;
  String answer;
  bool showOverlay = false;
  bool showAppBar = true;
  int questionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    addAttempt();
  }

  Future<void> loadQuestions() async {
    widget.quiz.questions = await QuizQuestionBean.of(context)
        .preloadAllRelationships(widget.quiz.questions);
    setState(() => questionsLoaded = true);
  }

  Future<void> addAttempt() async {
    Quiz quiz = widget.quiz;
    quiz.attempts++;
    await QuizBean.of(context).update(quiz);
  }

  Future<void> updateHighScore(int score) async {
    Quiz quiz = widget.quiz;
    quiz.highScore = score;
    await QuizBean.of(context).update(quiz);
  }

  void handleAnswer(int answerId) {
    if (currentQuestion.trueFalseAnswer != null) {
      isCorrect = answerId == (currentQuestion.trueFalseAnswer as int);
      guess = answerId == 0 ? "False" : "True";
      answer = currentQuestion.trueFalseAnswer ? "True" : "False";
    } else {
      isCorrect = answerId == currentQuestion.correctAnswerId;
      guess = currentQuestion.answers.firstWhere((a) => a.id == answerId).text;
      answer = currentQuestion.answers
          .firstWhere((a) => a.id == currentQuestion.correctAnswerId)
          .text;
    }

    if (isCorrect) score++;

    setState(() => showOverlay = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Heading(text: widget.quiz.title),
              centerTitle: true,
              leading: Container(),
              actions: [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Heading(
                    text:
                        "${questionIndex + 1}/${widget.quiz.questions.length}",
                  ),
                )
              ],
              backgroundColor: Theme.of(context).primaryColor,
            )
          : Container(),
      body: questionsLoaded
          ? Stack(
              fit: StackFit.expand,
              children: [
                buildQuestionView(),
                if (showOverlay) buildOverlay(),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildQuestionView() {
    if (questionIndex == widget.quiz.questions.length) {
      bool isHighScore = false;
      if (score > widget.quiz.highScore) {
        updateHighScore(score);
        isHighScore = true;
      }

      setState(() => showAppBar = false);

      return QuizResult(
        name: widget.quiz.title,
        score: score,
        outOf: widget.quiz.questions.length,
        isHighscore: isHighScore,
      );
    }

    if (currentQuestion.image != null) {
      return TextQuestion(
        question: currentQuestion,
        onTaps: [
          () => handleAnswer(currentQuestion.answers[0].id),
          () => handleAnswer(currentQuestion.answers[1].id),
          () => handleAnswer(currentQuestion.answers[2].id),
          () => handleAnswer(currentQuestion.answers[3].id),
        ],
      );
    } else {
      return ImageQuestion(
        question: currentQuestion,
        onTaps: [
          () => handleAnswer(currentQuestion.answers[0].id),
          () => handleAnswer(currentQuestion.answers[1].id),
          () => handleAnswer(currentQuestion.answers[2].id),
          () => handleAnswer(currentQuestion.answers[3].id),
        ],
      );
    }
  }

  Widget buildOverlay() {
    return CorrectWrongOverlay(
      isCorrect: isCorrect,
      guess: guess,
      answer: answer,
      onTap: () => setState(() {
        questionIndex++;
        showOverlay = false;
      }),
    );
  }
}
