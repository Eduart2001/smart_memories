import 'dart:io';

import 'package:smart_memories/models/imageDetailsGetter.dart';

Future<void> imageDetailsMap(Function updateImageDetails, File imageFile) async {
  /*
    Retrieves the details of an image using its EXIF data and updates them using the provided [updateImageDetails] function.

    The [imageFile] parameter is the file object representing the image.

    Returns a [Future] that completes when the image details have been retrieved and updated.
  
  */
  Map details = await imageExifDetailsGetter(imageFile) as Map;
  updateImageDetails(details);
}
