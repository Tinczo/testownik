import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testownik/models/question.dart';
import 'package:testownik/models/question_type.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/widgets/answersScrollViews/multi_choice_answers.dart';
import 'package:testownik/widgets/answersScrollViews/open_answer.dart';
import 'package:testownik/widgets/answersScrollViews/single_choice_answers.dart';

class AnswersScrollView extends StatefulWidget {
  const AnswersScrollView({
    super.key,
    required this.question,
    required this.session,
    required this.setAnswered,
  });
  final Question question;
  final Session session;
  final Function setAnswered;

  @override
  State<AnswersScrollView> createState() => _AnswersScrollViewState();
}

class _AnswersScrollViewState extends State<AnswersScrollView> {
  int getWeight(String type) {
    switch (type) {
      case QuestionType.singleChoice:
        return 0;
      case QuestionType.multipleChoice:
        return 1;
      case QuestionType.open:
        return 2;
      default:
        return -1; // Nieznany typ
    }
  }

  @override
  Widget build(BuildContext context) {
    int questionWeight = getWeight(widget.question.type);
    int sessionWeight = getWeight(widget.session.type);

    int maxWeight = max(questionWeight, sessionWeight);

    switch (maxWeight) {
      case 0: // Single Choice Logic
        return SingleChoiceAnswers(question: widget.question);
      case 1: // Multiple Choice Logic
        return MultiChoiceAnswers(question: widget.question);
      case 2: // Open Question Logic
        return OpenAnswer(
          question: widget.question,
          setAnswered: widget.setAnswered,
        );
      default:
        print("Unknown functionality");
    }

    return Placeholder();
  }
}
