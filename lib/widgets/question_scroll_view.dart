import 'package:flutter/material.dart';
import 'package:testownik/models/question.dart';

class QuestionScrollView extends StatefulWidget {
  const QuestionScrollView({super.key, required this.question});
  final Question question;

  @override
  State<QuestionScrollView> createState() => _QuestionScrollViewState();
}

class _QuestionScrollViewState extends State<QuestionScrollView> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.background,
      ),
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all<bool>(true),
          radius: Radius.circular(10),
          thickness: MaterialStateProperty.all(8.0),
          thumbColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.onBackground.withOpacity(0.3)),
        ),
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 17, 0),
              child: Text(
                  "${widget.question.questionNumber}. ${widget.question.question}",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
