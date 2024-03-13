// import 'dart:io';
//
// //todo: j'ai pas su tester si ca marchait car j ai des problèmes avec mon IDE mais normalement ca devrait etre ok
// class imageRename {
//   static Future<File> renameImage(File imageFile) async {
//     String path = imageFile.path;
//     String extension = path.substring(path.lastIndexOf('.'));
//     String name = path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.'));
//     String date = DateTime.now().toString();
//     String newName = name + date + extension;
//     File renamed = await imageFile.rename(path.substring(0, path.lastIndexOf('/') + 1) + newName);
//     return renamed;
//   }
// }