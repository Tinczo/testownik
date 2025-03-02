import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testownik/models/question.dart';
import 'package:testownik/models/question_type.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/models/session_new_data.dart';
import 'package:testownik/screens/options_screen.dart';
import 'package:testownik/screens/finish_screen.dart';
import 'package:testownik/services/database_sevice.dart';
import 'package:testownik/widgets/answers_scroll_view.dart';
import 'package:testownik/widgets/dialogs/demo_version_dialog.dart';
import 'package:testownik/widgets/image_container.dart';
import 'package:testownik/widgets/question_scroll_view.dart';
import 'package:testownik/widgets/test_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';

class SessionTestScreen extends StatefulWidget {
  const SessionTestScreen(
      {super.key, required this.session, required this.sessionData});
  final Session session;
  final NewSessionData sessionData;

  @override
  State<SessionTestScreen> createState() => _SessionTestScreenState();
}

class _SessionTestScreenState extends State<SessionTestScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService.instance;
  final List<Question> questionsAnsweredGood = [];
  Timer? _timer;
  Duration _duration = Duration();
  AnimationController? _controller;
  Animation<double>? _animation;
  double _progressValue = 0.0;

  void _startTimer() {
    Duration sessionDuration = parseDuration(widget.session.time);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _duration + Duration(seconds: 1);
        if (_duration.inSeconds <= 99 * 60 * 60 + 59 * 60 + 59) {
          widget.sessionData.newTime = _formatDuration(_duration);
        }
        Duration totalDuration = sessionDuration + _duration;
        if (totalDuration.inSeconds <= 99 * 60 * 60 + 59 * 60 + 59) {
          widget.session.time = _formatDuration(totalDuration);
        }
      });
    });
  }

  void _updateProgress() {
    int totalAnswers = widget.session.badAnswers + widget.session.goodAnswers;
    double newProgress = (totalAnswers + 1) / widget.session.allAnswers;

    _animation = Tween<double>(begin: _progressValue, end: newProgress)
        .animate(_controller!)
      ..addListener(() {
        setState(() {
          _progressValue = _animation!.value;
        });
      });

    _controller!
        .forward(from: 0.0); // Restartowanie animacji z nowymi wartościami
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    if (widget.session.questions.isNotEmpty) _updateProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller!.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[0]);
      minutes = int.parse(parts[1]);
      seconds = int.parse(parts[2]);
    } else if (parts.length > 1) {
      minutes = int.parse(parts[0]);
      seconds = int.parse(parts[1]);
    } else {
      seconds = int.parse(parts[0]);
    }
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  Widget build(BuildContext context) {
    List<Question> questions = widget.session.questions;

    void repeteAll() {
      _databaseService
          .setQuestionsUnanswered(widget.session.sessionID!)
          .then((value) {
        _databaseService
            .getSessionUnansweredQuestions(widget.session.sessionID!)
            .then((value) {
          if (widget.session.isMixed) {
            for (var question in value) {
              question.answers.shuffle();
            }
          }
          widget.session.goodAnswers = 0;
          widget.session.badAnswers = 0;
          widget.session.allAnswers = value.length;
          widget.session.questions = value;
          widget.sessionData.newGoodAnswers = 0;
          widget.sessionData.newBadAnswers = 0;
          widget.sessionData.newAllAnswers = 0;
          widget.sessionData.newTime = "00:00:00";
          var answerFutures = <Future>[];

          for (Question question in value) {
            var future = _databaseService
                .getQuestionAnswers(question.questionID!)
                .then((answers) {
              question.answers = answers;
            });
            answerFutures.add(future);
          }
          Future.wait(answerFutures).then((_) {
            _databaseService.updateSession(widget.session).then((value) {
              setState(() {
                _duration = Duration();
                _timer?.cancel();
                _startTimer();
                _updateProgress();
                Navigator.of(context).pop;
              });
            });
          });
        });
      });
    }

    void repeteBadAnswered() {
      _databaseService
          .setQuestionsOutOfSession(
              widget.session.sessionID!, questionsAnsweredGood)
          .then((value) {
        _databaseService
            .setQuestionsUnanswered(widget.session.sessionID!)
            .then((value) {
          _databaseService
              .getSessionUnansweredQuestions(widget.session.sessionID!)
              .then((value) {
            if (widget.session.isMixed) {
              for (var question in value) {
                question.answers.shuffle();
              }
            }
            widget.session.goodAnswers = 0;
            widget.session.badAnswers = 0;
            widget.session.allAnswers = value.length;
            widget.session.questions = value;
            widget.sessionData.newGoodAnswers = 0;
            widget.sessionData.newBadAnswers = 0;
            widget.sessionData.newAllAnswers = 0;
            widget.sessionData.newTime = "00:00:00";
            var answerFutures = <Future>[];

            for (Question question in value) {
              var future = _databaseService
                  .getQuestionAnswers(question.questionID!)
                  .then((answers) {
                question.answers = answers;
              });
              answerFutures.add(future);
            }
            Future.wait(answerFutures).then((_) {
              _databaseService.updateSession(widget.session).then((value) {
                setState(() {
                  _duration = Duration();
                  _timer?.cancel();
                  _startTimer();
                  _updateProgress();
                  Navigator.of(context).pop;
                });
              });
            });
          });
        });
      });
    }

    if (questions.isEmpty) {
      _timer?.cancel();

      return SessionFinishScreen(
        session: widget.session,
        sessionData: widget.sessionData,
        repeatAll: repeteAll,
        repeatBadAnswers: repeteBadAnswered,
      );
    }

    Question currentQuestion = questions.elementAt(0);

    void setAnswered() {
      setState(() {
        final player = AudioPlayer();
        currentQuestion.isAnswered = true;

        bool isAnsweredCorrectly;

        if (currentQuestion.type == QuestionType.open ||
            widget.session.type == QuestionType.open) {
          isAnsweredCorrectly = currentQuestion.isAnsweredCorrectly;
        } else {
          isAnsweredCorrectly = true;
          for (int i = 0; i < currentQuestion.answers.length; i++) {
            if (currentQuestion.answers[i].isSelected !=
                currentQuestion.answers[i].isCorrect) {
              isAnsweredCorrectly = false;
              break;
            }
          }
          if (isAnsweredCorrectly) {
            player
                .setSource(AssetSource('sounds/good.mp3'))
                .then((value) => player.resume());
          } else {
            player
                .setSource(AssetSource('sounds/bad.mp3'))
                .then((value) => player.resume());
          }
        }
      });
    }

    void nextQuestion() {
      bool isAnsweredCorrectly;
      final player = AudioPlayer();

      if (currentQuestion.type == QuestionType.open ||
          widget.session.type == QuestionType.open) {
        isAnsweredCorrectly = currentQuestion.isAnsweredCorrectly;
        if (isAnsweredCorrectly) {
          player
              .setSource(AssetSource('sounds/good.mp3'))
              .then((value) => player.resume());
        } else {
          player
              .setSource(AssetSource('sounds/bad.mp3'))
              .then((value) => player.resume());
        }
      } else {
        isAnsweredCorrectly = true;
        for (int i = 0; i < currentQuestion.answers.length; i++) {
          if (currentQuestion.answers[i].isSelected !=
              currentQuestion.answers[i].isCorrect) {
            isAnsweredCorrectly = false;
            break;
          }
        }
      }

      if (isAnsweredCorrectly) {
        widget.session.goodAnswers++;
        widget.sessionData.newGoodAnswers++;
        questionsAnsweredGood.add(questions.elementAt(0));
      } else {
        widget.session.badAnswers++;
        widget.sessionData.newBadAnswers++;
      }

      widget.sessionData.newAllAnswers++;

      _databaseService.updateSession(widget.session).then(
            (value) => _databaseService
                .setQuestionAnswered(currentQuestion.questionID!)
                .then(
              (value) {
                questions.removeAt(0);
                if (questions.isNotEmpty) {
                  _updateProgress();
                } else {
                  final player = AudioPlayer();
                  player
                      .setSource(AssetSource('sounds/finish.mp3'))
                      .then((value) => player.resume());
                }
                setState(() {});
              },
            ),
          );
    }

    double portraitToolbarHeight = 0.06;
    double portraitLinearProgressIndicatorHeight = 0.01;
    double portraitQuestionContainerHeight = 0.26;
    double portraitPhotoContainerHeight = 0.20;
    double portraitAnswerContainerHeight = 0.36;
    double portraitBottomBarHeight = 0.068;

    double landscapeToolbarHeight = 0.12;
    double landscapeLinearProgressIndicatorHeight = 0.025;
    double landscapeQuestionAnswersContainerHeight = 0.62;
    double landscapeBottomBarHeight = 0.1471;

    void showOptions(context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OptionScreen()),
      ).then((value) {
        setState(() {});
      });
    }

    //
    return OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.velocity.pixelsPerSecond.dx > 1500 ||
              details.velocity.pixelsPerSecond.dx < -1500) {
            currentQuestion.isAnswered ? nextQuestion() : setAnswered();
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height *
                (orientation == Orientation.portrait
                    ? portraitToolbarHeight
                    : landscapeToolbarHeight),
            title: Center(
                child: Text(
              widget.session.title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            )),
            backgroundColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: IconButton(
                    onPressed: () => showOptions(context),
                    icon: Icon(Icons.settings)),
              )
            ],
          ),
          body: orientation == Orientation.portrait
              ? Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height *
                              portraitLinearProgressIndicatorHeight,
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.inversePrimary),
                          ),
                        ),
                        Container(
                          // color: Theme.of(context).colorScheme.error,
                          height: MediaQuery.of(context).size.height *
                              portraitQuestionContainerHeight,
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: Center(
                            child:
                                QuestionScrollView(question: currentQuestion),
                          ),
                        ),
                        if (currentQuestion.photoPath != null)
                          Container(
                            // color: Theme.of(context).colorScheme.background,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: MediaQuery.of(context).size.height *
                                portraitPhotoContainerHeight,
                            child: Center(
                              child: ImageContainer(
                                imagePath: currentQuestion.photoPath!.trim(),
                              ),
                            ),
                          ),
                        Container(
                          // color: Theme.of(context).colorScheme.inversePrimary,
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          height: MediaQuery.of(context).size.height *
                              (currentQuestion.photoPath != null
                                  ? portraitAnswerContainerHeight
                                  : portraitAnswerContainerHeight +
                                      portraitPhotoContainerHeight),
                          child: Center(
                            child: AnswersScrollView(
                              question: currentQuestion,
                              session: widget.session,
                              setAnswered: () => setAnswered,
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).colorScheme.background,
                          height: MediaQuery.of(context).size.height *
                              portraitBottomBarHeight,
                          child: Center(
                            child: SessionBottomBar(
                              width: 0.34,
                              session: widget.session,
                              question: currentQuestion,
                              sessionData: widget.sessionData,
                              setAnswered: () => setAnswered,
                              nextQuestion: () => nextQuestion,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const DemoVersionDialog(),
                  ],
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height *
                              landscapeLinearProgressIndicatorHeight,
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.inversePrimary),
                          ),
                        ),
                        Container(
                          // color: Theme.of(context).colorScheme.error,
                          height: MediaQuery.of(context).size.height *
                              landscapeQuestionAnswersContainerHeight,
                          child: Row(
                            children: [
                              currentQuestion.photoPath != null
                                  ? Column(
                                      children: [
                                        Container(
                                          // color: Theme.of(context).colorScheme.error,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              landscapeQuestionAnswersContainerHeight *
                                              0.5,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 8, 10, 8),
                                          child: Center(
                                            child: QuestionScrollView(
                                                question: currentQuestion),
                                          ),
                                        ),
                                        Container(
                                          // color: Theme.of(context)
                                          //     .colorScheme
                                          //     .background,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 8),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              landscapeQuestionAnswersContainerHeight *
                                              0.5,
                                          child: Center(
                                            child: ImageContainer(
                                              imagePath: currentQuestion
                                                  .photoPath!
                                                  .trim(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      // color: Theme.of(context).colorScheme.background,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 8, 10, 8),
                                      child: Center(
                                        child: Center(
                                          child: QuestionScrollView(
                                              question: currentQuestion),
                                        ),
                                      ),
                                    ),
                              Container(
                                // color: Theme.of(context).colorScheme.inversePrimary,
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                child: Center(
                                  child: Center(
                                    child: AnswersScrollView(
                                      question: currentQuestion,
                                      session: widget.session,
                                      setAnswered: () => setAnswered,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // color: Theme.of(context).colorScheme.error,
                          height: MediaQuery.of(context).size.height *
                              landscapeBottomBarHeight,
                          child: Center(
                            child: SessionBottomBar(
                              width: 0.30,
                              session: widget.session,
                              question: currentQuestion,
                              sessionData: widget.sessionData,
                              setAnswered: () => setAnswered,
                              nextQuestion: () => nextQuestion,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const DemoVersionDialog(),
                  ],
                ),
        ),
      );
    });
  }
}
