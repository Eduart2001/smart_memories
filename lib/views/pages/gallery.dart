// ignore_for_file: prefer_const_constructors
import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:smart_memories/controllers/galleryController.dart';
import 'package:smart_memories/views/pages/imageDetails.dart';
import '../../models/imageRenameModel.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';


class Gallery extends StatefulWidget {
  final FileManagerController  controller;
  final List <FileSystemEntity>imageFileList;
  final String base_path;
  const Gallery({super.key,required this.controller,required this.imageFileList,required this.base_path});

  @override
  State<StatefulWidget> createState() =>_GalleryState();
}

class _GalleryState extends State<Gallery>{
 List <FileSystemEntity>imageFileList=[];

 @override
 Widget build(BuildContext context){
  this.imageFileList=widget.imageFileList;
   return Scaffold(
     appBar: appBar(context,widget.controller,widget.base_path),
    //  floatingActionButton: testButton(), // pour tester le rename décommenter ce boutton et commencer celui d'en bas
     //floatingActionButton: floatingActionButton(),
     body: Center(
       child : Column(
         children: <Widget>[
           Expanded(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: GridView.builder(
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 3,
                   ),
                   itemCount: imageFileList.length,
                   itemBuilder: (BuildContext context, int index){
                     FileSystemEntity f = imageFileList[index];
                     return GestureDetector(
                       onTap: () async{
                          if (f is Directory) {
                            // open the folder
                              widget.controller.openDirectory(f);
                              widget.controller.setCurrentPath=f.path;

                              await getAllFromDirectory(widget.controller.getCurrentPath);
                              FileManagerController controller=widget.controller;
                              List<FileSystemEntity> imageFileList=widget.imageFileList.reversed.toList();
                              String base_path=widget.base_path;
                              
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Gallery(controller:controller,imageFileList: imageFileList,base_path: base_path,)),
                            );  
                            }  
                          else{
                          
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => ImageDetails(imageFile: File(f.path)),
                           ),
                         );
                          }
                       },
                       child:  displayEntity(f),
                     );
                   }
               ),
             ),
           ),
         ],
       ),
     ),
   );


 }
  displayEntity(FileSystemEntity f){
    if(f is File){
      return  Image.file(File(f.path),
                         fit: BoxFit.cover,
                       );
    }else{
      return GridTile(child: Icon(Icons.folder,size:80.0),footer: Text(basename(f.path),textAlign: TextAlign.center,));
    }
   
   }

 void updateGallery(File image) {
   setState(() {
     imageFileList!.add(image);
   });
 }

  AppBar appBar(BuildContext context,FileManagerController  controller,String base_path) {
    return AppBar(
      title: Text('Gallery'),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          if(controller.getCurrentPath!=base_path){
            controller.setCurrentPath=controller.getCurrentDirectory.parent.path;
          }
          Navigator.pop(context); 
        },
      ),
    );
  }
 Future getAllFromDirectory(String path)async{
  print(path);
  final dir = Directory(path);
  imageFileList.clear();
  imageFileList.addAll(await dir.list().toList());
 }
 FloatingActionButton testButton() {
  return FloatingActionButton(
     onPressed: () {
     },
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