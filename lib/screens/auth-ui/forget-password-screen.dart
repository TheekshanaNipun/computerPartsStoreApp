// ignore_for_file: file_names, avoid_unnecessary_containers, unused_local_variable

import 'package:e_comm/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/forget-password-controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());
  TextEditingController userEmail = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          centerTitle: true,
          title: Text(
            "Forget Password",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              isKeyboardVisible
                  ? Text("Welcome to Shopping Store")
                  : Column(
                      children: [
                        Lottie.asset(
                            'assets/animations/Animation - 1740225746177.json')
                      ],
                    ),
              SizedBox(
                height: Get.height / 12,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: userEmail,
                    cursorColor: AppConstant.appSecondaryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                ),
              ),
            
              SizedBox(
                height: Get.height / 12,
              ),
              Material(
                child: Container(
                  width: Get.width / 2,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Forget",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      ),
                    ),
                    onPressed: () async {
                      String email = userEmail.text.trim();
                      

                      if (email.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter all details.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appSecondaryColor,
                          colorText: AppConstant.appTextColor,
                        );
                      } else{
                        String email =userEmail.text.trim();
                        forgetPasswordController.ForgetPasswordMethod(email);
                      } 
                    },
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              
            ],
          ),
        ),
      );
    });
  }
}
