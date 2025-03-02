import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testownik/models/answer.dart';
import 'package:testownik/models/question.dart';
import 'package:testownik/models/session.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _sessionsTableName = "sessions";
  final String _sessionsSessionIdColumnName = "sessionID";
  final String _sessionsTitleColumnName = "title";
  final String _sessionsTypeColumnName = "type";
  final String _sessionsIsMixedColumnName = "isMixed";
  final String _sessionsGoodAnswersColumnName = "goodAnswers";
  final String _sessionsBadAnswersColumnName = "badAnswers";
  final String _sessionsAllAnswersColumnName = "allAnswers";
  final String _sessionsTimeColumnName = "time";
  final String _sessionsLastTimeColumnName = "lastTime";

  final String _questionsTableName = "questions";
  final String _questionsQuestionIDColumnName = "questionID";
  final String _questionsSessionIDColumnName = "sessionID";
  final String _questionsQuestionNumberColumnName = "questionNumber";
  final String _questionsQuestionColumnName = "question";
  final String _questionsTypeColumnName = "type";
  final String _questionsIsInSessionColumnName = "isInSession";
  final String _questionsIsAnsweredColumnName = "isAnswered";
  final String _questionsPhotoPathColumnName = "photoPath";

  final String _answersTableName = "answers";
  final String _answersAnswerIDColumnName = "answerID";
  final String _answersQuestionIDColumnName = "questionID";
  final String _answersQuestionLetterColumnName = "questionLetter";
  final String _answersAnswerColumnName = "answer";
  final String _answersIsCorrectColumnName = "isCorrect";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_sessionsTableName (
      $_sessionsSessionIdColumnName INTEGER PRIMARY KEY,
      $_sessionsTitleColumnName TEXT NOT NULL,
      $_sessionsTypeColumnName TEXT NOT NULL,
      $_sessionsIsMixedColumnName INTEGER NOT NULL,
      $_sessionsGoodAnswersColumnName INTEGER NOT NULL,
      $_sessionsBadAnswersColumnName INTEGER NOT NULL,
      $_sessionsAllAnswersColumnName INTEGER NOT NULL,
      $_sessionsTimeColumnName TEXT NOT NULL,
      $_sessionsLastTimeColumnName INTEGER NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_questionsTableName (
      $_questionsQuestionIDColumnName INTEGER PRIMARY KEY,
      $_questionsSessionIDColumnName INTEGER NOT NULL,
      $_questionsQuestionNumberColumnName INTEGER NOT NULL,
      $_questionsQuestionColumnName TEXT NOT NULL,
      $_questionsTypeColumnName TEXT NOT NULL,
      $_questionsIsInSessionColumnName INTEGER NOT NULL,
      $_questionsIsAnsweredColumnName INTEGER NOT NULL,
      $_questionsPhotoPathColumnName TEXT,
      FOREIGN KEY ($_questionsSessionIDColumnName) REFERENCES $_sessionsTableName ($_sessionsSessionIdColumnName) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_answersTableName (
      $_answersAnswerIDColumnName INTEGER PRIMARY KEY,
      $_answersQuestionIDColumnName INTEGER NOT NULL,
      $_answersQuestionLetterColumnName TEXT NOT NULL,
      $_answersAnswerColumnName TEXT NOT NULL,
      $_answersIsCorrectColumnName INTEGER NOT NULL,
      FOREIGN KEY ($_answersQuestionIDColumnName) REFERENCES $_questionsTableName ($_questionsQuestionIDColumnName) ON DELETE CASCADE
    )
  ''');
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
    return database;
  }

  Future<int> addSession(
    Session session,
  ) async {
    final db = await database;
    int id = await db.insert(
      _sessionsTableName,
      {
        _sessionsTitleColumnName: session.title,
        _sessionsTypeColumnName: session.type,
        _sessionsIsMixedColumnName: session.isMixed ? 1 : 0,
        _sessionsGoodAnswersColumnName: session.goodAnswers,
        _sessionsBadAnswersColumnName: session.badAnswers,
        _sessionsAllAnswersColumnName: session.allAnswers,
        _sessionsTimeColumnName: session.time,
        _sessionsLastTimeColumnName: DateTime.now().millisecondsSinceEpoch,
      },
    );
    return id;
  }

  Future<List<Session>> getSessions() async {
    final db = await database;
    final data = await db.query(_sessionsTableName,
        orderBy: '$_sessionsLastTimeColumnName DESC');
    List<Session> sessions = data
        .map(
          (e) => Session(
            sessionID: e["sessionID"] as int,
            title: e["title"] as String,
            type: e["type"] as String,
            isMixed: (e["isMixed"] as int) == 1,
            goodAnswers: e["goodAnswers"] as int,
            badAnswers: e["badAnswers"] as int,
            allAnswers: e["allAnswers"] as int,
            time: e["time"] as String,
          ),
        )
        .toList();
    return sessions;
  }

  Future updateSession(
    Session session,
  ) async {
    final db = await database;
    await db.update(
      _sessionsTableName,
      {
        _sessionsTitleColumnName: session.title,
        _sessionsTypeColumnName: session.type,
        _sessionsGoodAnswersColumnName: session.goodAnswers,
        _sessionsBadAnswersColumnName: session.badAnswers,
        _sessionsAllAnswersColumnName: session.allAnswers,
        _sessionsTimeColumnName: session.time,
        _sessionsLastTimeColumnName: DateTime.now().millisecondsSinceEpoch,
      },
      where: 'sessionID = ?',
      whereArgs: [
        session.sessionID,
      ],
    );
  }

  Future deleteSession(
    int id,
  ) async {
    final db = await database;
    await db.delete(
      _sessionsTableName,
      where: 'sessionID = ?',
      whereArgs: [
        id,
      ],
    );
  }

  Future<int> addQuestion(
    Question question,
  ) async {
    final db = await database;
    int id = await db.insert(
      _questionsTableName,
      {
        _questionsSessionIDColumnName: question.sessionID,
        _questionsQuestionNumberColumnName: question.questionNumber,
        _questionsQuestionColumnName: question.question,
        _questionsTypeColumnName: question.type,
        _questionsIsInSessionColumnName: 1,
        _questionsIsAnsweredColumnName: 0,
        _questionsPhotoPathColumnName: question.photoPath,
      },
    );
    return id;
  }

  Future addQuestions(
    int sessionID,
    List<Question> questions,
  ) async {
    final db = await database;
    for (var question in questions) {
      await db.insert(
        _questionsTableName,
        {
          _questionsSessionIDColumnName: sessionID,
          _questionsQuestionNumberColumnName: question.questionNumber,
          _questionsQuestionColumnName: question.question,
          _questionsTypeColumnName: question.type,
          _questionsIsInSessionColumnName: 1,
          _questionsIsAnsweredColumnName: 0,
          _questionsPhotoPathColumnName: question.photoPath,
        },
      );
    }
  }

  Future<List<Question>> getSessionUnansweredQuestions(int sessionID) async {
    final db = await database;
    final data = await db.query(
      _questionsTableName,
      where: 'sessionID = ? AND isInSession = 1 AND isAnswered = 0',
      orderBy: 'questionNumber',
      whereArgs: [
        sessionID,
      ],
    );
    List<Question> questions = data
        .map((e) => Question(
              questionID: e["questionID"] as int,
              sessionID: e["sessionID"] as int,
              questionNumber: e["questionNumber"] as int,
              question: e["question"] as String,
              type: e["type"] as String,
              photoPath:
                  e["photoPath"] == null ? null : e["photoPath"] as String,
            ))
        .toList();
    return questions;
  }

  Future<List<Question>> getSessionQuestions(int sessionID) async {
    final db = await database;
    final data = await db.query(
      _questionsTableName,
      where: 'sessionID = ? AND isInSession = 1',
      orderBy: 'questionNumber',
      whereArgs: [
        sessionID,
      ],
    );
    List<Question> questions = data
        .map(
          (e) => Question(
            questionID: e["questionID"] as int,
            sessionID: e["sessionID"] as int,
            questionNumber: e["questionNumber"] as int,
            question: e["question"] as String,
            type: e["type"] as String,
            photoPath: e["photoPath"] as String,
          ),
        )
        .toList();
    return questions;
  }

  Future setQuestionAnswered(int questionID) async {
    final db = await database;
    await db.update(
      _questionsTableName,
      {
        _questionsIsAnsweredColumnName: 1,
      },
      where: 'questionID = ?',
      whereArgs: [
        questionID,
      ],
    );
  }

  Future setQuestionUnanswered(int questionID) async {
    final db = await database;
    await db.update(
      _questionsTableName,
      {
        _questionsIsAnsweredColumnName: 0,
      },
      where: 'questionID = ?',
      whereArgs: [
        questionID,
      ],
    );
  }

  Future setQuestionsUnanswered(int sessionID) async {
    final db = await database;
    await db.update(
      _questionsTableName,
      {
        _questionsIsAnsweredColumnName: 0,
      },
      where: 'sessionID = ? AND isInSession = 1',
      whereArgs: [
        sessionID,
      ],
    );
  }

  Future setQuestionsOutOfSession(
      int sessionID, List<Question> questions) async {
    final db = await database;
    for (var question in questions) {
      await db.update(
        _questionsTableName,
        {
          _questionsIsInSessionColumnName: 0,
        },
        where: 'sessionID = ? AND questionID = ?',
        whereArgs: [
          sessionID,
          question.questionID,
        ],
      );
    }
  }

  Future setAllQuestionsInSession(int sessionID) async {
    final db = await database;
    await db.update(
      _questionsTableName,
      {
        _questionsIsInSessionColumnName: 1,
      },
      where: 'sessionID = ?',
      whereArgs: [
        sessionID,
      ],
    );
  }

  Future setQuestionInSession(int questionID) async {
    final db = await database;
    await db.update(
      _questionsTableName,
      {
        _questionsIsInSessionColumnName: 1,
      },
      where: 'questionID = ?',
      whereArgs: [
        questionID,
      ],
    );
  }

  Future setQuestionOutOfSession(int questionID) async {
    final db = await database;
    await db.update(
      _questionsTableName,
      {
        _questionsIsInSessionColumnName: 0,
      },
      where: 'questionID = ?',
      whereArgs: [
        questionID,
      ],
    );
  }

  Future deleteQuestion(int questionID) async {
    final db = await database;
    await db.delete(
      _questionsTableName,
      where: 'questionID = ?',
      whereArgs: [
        questionID,
      ],
    );
  }

  Future<int> addAnswer(
    Answer answer,
  ) async {
    final db = await database;
    int id = await db.insert(
      _answersTableName,
      {
        _answersQuestionIDColumnName: answer.questionID,
        _answersQuestionLetterColumnName: answer.questionLetter,
        _answersAnswerColumnName: answer.answer,
        _answersIsCorrectColumnName: answer.isCorrect ? 1 : 0,
      },
    );
    return id;
  }

  Future<List<Answer>> getQuestionAnswers(int questionID) async {
    final db = await database;
    final data = await db.query(
      _answersTableName,
      where: 'questionID = ?',
      whereArgs: [
        questionID,
      ],
    );
    List<Answer> answers = data
        .map(
          (e) => Answer(
            answerID: e["answerID"] as int,
            questionID: e["questionID"] as int,
            questionLetter: e["questionLetter"] as String,
            answer: e["answer"] as String,
            isCorrect: e["isCorrect"] == 1,
          ),
        )
        .toList();
    return answers;
  }

  Future clearDatabase() async {
    final db = await database;
    await db.delete(_sessionsTableName);
    await db.delete(_questionsTableName);
    await db.delete(_answersTableName);
  }

  Future createDatabase() async {
    final db = await database;
    await _onCreate(db, 1);
  }
}
