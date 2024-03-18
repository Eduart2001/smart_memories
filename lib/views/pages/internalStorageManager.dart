import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_memories/views/pages/homePage.dart';
import 'package:smart_memories/controllers/galleryController.dart';

class InternalStorage extends StatefulWidget{ 
  const InternalStorage({super.key});

    @override
    State<StatefulWidget> createState() =>_InternalStorage();
}

class _InternalStorage extends State<InternalStorage> {
  final FileManagerController controller = FileManagerController();
  List<FileSystemEntity> entities=[];
  
  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
        appBar: appBar(context),
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
                       
                        // delete a folder
                        //await entity.delete(recursive: true);

                        // rename a folder
                        //await entity.rename("newPath");

                        // Check weather folder exists
                         entity.exists();

                        // get date of file
                         DateTime date = (await entity.stat()).modified;
                      } else {
                        // delete a file
                         await entity.delete();

                        // rename a file
                        //await entity.rename("newPath");

                        // Check weather file exists
                        entity.exists();

                        // get date of file
                         DateTime date = (await entity.stat()).modified;

                        // get the size of the file
                         int size = (await entity.stat()).size;
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
            Expanded(
              child: OutlinedButton(
                
                onPressed: () async{
                  for (var element in entities) {
                    if(FileManager.isFile(element)){
                      renameImage(entities);
                      break;
                    }
                  }
                },
                child: Text("rename"),
              ),
            ),
            SizedBox(
              //space between button
              width: 16,
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: Text("NNNNNN"),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
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
          String base_path ='/storage/emulated/0';
          if(controller.getCurrentPath==base_path){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
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

            return Text(
              "${FileManager.formatBytes(size)}",
            );
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

  List compatibleFormats=["jpeg","png","jpg","gif", "webp","tiff","svg"];
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
 // Future<void> selectStorage(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       child: FutureBuilder<List<Directory>>(
  //         future: FileManager.getStorageList(),
  //         builder: (context, snapshot) {
  //           if (snapshot.hasData) {
  //             final List<FileSystemEntity> storageList = snapshot.data!;
  //             return Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: storageList
  //                       .map((e) => ListTile(
  //                             title: Text(
  //                               "${FileManager.basename(e)}",
  //                             ),
  //                             onTap: () {
  //                               controller.openDirectory(e);
  //                               Navigator.pop(context);
  //                             },
  //                           ))
  //                       .toList()),
  //             );
  //           }
  //           return Dialog(
  //             child: CircularProgressIndicator(),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  sort(BuildContext context) async {
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