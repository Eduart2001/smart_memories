import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:smart_memories/views/pages/gallery.dart';

import 'package:smart_memories/views/components/organiseForm.dart';
import 'package:smart_memories/views/pages/imageDetails.dart';

class StorageManager extends StatefulWidget {
  final String base_path;
  const StorageManager({super.key, required this.base_path});

  @override
  State<StatefulWidget> createState() => _StorageManager();
}


bool showGallery = false;
class _StorageManager extends State<StorageManager> {
  late FileManagerController controller;
  List<FileSystemEntity> entities = [];

  @override
  void initState() {
    controller = FileManagerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
        appBar: appBar(context, widget.base_path),
        body: FileManager(
          controller: controller,
          builder: (context, snapshot) {
            entities = filteredSnapshot(snapshot);
            if(entities.isEmpty){
                return Center(child: Text("No images found\nFolder contains only unsupported files" , textAlign: TextAlign.center,));
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              itemCount: entities.length,
              itemBuilder: (context, index) {
                FileSystemEntity entity = entities[index];
                return Card(
                  child: ListTile(
                    leading: FileManager.isFile(entity)
                        ? Icon(Icons.feed_outlined)
                        : Icon(Icons.folder),
                    title: Text(FileManager.basename(
                      entity,
                      showFileExtension: true,
                    )),
                    subtitle: subtitle(entity),
                    onTap: () async {
                      if (FileManager.isDirectory(entity)) {
                     
                        controller.openDirectory(entity);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageDetails( 
                              imageFile: File(entity.path),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0), //the one you prefer
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (entities.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Gallery(
                                  controller: controller,
                                  imageFileList: entities,
                                  base_path: controller.getCurrentPath,
                                )),
                      );
                    }
                  },
                  child: Text("Gallery"),
                ),
              ),
              SizedBox(
                //space between button
                width: 16,
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async { 
                  
                  if (this.entities.isNotEmpty) {

                    bool? result =await showDialog<bool>(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => DropDownDemo(
                      entities: entities,
                      currentDirectory: controller.getCurrentPath,
                      context: context,
                      ),
                    );
                   if (showGallery) {
                     final dir = Directory(controller.getCurrentPath);
                      final List<FileSystemEntity> entities =
                          await dir.list().toList();
                      showGallery=false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Gallery(
                                  controller: controller,
                                  imageFileList: filteredSnapshot(entities),
                                  base_path: controller.getCurrentPath,
                                )),
                      );
                     
                   }
                  
                    }
                  },
                  child: Text("Organiser"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, String base_path) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => sort(context),
          icon: Icon(Icons.sort_rounded),
        ),
      ],
      title: Text(base_path),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          if (await controller.isRootDirectory()) {
            Navigator.pop(context);
          } else {
            await controller.goToParentDirectory();
          }
        },
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;
            if (size >= 0) {
              return Text(
                "${FileManager.formatBytes(size)}",
              );
            }
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return Text("");
        }
      },
    );
  }

List compatibleFormats = [
    "jpeg",
    "png",
    "jpg",
    "gif",
    "webp",
    "tiff",
    "svg",
    "JPG"
  ];
List<FileSystemEntity> filteredSnapshot(List<FileSystemEntity> snapshot) {
  /*
  Filters a list of FileSystemEntity objects.

  This function iterates over a list of FileSystemEntity objects in reverse order,
  checks if each entity is a file and if its format is compatible, and removes it from the list if not.
  It also removes any entities with the basename 'data' or 'obb', and any empty directories.

  The function uses the `FileManager` class to check if an entity is a file or a directory.
  It uses the `basename` function to get the basename of an entity's path.
  It uses the `listSync` method to check if a directory is empty.

  The function prints the snapshot list at each iteration.

  @param snapshot A list of FileSystemEntity objects to filter.
  @return The filtered list of FileSystemEntity objects.
  */
  for (var i = snapshot.length - 1; i >= 0; i--) {
    String path = snapshot[i].path;
    List<String> parts = path.split(".");
    String extension = parts.last.toLowerCase();
    if (FileManager.isFile(snapshot[i]) &&
        !compatibleFormats.contains(extension) ||
        basename(snapshot[i].path) == 'data' ||
        basename(snapshot[i].path) == '.thumbnails' ||
        basename(snapshot[i].path) == 'obb' ||
        (FileManager.isDirectory(snapshot[i]) &&
            (snapshot[i] as Directory).listSync().isEmpty)) {
      snapshot.remove(snapshot[i]);
    }
  }
  return snapshot;
}
  sort(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text("Name"),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Size"),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Date"),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("type"),
                  onTap: () {
                    controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // createFolder(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       TextEditingController folderName = TextEditingController();
  //       return Dialog(
  //         child: Container(
  //           padding: EdgeInsets.all(10),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               ListTile(
  //                 title: TextField(
  //                   controller: folderName,
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   try {
  //                     // Create Folder
  //                     await FileManager.createFolder(
  //                         controller.getCurrentPath, folderName.text);
  //                     // Open Created Folder
  //                     controller.setCurrentPath =
  //                         controller.getCurrentPath + "/" + folderName.text;
  //                   } catch (e) {}
  //
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text('Create Folder'),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
