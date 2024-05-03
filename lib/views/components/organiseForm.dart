import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_memories/controllers/organiserController.dart';
import 'package:smart_memories/theme/colors.dart';
import 'package:smart_memories/views/pages/splashScreen.dart';
import 'package:smart_memories/views/pages/storageManager.dart';

class DropDownDemo extends StatefulWidget {
  final List<FileSystemEntity> entities;
  final String currentDirectory;
  final BuildContext context;

  const DropDownDemo(
      {super.key,
      required this.entities,
      required this.currentDirectory,
      required this.context});

  @override
  State<StatefulWidget> createState() => _DropDownDemoState();
}

class _DropDownDemoState extends State<DropDownDemo> {
  var filter = {};

  FieldProvider fP = new FieldProvider();

  @override
  Widget build(BuildContext context) {
    final Color theme = (Theme.of(context).brightness == Brightness.dark)
        ? const Color.fromARGB(255, 43, 75, 44)
        : const Color.fromARGB(255, 106, 172, 108);
    return Provider<FieldProvider>(
        create: (_) => fP,
        builder: (context, child) {
          return AlertDialog(
              title: const Text(
                'Organise',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                directoryOrganiserDropBox(theme),
                renameCheckbox(theme),
                duplicatesCheckbox(theme),
                confirmCheckbox(context),
                Text(
                  "*hold the options to show description text",
                  style: TextStyle(height: 5, fontSize: 10),
                ),
                TextButton(
                    onPressed: () async {
                      if (fP.getSelectedConfirm()) {
                        await confirmDialog(context, widget.entities);
                        showGallery=true;
                      }
                    },
                    child: const Text("Submit")),
              ]));
        });
  }

  Future <void> confirmDialog(BuildContext context, List<FileSystemEntity> entities) async => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are you sure you want to proceed?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SplashScreen(fP: fP, entities: entities);
            }).then((_) => Navigator.of(context).pop());
      } else {
        // User canceled, add your code to handle cancellation here
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alert"),
              content: Text("You chose to cancel."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    });

  List<DropdownMenuItem<String>>? createDropDownMenuItems(List l) {
    List<DropdownMenuItem<String>> d = [];
    for (var element in l) {
      d.add(DropdownMenuItem<String>(
        value: element,
        child: Text(element),
      ));
    }
    return d;
  }

  Container buildCheckbox(Color c, String text, dynamic Function() getValue,
      void Function(bool) setValue, String message) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: c,
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: getValue() as bool,
            onChanged: (bool? value) {
              setState(() {
                setValue(value!);
              });
            },
          ), //Checkbox
          //Text(text),
          Tooltip(
              verticalOffset: 48,
              height: 24,
              message: message,
              showDuration: Duration(seconds: 2),
              child: Text(text)),
        ], //<Widget>[]
      ), //Row,
    );
  }

  Container renameCheckbox(Color c) {
    return buildCheckbox(
        c,
        "Rename By Taken Date",
        fP.getSelectedRename,
        (value) => fP.isSelectedRename = value,
        "Rename all the images in the\n folder by the date they were taken");
  }

  Container duplicatesCheckbox(Color c) {
    return buildCheckbox(
        c,
        "Isolate Duplicates",
        fP.getSelectedDuplicates,
        (value) => fP.isSelectedDuplicates = value,
        "Isolate all the duplicate images\n on a folder called duplicates");
  }

  Container confirmCheckbox(context) {
    final Color c = (Theme.of(context).brightness == Brightness.dark)
        ? darkColorScheme.errorContainer
        : lightColorScheme.error;
    return buildCheckbox(
        c,
        "Confirm",
        fP.getSelectedConfirm,
        (value) => fP.isSelectedConfirm = value,
        "Confirm the operations you want to execute");
  }

  Container directoryOrganiserDropBox(Color c) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: c,
      ),
      child: Column(
        children: [
          ...List.generate(fP.dropBoxList.length, (index) {
            String? currentValue = fP.indexValueController(index);
            final controller = fP.dropBoxList[index];
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<String>(
                    padding: EdgeInsets.fromLTRB(index * 10 + 10, 0, 0, 0),
                    items: createDropDownMenuItems(controller),
                    hint: const Text("Choose an option"),
                    value: currentValue,
                    onChanged: (newValue) {
                      fP.addToSelectedOptionsController(index, newValue!);
                      fP.isSelected = true;
                      currentValue = newValue;
                      setState(() {});
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          fP.removeDropBoxField = index;
                        });
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(40 - index * 10 + 10, 0, 0, 0),
                        child: const Icon(Icons.delete),
                      )),
                ],
              ),
            );
          }),

          ///Add more button
          Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (fP.dropBoxList.isEmpty) {
                        fP = new FieldProvider();
                      } else if (fP.isSelected) {
                        List l = fP.getAvailableOptionsController();
                        if (l.isNotEmpty) {
                          fP.dropBoxField = fP.getAvailableOptionsController();
                        }
                      }
                    });
                  },
                  child: const Icon(Icons.add_circle_outline_rounded))),

        ],
      ),
    );
    //checkbox("duplicates",isSelected),
  }
}
