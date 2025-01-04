import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void showTutorial(BuildContext context, List<GlobalKey> keys) {

  final tutorialController = TutorialCoachMark(targets: []);
  
  TutorialCoachMark(
    targets: [
      TargetFocus(
        identify: "profile_icon",
        keyTarget: keys[0],
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              children: [
                Text(
                  "This is your profile icon. Tap here to view your profile.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "balance",
        keyTarget: keys[1],
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child:  const Column(
              children: [
                Text(
                  "Here you can see your current balance.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "send_money_button",
        keyTarget: keys[2],
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              children: [
                Text(
                  "Use this button to send money to others.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "person_icon",
        keyTarget: keys[3],
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              children: [
                Text(
                  "These are your list of transaction.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
    colorShadow: Colors.black.withOpacity(0.7),
    onFinish: () {
      debugPrint("Tutorial finished");
    },
    onSkip: () {
      print("skip");
      return true;
    },
  ).show(context: context);
}
