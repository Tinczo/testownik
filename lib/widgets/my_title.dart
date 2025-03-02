// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTitle extends StatelessWidget {
  const MyTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Testownik',
        style: GoogleFonts.angkor(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 0.5,
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
            ),
          ],
        ));
  }
}
