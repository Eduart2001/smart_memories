import 'package:exif/exif.dart';
import 'package:path/path.dart';
import 'package:file_manager/file_manager.dart';
import 'dart:io';
import 'dart:async';
import "package:smart_memories/models/duplicatesModel.dart";
import 'package:geocoding/geocoding.dart';

class OrganiserModel {
  final List organisePossibilities = ["Year", "Month", "Day", "Location"];
  Map<int, String> selectedOptions = {};

  List getAvailableOptions() {
    return organisePossibilities
        .where((element) => !selectedOptions.values.contains(element))
        .toList();
  }

  void addToSelectedOptions(int key, String value) {
    selectedOptions[key] = (value);
  }

  void removeToSelectedOptions(int value) {
    selectedOptions.remove(value);
  }

  allSelectedOptions() {
    return selectedOptions;
  }

  allSelectedOptionsValues() {
    List<String> l = [];
    for (var element in selectedOptions.keys) {
      l.add(selectedOptions[element]!);
    }
    return l;
  }
}

Future<void> imageOrganiserModel(List<FileSystemEntity> entities,
    List<String> organisation, bool rename, bool duplicates) async {
  Map validName = {};

  List<String> duplicatesName = [];
  if (organisation.isNotEmpty) {
    for (var element in entities) {
      if (FileManager.isFile(element)) {
        File imageFile = File(element.path);
        final fileBytes = imageFile.readAsBytesSync();
        final data = await readExifFromBytes(fileBytes);

        String currentName = element.path;

        String newFolder = "";

        if (data.isNotEmpty) {
          newFolder = await newFolderName(organisation, data);
          bool exists =
              await Directory("${entities[0].parent.path}${newFolder}")
                  .exists();

          if (!exists) {
            try {
              // Create Folder
              String basePath = "";
              for (var v in newFolder.split("/")) {
                if (v != "") {
                  await FileManager.createFolder(
                      element.parent.path + basePath, v);
                  basePath += "/${v}";
                }
              }
            } catch (e) {
              print(e);
            }
          }
          String newName = basename(element.path);

          if (rename) {
            List format = (element.path.split("."));
            String name =
                "${data['EXIF DateTimeOriginal'].toString().replaceAll(':', '_').replaceAll(' ', '_')}";
            String endString = ".${format[format.length - 1]}";
            int index = 1;
            if (validName.containsKey(name)) {
              index = validName[name];
              newName = "/" + name + "_(${index.toString()})" + endString;
              if (currentName != newName) {
                validName[name] = index + 1;
              }
            } else {
              newName = name + endString;
              if (currentName != newName) {
                validName[name] = index;
              }
            }
          }
          imageFile.rename(element.parent.path + newFolder + newName);
          if (duplicates) {
            if (newFolder != "" &&
                !duplicatesName.contains(element.parent.path + newFolder)) {
              duplicatesName.add(element.parent.path + newFolder);
            }
          }
        }
      }
    }
  }
  for (String element in duplicatesName) {
    final dir = Directory(element);
    final List<FileSystemEntity> entities = await dir.list().toList();
    await duplicatesImageModel(entities);
  }
}

Future<String> newFolderName(
    List<String> organisation, Map<String, IfdTag> data) async {
  String name = "/";
  for (var element in organisation) {
    if (element == "Year") {
      name +=
          "${data['EXIF DateTimeOriginal'].toString().replaceAll(" ", ":").split(":")[0]}/";
    } else if (element == "Month") {
      name +=
          "${data['EXIF DateTimeOriginal'].toString().replaceAll(" ", ":").split(":")[1]}/";
    } else if (element == "Day") {
      name +=
          "${data['EXIF DateTimeOriginal'].toString().replaceAll(" ", ":").split(":")[2]}/";
    } else {
      try {
        List latitudeGPSList = data['GPS GPSLatitude']!.values.toList();
        List longitudeGPSList = data['GPS GPSLongitude']!.values.toList();

        int ns = (data['GPS GPSLatitudeRef'].toString() == "N") ? 1 : -1;
        int ew = (data['GPS GPSLongitudeRef'].toString() == "E") ? 1 : -1;
        double latitude = (ns *
                (latitudeGPSList[0].toDouble() +
                    latitudeGPSList[1].toDouble() / 60 +
                    latitudeGPSList[2].toDouble() / 3600))
            .toDouble();
        double longitude = (ew *
                (longitudeGPSList[0].toDouble() +
                    longitudeGPSList[1].toDouble() / 60 +
                    longitudeGPSList[2].toDouble() / 3600))
            .toDouble();

        print(latitude);
        print(longitude);
        Placemark placeMark =
            await placemarkFromCoordinates(latitude, longitude)
                .then((value) => value[0]);
        String country = placeMark.country!;
        print(country);
        name += "${country}/";
      } catch (e) {
        print("test ${e}");
      }
    }
  }

  return name;
}
