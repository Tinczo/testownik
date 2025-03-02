import 'package:flutter/material.dart';
import 'package:testownik/models/answer.dart';
import 'package:testownik/models/question.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MultiChoiceAnswers extends StatefulWidget {
  const MultiChoiceAnswers({super.key, required this.question});
  final Question question;

  @override
  State<MultiChoiceAnswers> createState() => _MultiChoiceAnswersState();
}

class _MultiChoiceAnswersState extends State<MultiChoiceAnswers> {
  @override
  Widget build(BuildContext context) {
    List<Answer> answers = widget.question.answers;
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.background,
      ),
      child: ListView(
        children: answers
            .map((answer) => MultiAnswerWidget(
                  answer: answer,
                  question: widget.question,
                ))
            .toList(),
      ),
    );
  }
}

class MultiAnswerWidget extends StatefulWidget {
  const MultiAnswerWidget({
    super.key,
    required this.answer,
    required this.question,
  });
  final Answer answer;
  final Question question;

  @override
  State<MultiAnswerWidget> createState() => _MultiAnswerWidgetState();
}

class _MultiAnswerWidgetState extends State<MultiAnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.question.isAnswered
          ? () {}
          : () {
              setState(() {
                widget.answer.isSelected = !widget.answer.isSelected;
              });
            },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.question.isAnswered
              ? (widget.answer.isCorrect && widget.answer.isSelected
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : (widget.answer.isSelected
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : (widget.answer.isCorrect
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.7))))
              : (widget.answer.isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.6)
                  : Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.7)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(widget.answer.isSelected
                  ? FontAwesomeIcons.squareCheck
                  : FontAwesomeIcons.square),
            ),
            Flexible(
              child: Text(widget.answer.answer,
                  style: Theme.of(context).textTheme.displaySmall!,
                  textAlign: TextAlign.left),
            ),
          ],
        ),
      ),
    );
  }
}
