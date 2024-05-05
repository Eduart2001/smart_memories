import 'package:exif/exif.dart';
import 'package:path/path.dart';
import 'package:file_manager/file_manager.dart';
import 'dart:io';
import 'dart:async';
import "package:smart_memories/models/duplicatesModel.dart";
import 'package:geocoding/geocoding.dart';

Future<void> renameImageModel(List<FileSystemEntity> entities) async {
  /*
      Renames the images in the list of entities based on their EXIF details.
  
      The [entities] parameter is a list of FileSystemEntity objects representing the images.
  
      Returns a [Future] that completes with the renamed images.
    */
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
