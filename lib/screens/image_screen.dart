import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testownik/widgets/dialogs/demo_version_dialog.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true, // Set it to false
              minScale: 0.3,
              maxScale: 3,
              child: Center(
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const DemoVersionDialog(),
        ],
      ),
    );
  }
}
