import 'package:testownik/models/question.dart';

class Session {
  int? sessionID;
  String title;
  String type;
  bool isMixed;
  int goodAnswers;
  int badAnswers;
  int allAnswers;
  String time;
  List<Question> questions = [];

  Session({
    this.sessionID,
    required this.title,
    required this.type,
    required this.isMixed,
    required this.goodAnswers,
    required this.badAnswers,
    required this.allAnswers,
    required this.time,
  });

  int goodAnswer() {
    goodAnswers = goodAnswers + 1;
    return goodAnswers;
  }

  int badAnswer() {
    badAnswers = badAnswers + 1;
    return badAnswers;
  }

  void setTime(String newTime) {
    time = newTime;
  }

  @override
  String toString() {
    if (sessionID != null) {
      return 'sID: $sessionID, $title, $type, $goodAnswers, $badAnswers, $allAnswers, $time';
    }
    return 'Session: $title, $type, $goodAnswers, $badAnswers, $allAnswers, $time';
  }
}
