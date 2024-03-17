  import 'package:exif/exif.dart';
  import 'package:path/path.dart';
  import 'dart:io';
  import 'dart:async';
  
  //Future<File> renameImage(File file) async {
      // final fileBytes = file.readAsBytesSync();
      // final data = await readExifFromBytes(fileBytes);
      // print(data);
      // if(!data.isEmpty){
      //   String name = "${data['EXIF DateTimeOriginal'].toString().replaceAll(':', '_').replaceAll(' ','_')}.${basename(file.path).split(".")[1]}";
      //   return await file.renameSync(name);
      // }
      // return file;
  //}
class imageRename {
  static Future<File> renameImage(File imageFile) async {
    String path = imageFile.path;
    String extension = path.substring(path.lastIndexOf('.'));
    String name = path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.'));
    String date = DateTime.now().toString();
    String newName = name + date + extension;
    File renamed = await imageFile.rename(path.substring(0, path.lastIndexOf('/') + 1) + newName);
    return renamed;
  }
}

