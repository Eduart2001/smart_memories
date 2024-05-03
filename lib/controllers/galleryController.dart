
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:smart_memories/models/organiserModel.dart';

Future<void> pickImage(Function updateGallery) async {
  /*
    A function to pick an image from the gallery and update the gallery.

    This function requests permission to manage external storage, then opens
    the image picker to select an image from the gallery. It allows the user to select multiple images. For
    each selected image, it retrieves the file path and the parent directory
    path.
  */
  var status = await Permission.manageExternalStorage.request();
  final ImagePicker picker = ImagePicker();
  XFile? a = await picker.pickImage(source: ImageSource.gallery);
  final List<XFile>? images = await picker.pickMultipleMedia();

  for (XFile element in images!) {
    File imageFile = File(element.path);
    String directoryPath = imageFile.parent.path;
  }
}

Future<void> organiserImageController(List<FileSystemEntity> entities, List<String> organisation, bool rename, bool duplicates) async {
  /*
  A function that controls the organization of images.

  This function takes a list of [entities], which are file system entities representing images,
  a list of [organisation] strings specifying the desired organization structure,
  a boolean [rename] indicating whether to rename the images,
  and a boolean [duplicates] indicating whether to handle duplicate images.

  The function calls the [imageOrganiserModel] function to perform the actual organization of images.
  
  */
  List <FileSystemEntity> snapshot = filteredSnapshot(entities);

  await imageOrganiserModel(snapshot, organisation, rename, duplicates);
}



List compatibleFormats=["jpeg","png","jpg","gif", "webp","tiff","svg","JPG"];
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