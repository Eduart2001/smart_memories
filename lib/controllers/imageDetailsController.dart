import 'dart:io';

import 'package:smart_memories/models/imageDetailsGetter.dart';
Future<void> imageDetailsMap(Function updateImageDelails,File imageFile) async {
  Map details = await imageExifDetailsGetter(imageFile) as Map;
  updateImageDelails(details);
}

