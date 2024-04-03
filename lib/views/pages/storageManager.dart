import 'dart:io';
import 'dart:math';
import 'package:file_manager/file_manager.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:smart_memories/views/pages/homePage.dart';
import 'package:smart_memories/views/components/organiseForm.dart';
import 'package:smart_memories/controllers/galleryController.dart';

class StorageManager extends StatefulWidget{ 
  final String base_path;
  const StorageManager({super.key,required this.base_path});

    @override
    State<StatefulWidget> createState() =>_StorageManager();
}

class _StorageManager extends State<StorageManager> {
  final FileManagerController controller = FileManagerController();
  List<FileSystemEntity> entities=[];

  @override
  Widget build(BuildContext context) {
    
    controller.setCurrentPath=widget.base_path;

    return ControlBackButton(
      controller: controller,
      child: Scaffold(
        appBar: appBar(context,widget.base_path),
        body: FileManager(
          controller: controller,
          builder: (context, snapshot) {
            entities = filteredSnapshot(snapshot);
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              itemCount: entities.length,
              itemBuilder: (context, index) {
                FileSystemEntity entity = entities[index];
                return Card(
                  child: ListTile(
                    leading: FileManager.isFile(entity)?Icon(Icons.feed_outlined): Icon(Icons.folder),
                    title: Text(FileManager.basename(
                      entity,
                      showFileExtension: true,
                    )),
                    subtitle: subtitle(entity),
                    onTap: () async {
                      if (FileManager.isDirectory(entity)) {
                        // open the folder
                        controller.openDirectory(entity);              
                      } else {
                        // delete a file
                        //await entity.delete();

                        // rename a file
                        //await entity.rename("newPath");

                        // Check weather file exists
                        // entity.exists();

                        // get date of file
                        //  DateTime date = (await entity.stat()).modified;

                        // get the size of the file
                        //  int size = (await entity.stat()).size;
                      }
                    },
                  ),
                ); 
              },
            );
          },
        ),
        
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () async {
        //   var status=await Permission.manageExternalStorage.request();
        //   print(status);
        //     //await FileManager.requestFilesAccessPermission();
        //   },
        //   label: Text("Request File Access Permission"),
        // ),
        bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0), //the one you prefer
        child: Row(
          children: [
            // Expanded(
            //   child: OutlinedButton(
                
            //     onPressed: () {
            //       for (var element in entities) {
            //         if(FileManager.isFile(element)){
            //           //renameImageController(entities);
            //           setState(() {});
            //           //controller.openDirectory(controller.getCurrentDirectory);
            //           //Navigator.pushReplacement(context);
            //           break;
            //         }
            //       }
            //     },
            //     child: Text("Rename"),
            //   ),
            // ),
            // SizedBox(
            //   //space between button
            //   width: 16,
            // ),
            Expanded(
              child: OutlinedButton(
                 onPressed: () async{
                  await showDialog<void>(
                  context: context,
                  builder: (context)=>DropDownDemo(entities:entities,currentDirectory: controller.getCurrentPath,context:context)
                  
                  );
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
      title: ValueListenableBuilder<String>(
        valueListenable: controller.titleNotifier,
        builder: (context, title, _) => Text(title),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          if(controller.getCurrentPath==base_path){
                Navigator.pop(context); 
          }else{
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
            if (size>=0) {
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

  List compatibleFormats=["jpeg","png","jpg","gif", "webp","tiff","svg","JPG"];
  List<FileSystemEntity> filteredSnapshot(List<FileSystemEntity> snapshot)  {
   
   for(var i= snapshot.length-1;i>=0;i--){
    String path = snapshot[i].path;
    List l = path.split(".");
     if(FileManager.isFile(snapshot[i]) && !compatibleFormats.contains(l[l.length-1])){
      snapshot.remove(snapshot[i]);
     }
   }
   return snapshot;
  }
  sort(BuildContext context){
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