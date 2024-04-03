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
                directoryOrganiserDropBox(),
                renameCheckbox(),
                duplicatesCheckbox(),
                confirmCheckbox(),
                TextButton(onPressed: (){
                  if (fP.getSelectedConfirm()) {
                    fP.submitFormController(widget.entities);
                    Navigator.pop(context);
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

  Container renameCheckbox() {
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.green.shade100,
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

  Container duplicatesCheckbox() {
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.green.shade100,
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

  Container directoryOrganiserDropBox() {
    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.green.shade100,
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
