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
 /*
  Runs the duplicates image model on the given list of [entities].
  This function uses the [compute] function to run the [duplicatesImageModelHashMap] function in a separate isolate.
  Returns a [Future] that completes when the computation is done.
 */
  await compute(duplicatesImageModelHashMap, entities);
}
