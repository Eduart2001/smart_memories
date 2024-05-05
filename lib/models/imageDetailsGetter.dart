import 'package:exif/exif.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';
import 'package:geocoding/geocoding.dart';

Future<Map<String, String>> imageExifDetailsGetter(File file) async {
  /*
      Retrieves the EXIF details of an image file and returns them as a map.
  
      The [file] parameter is the file object representing the image.
  
      Returns a [Future] that completes with a map containing the image details.
    */
  final fileBytes = file.readAsBytesSync();

  final data = await readExifFromBytes(fileBytes);
  if (data.isEmpty) {
    print("No EXIF information found");
    return {};
  }
  Map<String, String> filtredData = {};
  filtredData["Name"] = basename(file.path);
  filtredData["Image Model"] = data["Image Model"].toString();
  filtredData["Size"] =
      "${data["Image ImageWidth"]}x ${data["Image ImageLength"]} pixels";
  filtredData["Created Date"] = data["EXIF DateTimeOriginal"].toString();
  filtredData["Location"] = await getCountry(data);
  return filtredData;
}

Future<String> getCountry(Map data) async {
  /*
      Retrieves the country name from the GPS coordinates of an image.
  
      The [data] parameter is a map containing the EXIF details of the image.
  
      Returns a [Future] that completes with the country name.
    */
  try {
    List latitudeGPSList = data['GPS GPSLatitude']!.values.toList();
    List longitudeGPSList = data['GPS GPSLongitude']!.values.toList();

    int ns = (data['GPS GPSLatitudeRef'].toString() == "N") ? 1 : -1;
    int ew = (data['GPS GPSLongitudeRef'].toString() == "E") ? 1 : -1;
    double latitude = (ns *
            (latitudeGPSList[0].toDouble() +
                latitudeGPSList[1].toDouble() / 60 +
                latitudeGPSList[2].toDouble() / 3600))
        .toDouble();
    double longitude = (ew *
            (longitudeGPSList[0].toDouble() +
                longitudeGPSList[1].toDouble() / 60 +
                longitudeGPSList[2].toDouble() / 3600))
        .toDouble();

    List<Placemark> newPlace =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark placeMark = newPlace[0];
    return placeMark.country!;
  } catch (e) {
    print(e);
    return "";
  }
}
