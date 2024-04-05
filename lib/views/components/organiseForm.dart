import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:smart_memories/controllers/organiserController.dart';
import 'package:smart_memories/views/pages/storageManager.dart';

class DropDownDemo extends StatefulWidget {
  final List<FileSystemEntity> entities;
  final String currentDirectory;
  final BuildContext context;

  const DropDownDemo({super.key,required this.entities,required this.currentDirectory,required this.context});

  @override
  State<StatefulWidget> createState() => _DropDownDemoState();
}

class _DropDownDemoState extends State<DropDownDemo> {
  var filter = {};
  
  FieldProvider fP = new FieldProvider();

  @override
  Widget build(BuildContext context) {
    final Color theme=(Theme.of(context).brightness==Brightness.dark)?Color.fromARGB(255, 43, 75, 44):Color.fromARGB(255, 106, 172, 108);
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
                confirmCheckbox(),
                TextButton(onPressed: ()async{
                  if (fP.getSelectedConfirm()) {
                    bool b =await fP.submitFormController(widget.entities);
                    Navigator.of(context).pop(true);
                  }
                }, child:const Text("Submit")),

              ]));
        });
  }

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

  Container renameCheckbox(Color c) {
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: c,
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: fP.getSelectedRename(),
            onChanged: (bool? value) {
              setState(() {
                fP.isSelectedRename = value!;
              });
            },
          ), //Checkbox
          Text("Rename"),
        ], //<Widget>[]
      ), //Row,
    );
  }

  Container duplicatesCheckbox(Color c) {
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: c,
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: fP.getSelectedDuplicates(),
            onChanged: (bool? value) {
              setState(() {
                fP.isSelectedDuplicates = value!;
              });
            },
          ), //Checkbox
          Text("Duplicates"),
        ], //<Widget>[]
      ), //Row,
    );
  }

  Container confirmCheckbox() {
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.red.shade500,
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: fP.getSelectedConfirm(),
            onChanged: (bool? value) {
              setState(() {
                fP.isSelectedConfirm = value!;
              });
            },
          ), //Checkbox
          Text("Confirm"),
        ], //<Widget>[]
      ), //Row,
    );
  }

  Container directoryOrganiserDropBox(Color c) {
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: c,
      ),
      child: Column(
        children: [
          ...List.generate(fP.dropBoxList.length, (index) {
            print(fP.dropBoxList.length);

            String? currentValue = fP.indexValueController(index);
            final controller = fP.dropBoxList[index];
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<String>(
                    padding: EdgeInsets.fromLTRB(index * 10 + 10, 0, 0, 0),
                    items: createDropDownMenuItems(controller),
                    hint: Text("Choose an option"),
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
                        if (!l.isEmpty)
                          fP.dropBoxField = fP.getAvailableOptionsController();
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
