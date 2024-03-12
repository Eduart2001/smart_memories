import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart';
Future<bool> duplicates(File f1, File f2)async{
  int f1_Bytes = await f1.length();
  int f2_Bytes = await f2.length();
  if(f1_Bytes!=f2_Bytes){
    print("They dont have same size: image1(${f1_Bytes} bytes), image2(${f2_Bytes} bytes)");
    return false;
  }
  Image? i1=decodeImage(f1.readAsBytesSync());
  Image? i2=decodeImage(f2.readAsBytesSync());
  if(i1!.width !=i2!.width && i1.height !=i2.height){
    print("They dont have same dimensions: image1(${i1!.width}x${i1!.height}), image2(${i2!.width}x${i2!.height})");
    return false;
  }

  int width=i1.width;
  int height=i1.height;

  int sz = (width * height > 400000) ? 400000 :width * height;

  for (var i = 0; i < sz; i++) {
    int x = Random().nextInt(width);
    int y = Random().nextInt(height);
    if(i1.getPixel(x, y)!=i2.getPixel(x, y)){
      print("They dont have same pixel value for x=${x} and y=${y}: image1(${i1.getPixel(x, y)}), image2(${i2.getPixel(x, y)})");
      return false;
    }
  }
  return true;
}