import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:smart_memories/source/imageRename.dart';


Future<void> pickImage(Function updateGallery) async {
  var status=await Permission.storage.request();
  final ImagePicker picker = ImagePicker();
  final List<XFile>? images = await picker.pickMultipleMedia();

  for (XFile element in images!) {
    File imageFile = File(element.path);

    File renamed =await imageRename.renameImage(imageFile);
    updateGallery(renamed);
  }
}
