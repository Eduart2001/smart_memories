import 'package:file_manager/file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:exif/exif.dart';

import 'package:smart_memories/source/imageRename.dart';
import 'package:smart_memories/source/duplicates.dart';

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
      String currentName=element.path;
      
       if(!data.isEmpty){
         List format= (element.path.split("."));
         String name = "${data['EXIF DateTimeOriginal'].toString().replaceAll(':', '_').replaceAll(' ','_')}"; 
         String endString=".${format[format.length-1]}";
         int index =1;
         if(validName.containsKey(name)){
            index=validName[name];
            String newName = element.parent.path+"/"+name+"_"+index.toString()+endString;
            if(currentName!=newName){
              imageFile.rename(newName);
              validName[name]=index+1;
            }

         }else{
       
            String newName = element.parent.path+"/"+name+endString;
            print(currentName==newName);
            if(currentName!=newName){
              imageFile.rename(newName);
              validName[name]=index;
            }
         }
       };
    }

  }
}

Future<void> duplicatesImage(List<FileSystemEntity> entities) async {
  List<FileSystemEntity> duplicatesList=[];
  for (var i = entities.length-1; i>=0; i--) {
    if(FileManager.isDirectory(entities[i])||duplicatesList.contains(entities[i]))break;
    for (var j = i-1; j >=0; j--) {
      
      if(FileManager.isFile(entities[j])&&await duplicates(File(entities[i].path), File(entities[j].path))){
        duplicatesList.add(entities[j]);
      }
    }
  }
  print(duplicatesList);
}
