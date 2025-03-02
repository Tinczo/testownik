import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSessionButton extends StatelessWidget {
  const AddSessionButton({
    super.key,
    required this.onTapCallback,
  });

  final Function onTapCallback;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: onTapCallback(),
      splashColor:
          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
      child: DottedBorder(
        strokeWidth: 6,
        dashPattern: [
          15,
          10,
        ],
        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
        borderType: BorderType.RRect,
        radius: Radius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          height: 100,
          child: Center(
            child: Text('Dodaj nową bazę',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
          ),
        ),
      ),
    );
  }
}
