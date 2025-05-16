// ignore_for_file: must_be_immutable, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/models/product-model.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import 'product-details-screen.dart';

class AllSingleCategoryProductsScreen extends StatefulWidget {
  String categoryId;
  AllSingleCategoryProductsScreen({super.key, required this.categoryId});

  @override
  State<AllSingleCategoryProductsScreen> createState() =>
      _AllSingleCategoryProductsScreenState();
}

class _AllSingleCategoryProductsScreenState
    extends State<AllSingleCategoryProductsScreen> {
  String? selectedBrand;
  List<String> brandList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConstant.appTextColor,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Products',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: widget.categoryId)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Products Found!"),
            );
          }

          if (snapshot.data != null) {
            final allDocs = snapshot.data!.docs;

            // Populate brand list once
            if (brandList.isEmpty) {
              for (var doc in allDocs) {
                final brand = doc['brandName'];
                if (brand != null && !brandList.contains(brand)) {
                  brandList.add(brand);
                }
              }
            }

            // Filter docs based on selected brand
            final filteredDocs = selectedBrand == null
                ? allDocs
                : allDocs
                    .where((doc) => doc['brandName'] == selectedBrand)
                    .toList();

            return Column(
              children: [
                // Brand Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: brandList.map((brand) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilterChip(
                          label: Text(brand),
                          selected: selectedBrand == brand,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedBrand = selected ? brand : null;
                            });
                          },
                          selectedColor: AppConstant.appMainColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Product Grid
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredDocs.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.80,
                    ),
                    itemBuilder: (context, index) {
                      final productData = filteredDocs[index];
                      ProductModel productModel = ProductModel(
                        productId: productData['productId'],
                        categoryId: productData['categoryId'],
                        productName: productData['productName'],
                        categoryName: productData['categoryName'],
                        salePrice: productData['salePrice'],
                        fullPrice: productData['fullPrice'],
                        productImages:
                            List<String>.from(productData['productImages']),
                        deliveryTime: productData['deliveryTime'],
                        isSale: productData['isSale'],
                        productDescription: productData['productDescription'],
                        createdAt: productData['createdAt'],
                        updatedAt: productData['updatedAt'],
                        brandName: productData['brandName'],
                      );

                      return GestureDetector(
                        onTap: () => Get.to(
                          () =>
                              ProductDetailsScreen(productModel: productModel),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            child: FillImageCard(
                              borderRadius: 20.0,
                              width: Get.width / 2.3,
                              heightImage: Get.height / 5,
                              imageProvider: CachedNetworkImageProvider(
                                productModel.productImages[0],
                              ),
                              title: Center(
                                child: Text(
                                  productModel.productName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
