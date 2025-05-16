// ignore_for_file: file_names, sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/models/product-model.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import 'product-details-screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
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
          'All Products',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: false)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products Found!"),
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

            // Filter docs by selected brand
            final filteredDocs = selectedBrand == null
                ? allDocs
                : allDocs
                    .where((doc) => doc['brandName'] == selectedBrand)
                    .toList();

            return Column(
              children: [
                // Filter Chips Row
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
                        brandName: productData['brandName'],
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
                      );

                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(() => ProductDetailsScreen(
                                productModel: productModel)),
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
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  footer: Center(
                                    child:
                                        Text("LKR: ${productModel.fullPrice}"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
