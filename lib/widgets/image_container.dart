import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testownik/screens/image_screen.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageScreen(imagePath: widget.imagePath),
          ),
        );
      },
      splashColor:
          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
      child: Image.file(
        File(widget.imagePath),
        fit: BoxFit.cover,
      ),
    );
  }
}
