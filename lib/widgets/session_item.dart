import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testownik/models/question_type.dart';

class SessionItem extends StatelessWidget {
  final String title;
  final int goodAnswers;
  final int badAnswers;
  final int allAnswers;
  final String time;
  final String type;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SessionItem({
    super.key,
    required this.title,
    required this.goodAnswers,
    required this.badAnswers,
    required this.allAnswers,
    required this.type,
    required this.time,
    required this.onDelete,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (type == QuestionType.singleChoice) {
      icon = Icons.check_circle;
    } else if (type == QuestionType.multipleChoice) {
      icon = Icons.library_add_check;
    } else {
      icon = Icons.edit_square;
    }

    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
      splashColor: Theme.of(context).colorScheme.inversePrimary,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
              offset: const Offset(2.0, 4.0),
              blurRadius: 4.0,
              spreadRadius: 3.0,
            ), //BoxShadow
          ],
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              textAlign: TextAlign.center,
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: Icon(
                      icon,
                      size: 30,
                    ),
                    onPressed: onLongPress,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                        child: Center(
                          child: Text(
                            "$goodAnswers",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.green),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Center(
                          child: Text(
                            "${badAnswers + goodAnswers}/$allAnswers",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: badAnswers + goodAnswers == allAnswers
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.8),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 61,
                        child: Center(
                          child: Text(
                            "$badAnswers",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 35,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
            Center(
              child: Text(
                time,
                style: GoogleFonts.courierPrime(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
