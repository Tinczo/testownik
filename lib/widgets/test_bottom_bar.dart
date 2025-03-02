import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testownik/models/question.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/models/session_new_data.dart';

class SessionBottomBar extends StatefulWidget {
  const SessionBottomBar(
      {super.key,
      required this.session,
      required this.sessionData,
      required this.setAnswered,
      required this.width,
      required this.question,
      required this.nextQuestion});

  final Session session;
  final Question question;
  final NewSessionData sessionData;
  final Function setAnswered;
  final Function nextQuestion;
  final double width;

  @override
  State<SessionBottomBar> createState() => _SessionBottomBarState();
}

class _SessionBottomBarState extends State<SessionBottomBar> {
  bool isLeftHandedMode = false;

  double pointsBoxLength(point) {
    int length = (point.toString().length + 1) * 10;
    return length.toDouble();
  }

  void switchHandMode() {
    setState(() {
      isLeftHandedMode = !isLeftHandedMode;
    });
    _saveHandMode();
  }

  Future<void> _loadHandMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLeftHandedMode = prefs.getBool('isLeftHandedMode') ?? false;
    });
  }

  Future<void> _saveHandMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLeftHandedMode', isLeftHandedMode);
  }

  @override
  void initState() {
    super.initState();
    _loadHandMode();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onBackground,
        );

    return isLeftHandedMode
        ? Container(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * widget.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ElevatedButton(
                      onPressed: widget.question.isAnswered
                          ? widget.nextQuestion()
                          : widget.setAnswered(),
                      onLongPress: switchHandMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      child: Text(
                        widget.question.isAnswered ? "Następne" : " Sprawdź ",
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.32,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width:
                                  pointsBoxLength(widget.session.goodAnswers),
                              child: Text(
                                "${widget.session.goodAnswers}",
                                style: textStyle.copyWith(color: Colors.green),
                                textAlign: TextAlign.right,
                              )),
                          SizedBox(
                              width:
                                  pointsBoxLength(widget.session.goodAnswers),
                              child: Text(
                                "+${widget.sessionData.newGoodAnswers}",
                                style: textStyle.copyWith(
                                    color: Colors.green.withOpacity(0.6)),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers +
                                  widget.session.goodAnswers),
                              child: Text(
                                "${widget.session.badAnswers + widget.session.goodAnswers}",
                                style: textStyle,
                                textAlign: TextAlign.right,
                              )),
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers +
                                  widget.session.goodAnswers),
                              child: Text(
                                "+${widget.sessionData.newAllAnswers}",
                                style: textStyle.copyWith(
                                    color: textStyle.color!.withOpacity(0.6)),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers),
                              child: Text(
                                "${widget.session.badAnswers}",
                                style: textStyle.copyWith(color: Colors.red),
                                textAlign: TextAlign.right,
                              )),
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers),
                              child: Text(
                                "+${widget.sessionData.newBadAnswers}",
                                style: textStyle.copyWith(
                                    color: Colors.red.withOpacity(0.6)),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * widget.width,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            widget.session.time,
                            style: GoogleFonts.courierPrime().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            textAlign: TextAlign.right,
                          )),
                      SizedBox(
                          width: 100,
                          child: Text(
                            "+${widget.sessionData.newTime}",
                            style: GoogleFonts.courierPrime().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * widget.width,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            widget.session.time,
                            style: GoogleFonts.courierPrime().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            textAlign: TextAlign.right,
                          )),
                      SizedBox(
                          width: 100,
                          child: Text(
                            "+${widget.sessionData.newTime}",
                            style: GoogleFonts.courierPrime().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.32,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width:
                                  pointsBoxLength(widget.session.goodAnswers),
                              child: Text(
                                "${widget.session.goodAnswers}",
                                style: textStyle.copyWith(color: Colors.green),
                                textAlign: TextAlign.right,
                              )),
                          SizedBox(
                              width:
                                  pointsBoxLength(widget.session.goodAnswers),
                              child: Text(
                                "+${widget.sessionData.newGoodAnswers}",
                                style: textStyle.copyWith(
                                    color: Colors.green.withOpacity(0.6)),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers +
                                  widget.session.goodAnswers),
                              child: Text(
                                "${widget.session.badAnswers + widget.session.goodAnswers}",
                                style: textStyle,
                                textAlign: TextAlign.right,
                              )),
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers +
                                  widget.session.goodAnswers),
                              child: Text(
                                "+${widget.sessionData.newAllAnswers}",
                                style: textStyle.copyWith(
                                    color: textStyle.color!.withOpacity(0.6)),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers),
                              child: Text(
                                "${widget.session.badAnswers}",
                                style: textStyle.copyWith(color: Colors.red),
                                textAlign: TextAlign.right,
                              )),
                          SizedBox(
                              width: pointsBoxLength(widget.session.badAnswers),
                              child: Text(
                                "+${widget.sessionData.newBadAnswers}",
                                style: textStyle.copyWith(
                                    color: Colors.red.withOpacity(0.6)),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * widget.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ElevatedButton(
                      onPressed: widget.question.isAnswered
                          ? widget.nextQuestion()
                          : widget.setAnswered(),
                      onLongPress: switchHandMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      child: Text(
                        widget.question.isAnswered ? "Następne" : " Sprawdź ",
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
