import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:smart_memories/controllers/onboardingController.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
              OnBoardingPageWidget(image:OnBoardingHelpUtils.image1,title: OnBoardingHelpUtils.title1,description: OnBoardingHelpUtils.description1),
              OnBoardingPageWidget(image:OnBoardingHelpUtils.image2,title: OnBoardingHelpUtils.title2,description: OnBoardingHelpUtils.description2),
              OnBoardingPageWidget(image:OnBoardingHelpUtils.image3,title: OnBoardingHelpUtils.title3,description: OnBoardingHelpUtils.description3),
              OnBoardingPageWidget(image:OnBoardingHelpUtils.image4,title: OnBoardingHelpUtils.title4,description: OnBoardingHelpUtils.description4),
              OnBoardingPageDemoWidget(image:OnBoardingHelpUtils.image5,title: OnBoardingHelpUtils.title5,description: OnBoardingHelpUtils.description5),
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
        onPressed: ()=>OnBoardingController.instace.nextPage(context),
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
      child: SmoothPageIndicator(controller: controller.pageController, onDotClicked: controller.dotNavigationClick,count: 5,effect:ExpandingDotsEffect(dotHeight: 6,activeDotColor: theme ?Colors.white:Colors.black),)
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
            Text(title,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 24.0,
            ),
            Text(description,textAlign: TextAlign.justify,)
          ],
        ),
    );
  }
}

class OnBoardingPageDemoWidget extends StatelessWidget {
  const OnBoardingPageDemoWidget({
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
            Text(title,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 10.0,
            ),
            Text(description,textAlign: TextAlign.justify,),
            TextButton(onPressed:()async{
              Uri url= Uri.parse("https://drive.google.com/drive/folders/1UV5NHV4SJfLr8IkOBhl0cLebsTJpcQEr?usp=sharing");
              if (!await launchUrl(url)) {
                throw Exception('Could not launch https://drive.google.com/drive/folders/1UV5NHV4SJfLr8IkOBhl0cLebsTJpcQEr?usp=sharing');
              }

            }, child: Text("To Google Drive"))
          ],
        ),
    );
  }
}

class OnBoardingHelpUtils{
  

  // Pages Titles 

   static const String title1="Choose an image directory";
   static const String title2 ="Choose the one of the actions";
   static const String title3 ="Chose between the options";
   static const String title4 ="Confirm and wait the magie to happen";
   static const String title5 ="For the demo purpose";


   //Pages  Descriptions 

   static const String description1="Navigate to one of the image folders you would like to work";
   static const String description2 ="Cherry-pick one of the following actions : \n - Gallery \n - Organisation \n \n (*note: for this tutorial the Organisation action is selected)";
   static const String description3 ="Select how you would like to organise your images, by year, month, day, location, created date and also isolate duplicates";
   static const String description4 ="Depending on the size of the directory it might take a while to load all the images. \n *** Warning: By using this app, you acknowledge and accept that you do so at your own risk. We shall not be liable for any damages or losses resulting from the use of this app. Please use it responsibly and exercise caution while using its features. ***";
   static const String description5 ="To avoid any data loss, please download these images and make changes on this demo folder\n These images have been taken from the internet  and they are used only used to manipulate with the application. Their exif data has been modified by a scrip, writen by us. \n To download the images just follow the link and download frome Google Drive.";
  // Image 

  static const String image1 = 'assets/onBoardingTutorial/tutorial1.gif';
  static const String image2= 'assets/onBoardingTutorial/button-options.png';
  static const String image3 = 'assets/onBoardingTutorial/options.gif';
  static const String image4 = 'assets/onBoardingTutorial/results-tutorial.gif';
  static const String image5 = 'assets/onBoardingTutorial/download.jpg';

}


Size pageSize(BuildContext context){
  return MediaQuery.of(Get.context!).size;
}