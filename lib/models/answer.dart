class Answer {
  int? answerID;
  int? questionID;
  final String questionLetter;
  final String answer;
  final bool isCorrect;
  bool isSelected = false;

  Answer({
    this.answerID,
    this.questionID,
    required this.questionLetter,
    required this.answer,
    required this.isCorrect,
  });

  @override
  String toString() {
    if (answerID != null && questionID != null) {
      return 'qID: $questionID; aID: $answerID; $questionLetter. $answer $isCorrect';
    }
    return '$questionLetter. $answer $isCorrect';
  }
}
