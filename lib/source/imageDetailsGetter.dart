  import 'package:exif/exif.dart';
  import 'package:path/path.dart';
  import 'dart:io';
  import 'dart:async';
  
  Future <Map>imageExifDetailsGetter(File file) async {

    final fileBytes = file.readAsBytesSync();
    
    final data = await readExifFromBytes(fileBytes);
    if (data.isEmpty) {
      print("No EXIF information found");
      return {};
    }
    return data;
  }