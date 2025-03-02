import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testownik/provider/theme_settings.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:testownik/widgets/dialogs/demo_version_dialog.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  double portraitToolbarHeight = 0.06;
  double landscapeToolbarHeight = 0.12;
  bool isOptionAlreadySelected = false;

  bool isDarkMode = false;
  Color pickerColor = Color.fromARGB(255, 255, 182, 0);
  Color currentColor = Color.fromARGB(255, 255, 182, 0);

  final List<int> _fontSizes = List.generate(65, (index) => 8 + index);
  int currentFontSize = 16;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() {
    final settings = Provider.of<ThemeSettings>(context, listen: false);
    isDarkMode = settings.currentTheme == ThemeMode.dark;
    pickerColor = settings.currentColor;
    currentColor = settings.currentColor;
    currentFontSize = settings.currentFontSize;
    setState(() {});
  }

  void _saveTheme(bool value) async {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    final settings = Provider.of<ThemeSettings>(context, listen: false);
    await settings.toggleTheme();
    isDarkMode = settings.currentTheme == ThemeMode.dark;
    setState(() {
      isDarkMode = value;
      isOptionAlreadySelected = false;
    });
  }

  void _saveColor(Color color) async {
    final settings = Provider.of<ThemeSettings>(context, listen: false);
    await settings.saveColor(color);
    setState(() {});
  }

  void _saveFontSize(int size) async {
    if (isOptionAlreadySelected) {
      return;
    }
    isOptionAlreadySelected = true;
    final settings = Provider.of<ThemeSettings>(context, listen: false);
    await settings.saveFontSize(size);

    setState(() {
      currentFontSize = size;
      isOptionAlreadySelected = false;
    });
  }

  void resetSettings() {
    final settings = Provider.of<ThemeSettings>(context, listen: false);
    settings.resetSettings().then((value) {
      isDarkMode = false;
      _loadTheme();
      setState(() {});
    });
  }

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

// raise the [showDialog] widget
  Future showPicker() {
    return showDialog(
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Wybierz kolor',
            style: Theme.of(context).textTheme.bodySmall!,
          ),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              child: Text(
                'Potwierdź',
                style: Theme.of(context).textTheme.bodySmall!,
              ),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop(pickerColor);
              },
            ),
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height *
              (orientation == Orientation.portrait
                  ? portraitToolbarHeight
                  : landscapeToolbarHeight),
          title: Center(
              child: Text(
            "Opcje",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          )),
          backgroundColor:
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: IconButton(
                  onPressed: () => resetSettings(),
                  icon: Icon(Icons.refresh_outlined)),
            )
          ],
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Center(
                    child: Text(
                      "Rodzaj motywu",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 30,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (isDarkMode) _saveTheme(false);
                        },
                        splashColor: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Motyw jasny",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!isDarkMode) _saveTheme(true);
                        },
                        splashColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Motyw ciemny",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Center(
                    child: Text(
                      "Kolor motywu",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 30,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isOptionAlreadySelected) {
                        return;
                      }
                      isOptionAlreadySelected = true;
                      showPicker().then((value) {
                        if (value != null) _saveColor(value);
                      });

                      isOptionAlreadySelected = false;
                    },
                    child: Icon(Icons.color_lens),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: Center(
                        child: Text(
                          "Rozmiar czcionki:",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 30,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Center(
                        child: DropdownButton<int>(
                          value: currentFontSize,
                          items: _fontSizes.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              alignment: Alignment.centerLeft,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (newValue) => _saveFontSize(newValue!),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Center(
                    child: Text(
                      "Testownik",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const DemoVersionDialog(),
          ],
        ),
      );
    });
  }
}
