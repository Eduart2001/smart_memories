import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
Future<bool> duplicates(File f1, File f2)async{
  int f1_Bytes = await f1.length();
  int f2_Bytes = await f2.length();
  if(f1_Bytes!=f2_Bytes){
    print("They dont have same size: image1(${f1_Bytes} bytes), image2(${f2_Bytes} bytes)");
    return false;
  }
  Image? i1=decodeImage(f1.readAsBytesSync());
  Image? i2=decodeImage(f2.readAsBytesSync());
  if(i1!.width !=i2!.width && i1.height !=i2.height){
    print("They dont have same dimensions: image1(${i1!.width}x${i1!.height}), image2(${i2!.width}x${i2!.height})");
    return false;
  }

  int width=i1.width;
  int height=i1.height;

  int sz = (width * height > 400000) ? 400000 :width * height;

  for (var i = 0; i < sz; i++) {
    int x = Random().nextInt(width);
    int y = Random().nextInt(height);
    if(i1.getPixel(x, y)!=i2.getPixel(x, y)){
      print("They dont have same pixel value for x=${x} and y=${y}: image1(${i1.getPixel(x, y)}), image2(${i2.getPixel(x, y)})");
      return false;
    }
  }
  return true;
}

generateImageHash(String fileBytes) {
  /*
    Generates a SHA-256 hash for the given fileBytes.
    
    Parameters:
    - fileBytes: String representing the bytes of the file to be hashed.
    
    Returns: String - SHA-256 hash of the file bytes.
   */
  var bytes = utf8.encode(fileBytes); // data being hashed
  String digest = sha256.convert(bytes).toString();
  return digest;
}

Future<void> duplicatesImageModelHashMap(List<FileSystemEntity> entities) async {
  /*
    Detects duplicate images within the given list of entities using a hash-based model.
    Moves duplicate images to a "Duplicates" folder within the parent directory of the entities.

    Parameters:
    - entities: List of FileSystemEntity representing the image files to check for duplicates.

    Returns: Future<void>

  */

  List<FileSystemEntity> duplicatesList=[];
  Map<String,FileSystemEntity> imageModelHashMap={};
  for (var element in entities) {
    var f1_bytes = await File(element.path).readAsBytesSync().toString();
    String imageHash =await compute(generateImageHash,f1_bytes)as String;

    if(imageModelHashMap.containsKey(imageHash)){
      duplicatesList.add(element);
    }else{
      imageModelHashMap[imageHash]=element;
    }
  }
  //await Isolate.run(() => moveToDuplicates(entities, duplicatesList));   
  await moveToDuplicates(entities, duplicatesList); 

}

Future<void> moveToDuplicates(List<FileSystemEntity> entities, List<FileSystemEntity> duplicatesList) async {
  /*
    Moves duplicate files from the given list of entities to a "Duplicates" folder
    within the parent directory of the entities.

    If the "Duplicates" folder doesn't exist, it creates one.

    Parameters:
    - entities: List of FileSystemEntity representing the files to check for duplicates.
    - duplicatesList: List of FileSystemEntity representing the duplicate files to move.
  */
  bool exists = await Directory("${entities[0].parent.path}/Duplicates"). exists();
  if  (!exists && duplicatesList.isNotEmpty) {
    try {
      // Create Folder
      await FileManager.createFolder(
          entities[0].parent.path, "Duplicates");
    } catch (e) {print(e);} 
  }
    
  int i =(duplicatesList.isNotEmpty)?Directory("${entities[0].parent.path}/Duplicates").listSync().length:0;
  
  for (var element in duplicatesList) {
    try {
      List basePathList=basename(element.path).split(".");
      String newPath=element.parent.path+"/Duplicates/${basePathList[0]}_${i}.${basePathList[1]}";
      await File(element.path).rename(newPath);
    } catch (e) {print("moving files error "+e.toString());}
  } 
}
Future<void> duplicatesImageModel(List<FileSystemEntity> entities) async {
    print(entities.length);
    final Stopwatch stopwatch = Stopwatch()..start();
    await compute(duplicatesImageModelHashMap,entities);
    stopwatch.stop();
    print('Execution time: ${stopwatch.elapsed.inMilliseconds} Milliseconds');
}