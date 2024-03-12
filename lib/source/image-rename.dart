  import 'package:exif/exif.dart';
  import 'package:path/path.dart';
  import 'dart:io';
  import 'dart:async';
  
  printExifOf(String path) async {

    final fileBytes = File(path).readAsBytesSync();
    
    final data = await readExifFromBytes(fileBytes);
    if (data.isEmpty) {
      print("No EXIF information found");
      return;
    }

    if (data.containsKey('JPEGThumbnail')) {
      print('File has JPEG thumbnail');
      data.remove('JPEGThumbnail');
    }
    if (data.containsKey('TIFFThumbnail')) {
      print('File has TIFF thumbnail');
      data.remove('TIFFThumbnail');
    }
    for (final entry in data.entries) {
      print("${entry.key}: ${entry.value}");
    }

  }
  Future<File> renameImage(File file) async {
      final fileBytes = file.readAsBytesSync();
      final data = await readExifFromBytes(fileBytes);
      print(data);
      if(!data.isEmpty){
        String name = "${data['EXIF DateTimeOriginal'].toString().replaceAll(':', '_').replaceAll(' ','_')}.${basename(file.path).split(".")[1]}";
        return await file.renameSync(name);
      }
      return file;
  }


