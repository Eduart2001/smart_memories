
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:exif/exif.dart';

import 'package:smart_memories/models/imageRenameModel.dart';
import 'package:smart_memories/models/duplicatesModel.dart';

Future<void> pickImage(Function updateGallery) async {
  var status=await Permission.manageExternalStorage.request();
  final ImagePicker picker = ImagePicker();
  XFile? a = await picker.pickImage(source:ImageSource.gallery);
  print(a!.path);
  final List<XFile>? images = await picker.pickMultipleMedia();
  // print("path 1:" + images!.first.path);

  for (XFile element in images!) {
    File imageFile = File(element.path);
    String directoryPath = imageFile.parent.path;
    // print("path:");
    // print(directoryPath);
    // imageFile.rename('$directoryPath/newFileName.jpg');

    // File renamed =await imageRename.renameImage(imageFile);
    // updateGallery(renamed);
  }
}

Future<void> renameImageController(List<FileSystemEntity> entities) async {
  await renameImageModel(entities);
}

Future<void> duplicatesImageController(List<FileSystemEntity> entities) async {
  await duplicatesImageModel(entities); 
}


