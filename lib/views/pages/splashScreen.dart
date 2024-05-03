import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_memories/controllers/organiserController.dart';

class SplashScreen extends StatefulWidget {
  final FieldProvider fP;
  final List<FileSystemEntity> entities;

  const SplashScreen({
    super.key,
    required this.fP,
    required this.entities,
  });
  @override
  _SplashScreenState createState() => _SplashScreenState(fP, entities);
}

class _SplashScreenState extends State<SplashScreen> {
  final FieldProvider fP;
  final List<FileSystemEntity> entities;
  _SplashScreenState(this.fP, this.entities);
  @override
  void initState() {
    super.initState();
    _computeStuff().then((_) {
      Navigator.of(context).pop();
    });
  }

  Future<void> _computeStuff() async {
    await fP.submitFormController(entities);
    // Simulating computation time with a Future delay
    return Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Image(
            image: AssetImage('assets/icons/SMLogo.png'),
            width:  MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height *
                    0.6),
          Text("\n\n"
          ),
          Text(
            "This operation may take some time since, we are computing : ${widget.entities.where((entity) => entity is File).toList().length} images",
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text("\n\n"
          ),
          Text(
            jokes[Random().nextInt(jokes.length)],
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}

List<String> jokes = [
  "What did the Buddhist say to the hot dog vendor? \n \"Make me one with everything.\"",
  "What do you call a fake noodle? \n An impasta.",
  "Why can't you explain puns to kleptomaniacs? \n Because they always take things literally.",
  "Why did the hipster burn his mouth? \n He drank the coffee before it was cool.",
  "Why did the nurse need a red pen? \n In case she needed to draw blood.",
  "Why don't calculus majors throw house parties? \n Because they don't want their guests to drink and derive.",
  "What's the best thing about Switzerland? \n I don't know but the flag is a big plus.",
  "Want to hear a construction joke? \n Oh never mind, I'm still working on that one.",
  "Why don't scientists trust atoms? \n Because they make up everything.",
  "I poured root beer in a square glass. Now I just have beer.",
  "What did the bald man exclaim when he received a comb for a present? \n \"Thanks—I'll never part with it.\"",
  "Why did the yogurt go to the art exhibition? \n Because it was cultured.",
  "Why should the number 288 never be mentioned? \n It's two gross.",
  "Rest in peace, boiling water. You will be mist.",
  "I told my wife she was drawing her eyebrows too high. She looked at me surprised.",
  "What does Charles Dickens keep in his spice rack? \n The best of thymes, the worst of thymes.",
  "Have you heard about the new restaurant called Karma? \n There's no menu. You just get what you deserve.",
  "How does a rabbi make coffee? \n Hebrews it.",
  "What's red and moves up and down? \n A tomato in an elevator.",
  "What do you call a parade of rabbits hopping backwards? \n A receding hare-line.",
  "What is Forrest Gump's password? \n 1Forrest1.",
  "What did the shark say when he ate the clownfish? \n \"This tastes a little funny.\"",
  "Why do French people eat snails? \n They don't like fast food.",
  "What sits at the bottom of the sea and twitches? \n A nervous wreck.",
  "Why can't male ants sink? \n They're buoy-ant.",
  "What is an astronaut's favorite part on a computer? \n The space bar.",
  "Did you hear about the mathematician who's afraid of negative numbers? \n He'll stop at nothing to avoid them.",
  "Why can't you hear a pterodactyl go to the bathroom? \n Because the \"P\" is silent.",
  "Why do we tell actors to \"break a leg? \n\" Because every play has a cast.",
  "What does the man on the moon do when his hair gets too long? \n Eclipse it.",
  "What did 0 say to 8? \n \"Nice belt.\"",
  "What kind of exercise do lazy people do? \n Diddly-squats.",
  "What's a private investigator's favorite shoe? \n Sneak-ers.",
  "Did you hear they arrested the devil? \n Yeah, they got him on possession",
  "What did one DNA say to the other DNA? \n “Do these genes make me look fat? \n”",
  "My IQ test results came back. They were negative.",
  "What do you get when you cross a polar bear with a seal? \n A polar bear.",
  " Why can’t you trust an atom? \n Because they make up literally everything",
  "Why was six afraid of seven? \n Because seven eight nine.",
  "What do you call a hippie’s wife? \n Mississippi.",
  " What’s the difference between an outlaw and an in-law? \n Outlaws are wanted.",
  " Scientists have recently discovered a food that greatly reduces sex drive. It’s called wedding cake",
  "Before you marry a person, you should first make them use a computer with a slow Internet connection to see who they really are.",
  "I never knew what happiness was until I got married—and then it was too late.",
  " Some men say they don’t wear their wedding band because it cuts off circulation. Well, that’s the point, isn’t it? \n",
  " Advice to husbands: Try praising your wife now and then, even if it does startle her at first."
];
