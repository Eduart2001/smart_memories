import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_memories/views/pages/homePage.dart';


class OnBoardingController extends GetxController {
  /* 
    Controller class for the onboarding process.
  */
  static OnBoardingController get instace => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;


  void updatePageIndicator(index) {
    /* 
      Updates the current page indicator to the given index.
    */
    currentPageIndex.value = index;
  }


  void dotNavigationClick(index) {
    /* 
      Handles the click event on the dot navigation.
      Updates the current page index and jumps to the corresponding page.
    */
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }


  void nextPage(BuildContext context) async {
    /* 
      Moves to the next page in the onboarding process.
      If the current page is the last page, it sets the 'showOnboarding' flag to false in SharedPreferences,
      pops the current route, and navigates to the home page.
      Otherwise, it increments the current page index and jumps to the next page.
    */
    if (currentPageIndex.value == 4) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showOnboarding', false);
      Navigator.pop(context);
      Get.to(const HomePage());
    } else {
      currentPageIndex.value += 1;
      pageController.jumpToPage(currentPageIndex.value);
    }
  }
  void skipPage() {
    /* 
      Skips to the last page in the onboarding process.
      Sets the current page index to 4 and jumps to the last page.
    */
    currentPageIndex.value = 4;
    pageController.jumpToPage(4);
  }
}
