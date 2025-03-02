import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testownik/models/session.dart';
import 'package:testownik/models/session_new_data.dart';
import 'package:testownik/screens/options_screen.dart';
import 'package:testownik/widgets/dialogs/demo_version_dialog.dart';

class SessionFinishScreen extends StatefulWidget {
  const SessionFinishScreen(
      {super.key,
      required this.session,
      required this.repeatAll,
      required this.repeatBadAnswers,
      required this.sessionData});
  final Session session;
  final NewSessionData sessionData;
  final Function repeatAll;
  final Function repeatBadAnswers;

  @override
  State<SessionFinishScreen> createState() => _SessionFinishScreenState();
}

class _SessionFinishScreenState extends State<SessionFinishScreen> {
  double portraitToolbarHeight = 0.06;
  double landscapeToolbarHeight = 0.12;
  bool isOptionAlreadySelected = false;

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

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height *
                (orientation == Orientation.portrait
                    ? portraitToolbarHeight
                    : landscapeToolbarHeight),
            backgroundColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: IconButton(
                    onPressed: () => showOptions(context),
                    icon: Icon(Icons.settings)),
              )
            ],
          ),
          body: Stack(children: [
            ListView(
              children: <Widget>[
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'To wszystko!',
                    style: GoogleFonts.angkor(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 0.5,
                          color: Theme.of(context).colorScheme.shadow,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Center(
                    child: Text(
                      widget.session.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Center(
                                  child: Text(
                                    "Liczba pytań",
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
                              Center(
                                child: Text(
                                  "${widget.session.goodAnswers + widget.session.badAnswers}/${widget.session.allAnswers}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 60,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 5, 0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Center(
                                        child: Text(
                                          "Dobrze",
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
                                    Center(
                                      child: Text(
                                        widget.session.goodAnswers.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 60,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Center(
                                        child: Text(
                                          "Źle",
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
                                    Center(
                                      child: Text(
                                        widget.session.badAnswers.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 60,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Text(
                    widget.sessionData.newTime == "00:00:00"
                        ? " "
                        : widget.sessionData.newTime,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.courierPrime(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: InkWell(
                    onTap: () {
                      if (isOptionAlreadySelected) {
                        return;
                      }
                      isOptionAlreadySelected = true;
                      widget.repeatAll();
                      // isOptionAlreadySelected = false;
                    },
                    splashColor: Theme.of(context).colorScheme.onBackground,
                    highlightColor: Theme.of(context).colorScheme.onBackground,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withOpacity(0.15),
                            offset: const Offset(0, 3.0),
                            blurRadius: 4.0,
                            spreadRadius: 3.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Center(
                          child: Text(
                            "Powtórz",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: InkWell(
                    onTap: () {
                      if (isOptionAlreadySelected) {
                        return;
                      }
                      isOptionAlreadySelected = true;
                      widget.repeatBadAnswers();
                      // isOptionAlreadySelected = false;
                    },
                    splashColor: Theme.of(context).colorScheme.onBackground,
                    highlightColor: Theme.of(context).colorScheme.onBackground,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withOpacity(0.15),
                            offset: const Offset(0, 3.0),
                            blurRadius: 4.0,
                            spreadRadius: 3.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Center(
                          child: Text(
                            "Powtórz złe odpowiedzi",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
            const DemoVersionDialog(),
          ]),
        );
      },
    );
  }
}
