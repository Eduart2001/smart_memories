import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_memories/models/organiserModel.dart';
import 'package:smart_memories/controllers/galleryController.dart';

class FieldProvider extends ChangeNotifier {
  /* 
    Controller class for the Organiser page.
  */
  final List<List> _dropBoxList = [];
  List<List> get dropBoxList => _dropBoxList;

  int cnt = 0;
  bool isSelected = false;

  bool _isSelectedRename = false;
  bool _isSelectedDuplicates = false;
  bool _isSelectedConfirm = false;

  OrganiserModel organiserModel = OrganiserModel();

  FieldProvider() {
    /* 
      Constructor for the FieldProvider class.
      Generates the initial fields for the Organiser page.
    */
    generateInitialFields();
  }

  set dropBoxField(List value) {
    if (cnt <= 3) {
      _dropBoxList.add(value);
      isSelected = false;
      cnt++;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  set removeDropBoxField(int index) {
    for (int i = _dropBoxList.length - 1; i >= index; i--) {
      _dropBoxList.removeAt(i);
      cnt--;
      isSelected = true;
      organiserModel.removeToSelectedOptions(i);
    }
    notifyListeners();
  }

  set isSelectedRename(bool b) {
    _isSelectedRename = b;
  }

  set isSelectedDuplicates(bool b) {
    _isSelectedDuplicates = b;
  }

  set isSelectedConfirm(bool b) {
    _isSelectedConfirm = b;
  }

  getSelectedRename() {
    /* 
        Returns the value of the 'Rename' checkbox.
      */
    return _isSelectedRename;
  }

  getSelectedDuplicates() {
    /* 
        Returns the value of the 'Duplicates' checkbox.
      */
    return _isSelectedDuplicates;
  }

  getSelectedConfirm() {
    /* 
        Returns the value of the 'Confirm' checkbox.
      */
    return _isSelectedConfirm;
  }

  generateInitialFields() {
    /* 
      Generates the initial fields for the Organiser page.
    */
    dropBoxField = organiserModel.getAvailableOptions();
  }

  String? indexValueController(int index) {
    /* 
      Returns the value of the selected option at the given index.
    */
    return organiserModel.selectedOptions[index];
  }

  List getAvailableOptionsController() {
    /* 
      Returns the available options for the dropdown list.
    */
    List l = organiserModel.getAvailableOptions();
    if (!_dropBoxList.contains(l)) {
      //dropBoxField=l;
      return l;
    }

    return [];
  }

  addToSelectedOptionsController(int key, String value) {
    /* 
      Adds the selected option to the list of selected options.
    */
    organiserModel.addToSelectedOptions(key, value);
  }

  submitFormController(List<FileSystemEntity> entities) async {
    /* 
      Submits the form on the Organiser page.
      Calls the imageOrganiserModel function to organise the images.
    */
    if (_isSelectedConfirm) {
      List<String> s = organiserModel.allSelectedOptionsValues();
      await imageOrganiserModel(
          entities, s, _isSelectedRename, _isSelectedDuplicates);
    }
    return true;
  }
}

List<DropdownMenuItem<String>>? createDropDownMenuItems(List l) {
  /* 
    Creates a list of dropdown menu items from the given list.
  */
  List<DropdownMenuItem<String>> d = [];
  for (var element in l) {
    d.add(DropdownMenuItem<String>(
      value: element,
      child: Text(element),
    ));
  }
  return d;
}
