import 'package:flutter/material.dart';

class DemoVersionDialog extends StatelessWidget {
  const DemoVersionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true, // sprawia, że dotyk przechodzi do elementów pod spodem
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "To jest demo wersja aplikacji.\nPełna wersja testownika jest dostępna w sklepie Google Play i App Store.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha(100),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
