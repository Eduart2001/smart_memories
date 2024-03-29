import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_memories/controllers/onboardingController.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
class OnBoardingPage extends StatelessWidget{
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context){
    final controller = Get.put(OnBoardingController());

    return  Scaffold(
      body: Stack(
        children: [
          /// Page scroll
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPageWidget(image:'assets/icons/test-a.gif',title: "TEST",description: "test"),
              OnBoardingPageWidget(image:'assets/icons/test-a.gif',title: "TEST1",description: "test1"),
              OnBoardingPageWidget(image:'assets/icons/test-a.gif',title: "TEST2",description: "test2"),
              OnBoardingPageWidget(image:'assets/icons/test-a.gif',title: "TEST3",description: "test3"),
            ],
          
          ),
          /// Skip button
          const OnBoardSkipWidget(),
          /// Page indicator
          const PageIndicatorWidget(),
          /// Next page Button 
          const NextButtonWidget(),
        
        ],
      ),
    );
  }

}

class NextButtonWidget extends StatelessWidget {
  const NextButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool theme=(Theme.of(context).brightness==Brightness.dark)?true:false;
    return Positioned(
      bottom: kBottomNavigationBarHeight-25,
      right: 10.0,
      child: ElevatedButton(
        onPressed: ()=>OnBoardingController.instace.nextPage(),
        style: ElevatedButton.styleFrom(shape: const CircleBorder(),backgroundColor:theme ?Colors.white:Colors.black),
        child: const Icon(CupertinoIcons.arrow_right),
      )
      
    );
  }
}

class PageIndicatorWidget extends StatelessWidget {
  const PageIndicatorWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {

    final bool theme=(Theme.of(context).brightness==Brightness.dark)?true:false;
    final controller = OnBoardingController.instace;
    return Positioned(
      bottom: kBottomNavigationBarHeight,
      left: pageSize(context).width/2-4*16,
      child: SmoothPageIndicator(controller: controller.pageController, onDotClicked: controller.dotNavigationClick,count: 4,effect:ExpandingDotsEffect(dotHeight: 6,activeDotColor: theme ?Colors.white:Colors.black),)
    );
  }
}

class OnBoardSkipWidget extends StatelessWidget {
  const OnBoardSkipWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top:kToolbarHeight, right:10.0,child: TextButton(onPressed: ()=> OnBoardingController.instace.skipPage(),child: const Text("Skip"),));
  }
}

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    super.key,required this.title, required this.description, required this.image
  });
  final String image, title, description ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(8.0),
    
    child :Column(
          children: [
            Image(
            
              width: pageSize(context).width*0.8,
              height: pageSize(context).height*0.6,
              image: AssetImage(image),
            ),
            Text(title,textAlign: TextAlign.center),
            const SizedBox(
              height: 24.0,
            ),
            Text(description,textAlign: TextAlign.center,)
          ],
        ),
    );
  }
}


Size pageSize(BuildContext context){
  return MediaQuery.of(Get.context!).size;
}