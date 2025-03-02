import 'package:flutter/material.dart';
import 'package:testownik/models/answer.dart';
import 'package:testownik/models/question.dart';

class SingleChoiceAnswers extends StatefulWidget {
  const SingleChoiceAnswers({super.key, required this.question});
  final Question question;

  @override
  State<SingleChoiceAnswers> createState() => _SingleChoiceAnswersState();
}

class _SingleChoiceAnswersState extends State<SingleChoiceAnswers> {
  int selectedAnswer = 0;

  void selectAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Answer> answers = widget.question.answers;
    if (selectedAnswer > answers.length - 1) {
      selectedAnswer = 0;
    }
    for (int i = 0; i < answers.length; i++) {
      answers[i].isSelected = i == selectedAnswer;
    }
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
            .map((answer) => SingleAnswerWidget(
                  question: widget.question,
                  answer: answer,
                  index: answers.indexOf(answer),
                  selectAnswer: selectAnswer,
                ))
            .toList(),
      ),
    );
  }
}

class SingleAnswerWidget extends StatefulWidget {
  const SingleAnswerWidget(
      {super.key,
      required this.answer,
      required this.index,
      required this.selectAnswer,
      required this.question});
  final Question question;
  final Answer answer;
  final int index;
  final Function(int) selectAnswer;

  @override
  State<SingleAnswerWidget> createState() => _SingleAnswerWidgetState();
}

class _SingleAnswerWidgetState extends State<SingleAnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.question.isAnswered
          ? () {}
          : () {
              widget.selectAnswer(widget.index);
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
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked),
            ),
            Flexible(
              child: Text(widget.answer.answer,
                  style: Theme.of(context).textTheme.displaySmall!),
            ),
          ],
        ),
      ),
    );
  }
}
