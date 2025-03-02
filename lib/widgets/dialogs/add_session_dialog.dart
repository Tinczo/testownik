import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:testownik/models/question.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/utils/utils.dart';

class AddSessionDialog extends StatefulWidget {
  const AddSessionDialog({super.key});

  @override
  State<AddSessionDialog> createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<AddSessionDialog> {
  TextEditingController titleController = TextEditingController();
  bool isOptionAlreadySelected = false;

  bool isMixed = false;
  String type = "single_choice";
  Session session = Session(
    title: "Nowa sesja",
    type: "single_choice",
    isMixed: false,
    goodAnswers: 0,
    badAnswers: 0,
    allAnswers: 0,
    time: "00:00:00",
  );

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
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
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
                    children: <Widget>[
                      Text(
                        'Mieszaj pytania',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                              Text(
                                'Nie',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              IconButton(
                                onPressed: () => {
                                  setState(() {
                                    isMixed = false;
                                  })
                                },
                                icon: isMixed == false
                                    ? Icon(Icons.radio_button_checked)
                                    : Icon(Icons.radio_button_unchecked),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Tak',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              IconButton(
                                onPressed: () => {
                                  setState(() {
                                    isMixed = true;
                                  })
                                },
                                icon: isMixed == true
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                    onTap: () async {
                      if (isOptionAlreadySelected) {
                        return;
                      }
                      isOptionAlreadySelected = true;
                      getFilePermission();
                      String? selectedDirectory =
                          await FilePicker.platform.getDirectoryPath();

                      if (selectedDirectory == null) {
                        return;
                      }

                      List<Question> questions =
                          processFiles(selectedDirectory);

                      session.questions = questions;
                      isOptionAlreadySelected = false;
                      setState(() {});
                    },
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
                        'Ścieżka do bazy...',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                          if (isOptionAlreadySelected) {
                            return;
                          }
                          isOptionAlreadySelected = true;
                          Navigator.of(context).pop();
                          isOptionAlreadySelected = false;
                        },
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
                              width: 2,
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
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ),
                      session.questions.isEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.36,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  width: 2,
                                ),
                                color: Theme.of(context)
                                    .colorScheme
                                    .background
                                    .withOpacity(0.5),
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
                                          .inversePrimary,
                                    ),
                              ),
                            )
                          : InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onTap: () {
                                if (session.questions.isEmpty) {
                                  return;
                                }

                                if (isOptionAlreadySelected) {
                                  return;
                                }
                                isOptionAlreadySelected = true;

                                session.title = titleController.text;
                                session.type = type;
                                session.allAnswers = session.questions.length;
                                session.isMixed = isMixed;
                                addSessionWithQuestionsAndAnswers(session).then(
                                    (value) => Navigator.of(context).pop());
                                isOptionAlreadySelected = false;

                                // _databaseService.addSession(session);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.36,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error
                                        .withOpacity(0.001),
                                    width: 2,
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
    });
  }
}
