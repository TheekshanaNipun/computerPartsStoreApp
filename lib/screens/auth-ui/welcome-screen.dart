// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:e_comm/screens/auth-ui/sign-in-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/google-sign-in-controller.dart';
import '../../utils/app-constant.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appSecondaryColor,
        title: Text(
          "Welcome to Computer Parts Store",
          style: TextStyle(
            color: AppConstant.appTextColor,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: LottieBuilder.asset(
                  'assets/animations/Animation - 1740225746177.json'),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                "Let's Build!",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 12,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Image.asset(
                    'assets/images/google_2504739.png',
                    width: Get.width / 12,
                    height: Get.height / 12,
                  ),
                  label: Text(
                    "Sign in With Google",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                    ),
                  ),
                  onPressed: () {
                    _googleSignInController.signInWithGoogle();
                  },
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 50,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Icon(
                    Icons.email,
                    color: AppConstant.appTextColor,
                  ),
                  label: Text(
                    "Sign in With Email",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                    ),
                  ),
                  onPressed: () {
                    Get.to(()=> SignInScreen());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
