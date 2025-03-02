import 'package:flutter/material.dart';
import 'package:testownik/models/question.dart';
import 'package:testownik/models/session_new_data.dart';
import 'package:testownik/screens/options_screen.dart';
import 'package:testownik/screens/test_screen.dart';
import 'package:testownik/services/database_sevice.dart';
import 'package:testownik/widgets/add_session_button.dart';
import 'package:testownik/widgets/dialogs/deletion_confirm_dialog.dart';
import 'package:testownik/widgets/dialogs/demo_version_dialog.dart';
import 'package:testownik/widgets/my_title.dart';
import 'package:testownik/widgets/dialogs/session_details_dialog.dart';
import 'package:testownik/widgets/session_item.dart';
import 'package:testownik/widgets/dialogs/add_session_dialog.dart';
import 'package:testownik/models/session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  bool isOptionAlreadySelected = false;

  void addSession() {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    showDialog(
      context: context,
      builder: (context) => AddSessionDialog(),
    ).then((result) {
      isOptionAlreadySelected = false;
      setState(() {});
    });
  }

  void sessionDetails(Session session) {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    showDialog(
      context: context,
      builder: (context) => SessionDetailsDialog(
        session: session,
      ),
    ).then((result) {
      isOptionAlreadySelected = false;
      if (result == true) {
        setState(() {});
      }
    });
  }

  void confirmSessionDeletion(Session session) {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;

    showDialog(
      context: context,
      builder: (context) => DeletionConfirmDialog(
        session: session,
      ),
    ).then(
      (result) {
        isOptionAlreadySelected = false;
        if (result == true) {
          setState(() {});
        }
      },
    );
  }

  void navigateToSessionTest(BuildContext context, Session session) {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    _databaseService
        .getSessionUnansweredQuestions(session.sessionID!)
        .then((questions) {
      session.questions = questions;
      var answerFutures = <Future>[];

      for (Question question in questions) {
        var future = _databaseService
            .getQuestionAnswers(question.questionID!)
            .then((answers) {
          if (session.isMixed) {
            answers.shuffle();
          }
          question.answers = answers;
        });
        answerFutures.add(future);
      }

      Future.wait(answerFutures).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionTestScreen(
              session: session,
              sessionData: NewSessionData(
                newGoodAnswers: 0,
                newBadAnswers: 0,
                newAllAnswers: 0,
                newTime: '00:00:00',
              ),
            ),
          ),
        ).then((value) => setState(() {
              isOptionAlreadySelected = false;
            }));
      });
    });
  }

  void showOptions(context) {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OptionScreen()),
    ).then((value) {
      setState(() {
        isOptionAlreadySelected = false;
      });
    });
  }

  // void deleteBase() {
  //   _databaseService.clearDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height *
              (orientation == Orientation.portrait ? 0.06 : 0.12),
          backgroundColor:
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: IconButton(
                  onPressed: () => showOptions(context),
                  icon: Icon(
                    Icons.settings,
                    // color: Theme.of(context).colorScheme.inversePrimary,
                  )),
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: deleteBase,
        //   child: Icon(Icons.add),
        // ),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        body: Stack(
          children: [
            FutureBuilder<List<Session>>(
              future:
                  _databaseService.getSessions(), // funkcja, która ładuje sesje
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(child: MyTitle()),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: AddSessionButton(
                          onTapCallback: () => addSession,
                        ),
                      ),
                      // Expanded(child: Center(child: RefreshProgressIndicator())),
                    ],
                  ); // Wyświetlanie loadera
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      const SizedBox(height: 40),
                      Center(child: MyTitle()),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: AddSessionButton(
                          onTapCallback: () => addSession,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(child: Text('Error: ${snapshot.error}')),
                    ],
                  );
                } else {
                  return ListView(
                    children: <Widget>[
                      const SizedBox(height: 40),
                      Center(child: MyTitle()),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: AddSessionButton(
                          onTapCallback: () => addSession,
                        ),
                      ),
                      ...snapshot.data!.map((session) => Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: SessionItem(
                              title: session.title,
                              goodAnswers: session.goodAnswers,
                              badAnswers: session.badAnswers,
                              allAnswers: session.allAnswers,
                              type: session.type,
                              time: session.time,
                              onDelete: () => confirmSessionDeletion(session),
                              onTap: () =>
                                  navigateToSessionTest(context, session),
                              onLongPress: () => sessionDetails(session),
                            ),
                          )),
                      const SizedBox(height: 50),
                    ],
                  );
                }
              },
            ),
            const DemoVersionDialog(),
          ],
        ),
      );
    });
  }
}
