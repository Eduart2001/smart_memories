import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_memories/views/pages/homePage.dart';

class OnBoardingController extends GetxController{

  static OnBoardingController get instace => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex=0.obs;

  void updatePageIndicator(index){
    currentPageIndex.value=index;
  }
  void dotNavigationClick(index){
    currentPageIndex.value=index;
    pageController.jumpTo(index);
  }
  void nextPage(BuildContext context){
    if(currentPageIndex.value==3){
      Navigator.pop(context);
      Get.to(const HomePage());
    }else{
      currentPageIndex.value+=1;
      pageController.jumpToPage(currentPageIndex.value);
    }
  }
  void skipPage(){
    currentPageIndex.value=3;
    pageController.jumpToPage(3);
  }
}