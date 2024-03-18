import 'package:file_manager/file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:exif/exif.dart';

import 'package:smart_memories/source/imageRename.dart';


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
    // imageFile.rename(imageFile.path.);

    // File renamed =await imageRename.renameImage(imageFile);
    // updateGallery(renamed);

Future<void> renameImage(List<FileSystemEntity> entities) async {
  Map validName={};
  for (var element in entities) {
    
    if(FileManager.isFile(element)){
      File imageFile = File(element.path);
      final fileBytes = imageFile.readAsBytesSync();
      final data = await readExifFromBytes(fileBytes);
 
       if(!data.isEmpty){
         List format= (element.path.split("."));
         String name = "${data['EXIF DateTimeOriginal'].toString().replaceAll(':', '_').replaceAll(' ','_')}"; 
         String endString=".${format[format.length-1]}";
         if(validName.containsKey(name)){
            int index=validName[name];
            imageFile.rename(element.parent.path+"/"+name+"_"+index.toString()+endString);
            validName[name]=index+1;
         }else{
            imageFile.rename(element.parent.path+"/"+name+endString);
            validName[name]=1;
         }
       };
    }

  }
}