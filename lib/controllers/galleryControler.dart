import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:smart_memories/source/image-rename.dart';


Future<void> pickImage(imageFileList) async {
  var status=await Permission.storage.request();
  final ImagePicker _picker = ImagePicker();
  final List<XFile>? images = await _picker.pickMultipleMedia();

  for (XFile element in images!) {
    File imageFile = File(element.path);
    File renamed =await renameImage(imageFile);
    imageFileList!.add(renamed);
  }
  //setState(() {
  //});
}