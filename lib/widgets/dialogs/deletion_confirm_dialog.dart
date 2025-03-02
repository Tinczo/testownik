import 'package:flutter/material.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/services/database_sevice.dart';

class DeletionConfirmDialog extends StatefulWidget {
  const DeletionConfirmDialog({super.key, required this.session});
  final Session session;

  @override
  State<DeletionConfirmDialog> createState() => _DeletionConfirmDialogState();
}

class _DeletionConfirmDialogState extends State<DeletionConfirmDialog> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController titleController = TextEditingController();
  bool isOptionAlreadySelected = false;

  void onTapDecline() {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    Navigator.of(context).pop(false);
    isOptionAlreadySelected = false;
  }

  void onTapDelete() {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;

    _databaseService.deleteSession(widget.session.sessionID!).then((value) {
      Navigator.of(context).pop(true);
      isOptionAlreadySelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      // Użycie StatefulBuilder do zarządzania stanem lokalnym
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                  child: Text(
                    'Czy na pewno chcesz usunąć tę bazę?',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
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
                        onTap: onTapDecline,
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
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
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
                        onTap: onTapDelete,
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
                            'Usuń',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
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
        );
      },
    );
  }
}
