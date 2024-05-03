// ignore_for_file: prefer_const_constructors
import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:smart_memories/controllers/galleryController.dart';
import 'package:smart_memories/views/pages/imageDetails.dart';
import 'package:path/path.dart';
import 'package:file_manager/file_manager.dart';

class Gallery extends StatefulWidget {
  final FileManagerController controller;
  final List<FileSystemEntity> imageFileList;
  final String base_path;
  const Gallery(
      {super.key,
      required this.controller,
      required this.imageFileList,
      required this.base_path});

  @override
  State<StatefulWidget> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<FileSystemEntity> imageFileList = [];

  @override
  Widget build(BuildContext context) {
    this.imageFileList = widget.imageFileList;
    return Scaffold(
      appBar: appBar(context, widget.controller, widget.base_path),
      //  floatingActionButton: testButton(), // pour tester le rename décommenter ce boutton et commencer celui d'en bas
      //floatingActionButton: floatingActionButton(),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: gridWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gridWidget() {
    if(imageFileList.isEmpty){
      return Center(child: Text("No images found\nFolder contains only unsupported files" , textAlign: TextAlign.center,));
    }
    return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: imageFileList.length,
                  itemBuilder: (BuildContext context, int index) {
                    FileSystemEntity f = imageFileList[index];
                    return GestureDetector(
                      onTap: () async {
                        if (f is Directory) {
                          // open the folder
                          widget.controller.openDirectory(f);
                          widget.controller.setCurrentPath = f.path;

                          await getAllFromDirectory(
                              widget.controller.getCurrentPath);
                          FileManagerController controller =
                              widget.controller;
                          List<FileSystemEntity> imageFileList =
                              widget.imageFileList.reversed.toList();
                          String base_path = widget.base_path;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Gallery(
                                      controller: controller,
                                      imageFileList: filteredSnapshot(imageFileList),
                                      base_path: base_path,
                                    )),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageDetails(imageFile: File(f.path)),
                            ),
                          );
                        }
                      },
                      child: displayEntity(f),
                    );
                  });
  }

  displayEntity(FileSystemEntity f) {
    if (f is File) {
      return Image.file(
        File(f.path),
        fit: BoxFit.cover,
      );
    } else {
      return GridTile(
          child: Icon(Icons.folder, size: 80.0),
          footer: Text(
            basename(f.path),
            textAlign: TextAlign.center,
          ));
    }
  }

  void updateGallery(File image) {
    setState(() {
      imageFileList!.add(image);
    });
  }

  AppBar appBar(BuildContext context, FileManagerController controller,
      String base_path) {
    return AppBar(
      title: Text('Gallery'),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (controller.getCurrentPath != base_path) {
            controller.setCurrentPath =
                controller.getCurrentDirectory.parent.path;
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Future getAllFromDirectory(String path) async {
    final dir = Directory(path);
    imageFileList.clear();
    imageFileList.addAll(await dir.list().toList());
  }

  FloatingActionButton testButton() {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: "Add a photo",
      child: Icon(Icons.add_photo_alternate_outlined),
    );
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        pickImage(updateGallery);
      },
      tooltip: "Add a photo",
      child: Icon(Icons.add_photo_alternate_outlined),
    );
  }
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
