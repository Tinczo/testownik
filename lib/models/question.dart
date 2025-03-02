import 'package:testownik/models/answer.dart';

class Question {
  int? questionID;
  int? sessionID;
  final int questionNumber;
  final String question;
  final String type;
  bool isAnsweredCorrectly = true;
  bool isAnswered = false;
  final String? photoPath;
  List<Answer> answers = [];

  Question({
    this.questionID,
    this.sessionID,
    required this.questionNumber,
    required this.question,
    required this.type,
    this.photoPath,
  });

  @override
  String toString() {
    if (questionID != null && sessionID != null) {
      if (photoPath != null) {
        return 'sID: $sessionID; qID: $questionID; $questionNumber. $question $type $photoPath';
      }
      return 'sID: $sessionID; qID: $questionID; $questionNumber. $question $type';
    }
    if (photoPath != null) {
      return '$questionNumber. $question $type $photoPath';
    }
    return '$questionNumber. $question $type';
  }
}
