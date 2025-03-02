import 'package:flutter/material.dart';
import 'package:testownik/models/question.dart';

class OpenAnswer extends StatefulWidget {
  const OpenAnswer({
    super.key,
    required this.question,
    required this.setAnswered,
  });
  final Question question;
  final Function setAnswered;

  @override
  State<OpenAnswer> createState() => _OpenAnswerState();
}

class _OpenAnswerState extends State<OpenAnswer> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    String answer = "";

    for (var i = 0; i < widget.question.answers.length; i++) {
      if (widget.question.answers[i].isCorrect) {
        answer += "- ${widget.question.answers[i].answer}\n";
      }
    }
    return InkWell(
      onTap: widget.question.isAnswered
          ? () {
              setState(() {
                widget.question.isAnsweredCorrectly =
                    !widget.question.isAnsweredCorrectly;
              });
            }
          : widget.setAnswered(),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.question.isAnswered
              ? (widget.question.isAnsweredCorrectly
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.tertiaryContainer)
              : Theme.of(context).colorScheme.background,
        ),
        child: widget.question.isAnswered
            ? ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                  radius: Radius.circular(10),
                  thickness: MaterialStateProperty.all(8.0),
                  thumbColor: MaterialStateProperty.all(Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.3)),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 17, 0),
                      child: Text(answer,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  'Kliknij, aby odsłonić odpowiedź',
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
              ),
      ),
    );
  }
}
