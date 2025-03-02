import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:testownik/models/answer.dart';
import 'package:testownik/models/question.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/services/database_sevice.dart';

Future<void> getFilePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.manageExternalStorage.request();
  }
}

List<Question> processFiles(String selectedDirectory) {
  Directory directory = Directory(selectedDirectory);
  List<String> questionPaths = [];

  directory.listSync(recursive: true).forEach((element) {
    if (element.path.endsWith(".txt")) {
      questionPaths.add(element.path);
    }
  });

  List<Question> questions = [];

  for (String path in questionPaths) {
    try {
      File file = File(path);
      String fileText = file.readAsStringSync();
      List<String> fileLines = fileText.split('\n');

      String header = fileLines[0];
      List<String> headerParts = header.split(';');
      String questionCode = headerParts[0];
      String correctAnswersCode = questionCode.substring(2).trim();
      int answerCodelength = correctAnswersCode.length;
      List<int> correctAnswersIndices = [];
      int correctAnswersCount = 0;
      for (int i = 0; i < answerCodelength; i++) {
        String answerCode = correctAnswersCode[i];
        int isCorrect = int.parse(answerCode);
        correctAnswersIndices.add(isCorrect);
        correctAnswersCount += isCorrect;
      }

      String? photoPath;
      if (headerParts.length > 1 && headerParts[1].startsWith('img=')) {
        photoPath = headerParts[1].substring(4);
        photoPath = "$selectedDirectory/img/$photoPath".trim();
        if (!File(photoPath).existsSync()) continue;
      }

      String questionLine = fileLines[1];
      int dotIndex = questionLine.indexOf('.');
      int questionNumber = int.parse(questionLine.substring(0, dotIndex));
      String questionText = questionLine.substring(dotIndex + 1).trim();

      String type;
      if (correctAnswersCode.isEmpty) {
        continue;
      } else if (correctAnswersCode.length == 1) {
        type = 'open_question';
      } else if (correctAnswersCount == 1) {
        type = 'single_choice';
      } else {
        type = 'multi_choice';
      }

      Question question = Question(
        questionNumber: questionNumber,
        question: questionText,
        type: type,
        photoPath: photoPath,
      );

      // Read answers
      for (int i = 2; i < fileLines.length; i++) {
        String answerLine = fileLines[i].trim();
        if (answerLine.isEmpty) continue;

        int firstBracketIndex = answerLine.indexOf(')');
        String subStringWithLetter = answerLine.substring(0, firstBracketIndex);
        String letter = subStringWithLetter[subStringWithLetter.length - 1];
        String answerText = answerLine.substring(firstBracketIndex + 1).trim();
        bool isCorrect = correctAnswersIndices[i - 2] == 1 ? true : false;

        Answer answer = Answer(
          questionLetter: letter,
          answer: answerText,
          isCorrect: isCorrect,
        );
        question.answers.add(answer);
      }
      if (question.answers.isEmpty) {
        continue;
      }
      questions.add(question);
    } catch (e) {
      print("${e.toString()} in $path");
    }
    if (questions.length == 999) break;
  }

  return questions;
}

Future addSessionWithQuestionsAndAnswers(Session session) async {
  final DatabaseService databaseService = DatabaseService.instance;

  databaseService.addSession(session).then((sessionID) {
    // Zapisz ID sesji w sesji i iteruj przez pytania
    session.sessionID = sessionID;
    for (Question question in session.questions) {
      question.sessionID = sessionID; // Przypisz ID sesji do pytania
      databaseService.addQuestion(question).then((questionID) {
        // Zapisz ID pytania w pytaniu i iteruj przez odpowiedzi
        question.questionID = questionID;
        for (Answer answer in question.answers) {
          answer.questionID = questionID; // Przypisz ID pytania do odpowiedzi
          databaseService.addAnswer(answer);
        }
      });
    }
  });
}
