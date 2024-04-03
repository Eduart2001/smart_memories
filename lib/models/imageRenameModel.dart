import 'package:exif/exif.dart';
import 'package:path/path.dart';
import 'package:file_manager/file_manager.dart';
import 'dart:io';
import 'dart:async';
import "package:smart_memories/models/duplicatesModel.dart";
import 'package:geocoding/geocoding.dart';

Future<void> renameImageModel(List<FileSystemEntity> entities) async {
  Map validName = {};
  for (var element in entities) {
    if (FileManager.isFile(element)) {
      File imageFile = File(element.path);
      final fileBytes = imageFile.readAsBytesSync();
      final data = await readExifFromBytes(fileBytes);

      String currentName = element.path;

      if (!data.isEmpty) {
        List format = (element.path.split("."));
        String name =
            "${data['EXIF DateTimeOriginal'].toString().replaceAll(':', '_').replaceAll(' ', '_')}";
        String endString = ".${format[format.length - 1]}";
        int index = 1;
        if (validName.containsKey(name)) {
          index = validName[name];
          String newName = element.parent.path +
              "/" +
              name +
              "_(${index.toString()})" +
              endString;
          if (currentName != newName) {
            imageFile.rename(newName);
            validName[name] = index + 1;
          }
        } else {
          String newName = element.parent.path + "/" + name + endString;
          print(currentName == newName);
          if (currentName != newName) {
            imageFile.rename(newName);
            validName[name] = index;
          }
        }
      }
      ;
    }
  }
}

