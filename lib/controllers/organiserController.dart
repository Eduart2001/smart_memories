import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_memories/models/organiserModel.dart';
import 'package:smart_memories/controllers/galleryController.dart';

class FieldProvider extends ChangeNotifier {
  final List<List> _dropBoxList = [];
  List<List> get dropBoxList => _dropBoxList;

  int cnt = 0;
  bool isSelected = false;

  bool _isSelectedRename = false;
  bool _isSelectedDuplicates = false;
  bool _isSelectedConfirm = false;

  OrganiserModel organiserModel = OrganiserModel();

  FieldProvider() {
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


  set isSelectedRename(bool b){
    _isSelectedRename=b;
  }
    set isSelectedDuplicates(bool b){
    _isSelectedDuplicates=b;
  }
    set isSelectedConfirm(bool b){
    _isSelectedConfirm=b;
  }

    getSelectedRename(){
    return _isSelectedRename;
  }
    getSelectedDuplicates(){
    return _isSelectedDuplicates;
  }
    getSelectedConfirm(){
    return _isSelectedConfirm;
  }
  generateInitialFields() {
    dropBoxField = organiserModel.getAvailableOptions();
  }

  String? indexValueController(int index) {
    return organiserModel.selectedOptions[index];
  }

  List getAvailableOptionsController() {
    List l = organiserModel.getAvailableOptions();
    if (!_dropBoxList.contains(l)) {
      //dropBoxField=l;
      return l;
    }

    return [];
  }

  addToSelectedOptionsController(int key, String value) {
    organiserModel.addToSelectedOptions(key, value);
  }
  submitFormController(List<FileSystemEntity> entities){
    if(_isSelectedConfirm){
      if(_isSelectedRename){
        renameImageController(entities);
      }else if(_isSelectedDuplicates){
        duplicatesImageController(entities);
      } 
    }
    print("Submited");

  }
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
