import 'package:e_comm/screens/user-panel/all-categories-screen.dart';
import 'package:e_comm/screens/user-panel/all-flash-sale-products.dart';
import 'package:e_comm/screens/user-panel/all-products-screen.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:e_comm/widgets/category-widget.dart';
import 'package:e_comm/widgets/custom-drawer-widget.dart';
import 'package:e_comm/widgets/flash-sale-widget.dart';
import 'package:e_comm/widgets/heading-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/all-products-widget.dart';
import '../../widgets/banner-widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 90.0,
              ),
              //banner
              BannerWidget(),

              //heading
              HeadingWidget(
                headingTitle: "Categories",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See More >>",
              ),
              
              CategoriesWidhet(),

              //heading
              HeadingWidget(
                headingTitle: "Flash Sale",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllFlashSaleProductsScreen()),
                buttonText: "See More >>",
              ),

              FlashSaleWidget(),

              //heading
              HeadingWidget(
                headingTitle: "All Products",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllProductsScreen()),
                buttonText: "See More >>",
              ),

              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
