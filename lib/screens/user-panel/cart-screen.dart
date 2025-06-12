// ignore_for_file: file_names, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/models/cart-model.dart';
import 'package:e_comm/screens/user-panel/checkout-screen.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Utility to clean price strings before parsing to double
  double parsePrice(String priceStr) {
    String cleaned = priceStr.replaceAll(',', '').replaceAll('LKR', '').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          title: const Text('Cart Screen'),
        ),
        body: const Center(
          child: Text('User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text('Cart Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading cart"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(child: CupertinoActivityIndicator()),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found!"));
          }

          // Map Firestore docs to CartModel list
          List<CartModel> cartItems = snapshot.data!.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return CartModel(
              productId: data['productId'] ?? '',
              categoryId: data['categoryId'] ?? '',
              productName: data['productName'] ?? '',
              categoryName: data['categoryName'] ?? '',
              salePrice: data['salePrice'] ?? '',
              fullPrice: data['fullPrice'] ?? '',
              productImages: List<String>.from(data['productImages'] ?? []),
              deliveryTime: data['deliveryTime'] ?? '',
              isSale: data['isSale'] ?? false,
              productDescription: data['productDescription'] ?? '',
              createdAt: data['createdAt'],
              updatedAt: data['updatedAt'],
              productQuantity: data['productQuantity'] ?? 0,
              productTotalPrice: (data['productTotalPrice'] is int)
                  ? (data['productTotalPrice'] as int).toDouble()
                  : (data['productTotalPrice'] ?? 0.0),
            );
          }).toList();

          // Calculate total amount of all cart items
          double totalAmount = 0.0;
          for (var item in cartItems) {
            totalAmount += item.productTotalPrice;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final cartModel = cartItems[index];

                    return SwipeActionCell(
                      key: ObjectKey(cartModel.productId),
                      trailingActions: [
                        SwipeAction(
                          title: "Delete",
                          forceAlignmentToBoundary: true,
                          performsFirstActionWithFullSwipe: true,
                          onTap: (handler) async {
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(user!.uid)
                                .collection('cartOrders')
                                .doc(cartModel.productId)
                                .delete();
                          },
                        ),
                      ],
                      child: Card(
                        elevation: 5,
                        color: AppConstant.appTextColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appMainColor,
                            backgroundImage:
                                NetworkImage(cartModel.productImages.isNotEmpty
                                    ? cartModel.productImages[0]
                                    : ''),
                          ),
                          title: Text(cartModel.productName),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "LKR ${cartModel.productTotalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: Get.width / 20),
                              // Decrement button
                              GestureDetector(
                                onTap: () async {
                                  if (cartModel.productQuantity > 1) {
                                    int newQty = cartModel.productQuantity - 1;
                                    double price = parsePrice(cartModel.fullPrice);
                                    double newTotal = price * newQty;

                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .update({
                                      'productQuantity': newQty,
                                      'productTotalPrice': newTotal,
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: const Icon(Icons.remove, size: 16),
                                ),
                              ),
                              SizedBox(width: Get.width / 40),
                              // Quantity display
                              Text(
                                cartModel.productQuantity.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: Get.width / 40),
                              // Increment button
                              GestureDetector(
                                onTap: () async {
                                  int newQty = cartModel.productQuantity + 1;
                                  double price = parsePrice(cartModel.fullPrice);
                                  double newTotal = price * newQty;

                                  await FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productId)
                                      .update({
                                    'productQuantity': newQty,
                                    'productTotalPrice': newTotal,
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: const Icon(Icons.add, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: const Border(
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: LKR ${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Material(
                      child: Container(
                        width: Get.width / 2,
                        height: Get.height / 18,
                        decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Get.to(()=> CheckoutScreen());
                          },
                          child: Text(
                            "Checkout",
                            style: TextStyle(color: AppConstant.appTextColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
