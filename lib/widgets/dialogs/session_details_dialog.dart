import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/services/database_sevice.dart';

class SessionDetailsDialog extends StatefulWidget {
  const SessionDetailsDialog({super.key, required this.session});
  final Session session;

  @override
  State<SessionDetailsDialog> createState() => _SessionDetailsDialogState();
}

class _SessionDetailsDialogState extends State<SessionDetailsDialog> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController titleController = TextEditingController();
  bool isOptionAlreadySelected = false;

  String type = '';

  void resetSession() {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    _databaseService.setAllQuestionsInSession(widget.session.sessionID!).then(
      (value) {
        _databaseService.setQuestionsUnanswered(widget.session.sessionID!).then(
          (value) {
            widget.session.title = titleController.text;
            widget.session.type = type;
            _databaseService
                .getSessionUnansweredQuestions(widget.session.sessionID!)
                .then(
              (value) {
                widget.session.goodAnswers = 0;
                widget.session.badAnswers = 0;
                widget.session.allAnswers = value.length;
                _databaseService
                    .updateSession(widget.session)
                    .then((value) => Navigator.of(context).pop(true));
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.session.title);
  }

  @override
  void dispose() {
    // Zawsze pamiętaj, aby posprzątać kontrolery po sobie
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    type = widget.session.type;
    return StatefulBuilder(
      // Użycie StatefulBuilder do zarządzania stanem lokalnym
      builder: (BuildContext context, StateSetter setState) {
        return MediaQuery(
          data: mediaQueryData.copyWith(viewInsets: EdgeInsets.zero),
          child: AlertDialog(
            scrollable: true,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            shadowColor: Theme.of(context).colorScheme.shadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            content: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        controller: titleController,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        decoration: InputDecoration(
                            hintText: 'Wpisz nazwę bazy...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 136,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 70,
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                child: Text(
                                  "${widget.session.goodAnswers}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: Colors.green, fontSize: 30),
                                ),
                              ),
                            ),
                            Text(
                              "${widget.session.badAnswers + widget.session.goodAnswers}/${widget.session.allAnswers}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 33,
                                    color: widget.session.badAnswers +
                                                widget.session.goodAnswers ==
                                            widget.session.allAnswers
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withOpacity(0.8),
                                  ),
                            ),
                            SizedBox(
                              width: 70,
                              child: Center(
                                child: Text(
                                  "${widget.session.badAnswers}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.red,
                                        fontSize: 30,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Center(
                            child: Text(
                              widget.session.time,
                              style: GoogleFonts.courierPrime(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Typ pytań',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 50,
                                ),
                                IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      type = 'single_choice';
                                    })
                                  },
                                  icon: type == 'single_choice'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_unchecked),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(
                                  Icons.library_add_check,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 50,
                                ),
                                IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      type = 'multi_choice';
                                    })
                                  },
                                  icon: type == 'multi_choice'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_unchecked),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(
                                  Icons.edit_square,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 50,
                                ),
                                IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      type = 'open_question';
                                    })
                                  },
                                  icon: type == 'open_question'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_unchecked),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: resetSession,
                      splashColor: Theme.of(context).colorScheme.inversePrimary,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow
                                  .withOpacity(0.05),
                              offset: const Offset(1.0, 2.0),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.13),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Zresetuj bazę',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                          splashColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.36,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.001),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .shadow
                                      .withOpacity(0.05),
                                  offset: const Offset(1.0, 2.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                              ],
                              color: Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Anuluj',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ),
                        InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            if (isOptionAlreadySelected) {
                              return;
                            }
                            isOptionAlreadySelected = true;
                            widget.session.title = titleController.text;
                            widget.session.type = type;
                            _databaseService.updateSession(widget.session);
                            Navigator.of(context).pop(true);
                          },
                          splashColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.36,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.001),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .shadow
                                      .withOpacity(0.05),
                                  offset: const Offset(1.0, 2.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                              ],
                              color: Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Zapisz',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
