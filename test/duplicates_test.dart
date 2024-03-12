import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_memories/source/duplicates.dart';
void main() {
    test('Duplicates should return "True"', () async{
      //testing on the same image 
      File f1 = File("test/test-images/1.png");
      File f2 = File("test/test-images/1.png");

      bool result = await duplicates(f1, f2);

      expect(result, true);
      
    });
    test('Duplicates should return "False" not the same size', () async{
      //same image 
      File f1 = File("test/test-images/1.png");
      File f2 = File("test/test-images/2.png");

      bool result = await duplicates(f1, f2);

      expect(result, false);
      
    });
    test('Duplicates should return "False" not the same Image', () async{
      //the image 3.png and image 4.png have the same size = 3,731 bytes and same dimensions(612x792) 
      //but the rectangle in the image 4 is placed in different place
      File f1 = File("test/test-images/3.png");
      File f2 = File("test/test-images/4.png");

      bool result = await duplicates(f1, f2);

      expect(result, false);
      
    });
    test('Duplicates should return "False" not the same Image2', () async{
      //the image 5.png and image 6.png have the same size = 3671 bytes and same dimensions(612x792) 
      //but different color #FF0000 for image 5 and #FF0001 for image 6
      File f1 = File("test/test-images/5.png");
      File f2 = File("test/test-images/6.png");

      bool result = await duplicates(f1, f2);

      expect(result, false);
      
    });
}

