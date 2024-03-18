  import 'package:exif/exif.dart';
  import 'package:path/path.dart';
  // import './imageDetailsGetter.dart';
  import 'dart:io';
  import 'dart:async';
  import 'package:permission_handler/permission_handler.dart';
  
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
    print(path);
    String extension = path.substring(path.lastIndexOf('.'));
    String name = path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.'));
    String date = DateTime.now().toString();
    String newName = name + date + extension;
    File renamed = await imageFile.rename(path.substring(0, path.lastIndexOf('/') + 1) + newName);
    print(renamed.path);
    return renamed;
  }
}

// void printCurrentDirectory() {
//   final currentDirectory = Directory.current.listSync();
//   try {
//     final files = currentDirectory.listSync();
//     for (final file in files) {
//       print(file.path);
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
// }

Future requestPermission(Permission permission) async {
  print("Requesting permission: $permission");
  PermissionStatus status = await permission.status;
  print("Permission status: $status");

  if (status.isPermanentlyDenied) {
    print("Permission is permanently denied");
  } else if (status.isDenied) {
    print("Permission is denied");
    status = await permission.request();
    print("Permission status on requesting again: $status");
  } else {
    print("Permission is not permanently denied");
    status = await permission.request();
  }
}

Future<File> changeFileNameOnly(File file, String newFileName) async {
  await requestPermission(Permission.photos);
  await requestPermission(Permission.videos);
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  return file.rename(newPath);
}

void test_function() async {
// //   await Permission.manageExternalStorage.request();
// // var status = await Permission.manageExternalStorage.status;
// // if (status.isDenied) {
// //   // We didn't ask for permission yet or the permission has been denied   before but not permanently.
// //   return;
// // }

// // // You can can also directly ask the permission about its status.
// // if (await Permission.storage.isRestricted) {
// //   // The OS restricts access, for example because of parental controls.
// //   return;
// // }
// // if (status.isGranted) {
// // //here you add the code to store the file
// // }
//   print("ok");
  final storage = Directory("/storage/emulated/0/Download/");
//   // final test_path = Directory.current.path;
//   // print(test_path);
//   // final directory = Directory(test_path);
//   // var status = Permission.storage.status;
//   // if (status.isGranted) {
//   //   Permission.storage.request();
//   // }
  final files = storage.listSync();
  for (final file in files) {
    print(file.path);
  }
  var status = await Permission.manageExternalStorage.request();
  print(status.isGranted);
  final file = File(storage.path + "/IMG_20240318_113432.jpg"); // <---- c'est bien ici que ça marche le rename
  print("ok");
  file.rename(storage.path + "/test.jpg");
  print("OKKKKKK");

  // if (await Permission.manageExternalStorage.request().isGranted) {print("ok");}
  // else {print("not ok");}
  // await requestPermission(Permission.photos);
  // await requestPermission(Permission.videos);
  // await requestPermission(Permission.manageExternalStorage);
  // File f = await changeFileNameOnly(file, "test");
  // print("Done");
}

void main(List<String> args) {
  print("ok");
  final test_path = Directory.current.path + "\\test\\test-images\\";
  print(test_path);
  // final directory = Directory(test_path);
  // final files = directory.listSync();
  // for (final file in files) {
  //   print(file.path);
  // }
  final file = File(test_path + "test.jpg");
  // print(file.path);
  // printExifOf(test_path + "test.jpg");
  // var data = imageExifDetailsGetter(test_path + "test.jpg");
  // for (final entry in data.entries) {
  //     print("${entry.key}: ${entry.value}");
  //   }
  file.rename(test_path + "test2.jpg");
}