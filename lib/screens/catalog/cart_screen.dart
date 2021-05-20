import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/screens/catalog/address_screen.dart';
import 'package:konnex_aerothon/screens/catalog/order_confirmed_screen.dart';
import 'package:konnex_aerothon/widgets/bottom_button.dart';
import 'package:konnex_aerothon/widgets/catalog/catalog_discount_text_widget.dart';
import 'package:konnex_aerothon/widgets/catalog/custom_error_widget.dart';
import 'package:konnex_aerothon/widgets/catalog/home_delivery_section.dart';
import 'package:konnex_aerothon/widgets/catalog/pickup_section.dart';
import 'package:konnex_aerothon/widgets/dialog.dart';
import 'package:konnex_aerothon/widgets/loading.dart';

import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Your Cart",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      body: catalogProvider.cartProducts.length == 0
          ? CustomErrorWidget(
              title: "No products in your cart ",
              iconData: Icons.shopping_cart_outlined,
            )
          : catalogProvider.isCartLoad
              ? CustomLoading()
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              _AddressSection(),
                              ListView.builder(
                                itemCount: catalogProvider.cartProducts.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _CartItem(index);
                                },
                              ),
                              _PriceDetailSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BottomButton(
                      onTap: () {
                        if (catalogProvider.selectedAddressId == null) {
                          Get.rawSnackbar(
                              message: "Please add a delivery address",
                              mainButton: TextButton(
                                child: Text("Add Address"),
                                onPressed: () {
                                  Get.to(() => AddressScreen(),
                                      transition: Transition.rightToLeft);
                                },
                              ));
                        } else {
                          Get.dialog(CustomDialog(
                            "Confirm Order",
                            "Do you want to confirm this order? You cannot cancel this order once it is confirmed.",
                            positiveButtonText: "Confirm Order",
                            positiveButtonOnTap: () {
                              Get.close(1);
                              Get.to(OrderConfirmedScreen());
                            },
                          ));
                        }
                      },
                      text: "Place Order",
                    )
                  ],
                ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    UserAddress userAddress;

    if (catalogProvider.selectedAddressId != null &&
        catalogProvider.selectedAddressId > 0) {
      catalogProvider.userAddresses.map((e) {
        if (e.addressId == catalogProvider.selectedAddressId) {
          userAddress = e;
        }
      }).toList();
    }

    if (catalogProvider.selectedAddressId != null) {
      return Card(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              catalogProvider.selectedAddressId == 0
                  ? PickupSection(() {}, 0)
                  : HomeDeliverySection(
                      () {},
                      catalogProvider.selectedAddressId,
                      catalogProvider.selectedAddressId,
                      userAddress),
              const SizedBox(
                height: 4,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => AddressScreen(),
                      transition: Transition.rightToLeft);
                },
                child: Text("Change or Add Address"),
              )
            ],
          ),
        ),
      );
    } else {
      return Card(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Text("To continue to place order, please add your address."),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => AddressScreen(),
                      transition: Transition.rightToLeft);
                },
                child: Text("Add Delivery Type"),
              )
            ],
          ),
        ),
      );
    }
  }
}

class _CartItem extends StatelessWidget {
  final int index;

  _CartItem(this.index);

  quantityButton(bool isAdd, CatalogProvider catalogProvider, int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: InkWell(
        onTap: () {
          if (isAdd) {
            catalogProvider.updateCartQuantity(
                catalogProvider.cartProducts[index].quantity + 1,
                catalogProvider.cartProducts[index]);
          } else {
            if (catalogProvider.cartProducts[index].quantity != 1) {
              catalogProvider.updateCartQuantity(
                  catalogProvider.cartProducts[index].quantity - 1,
                  catalogProvider.cartProducts[index]);
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            isAdd ? Icons.add : Icons.remove,
            color: Colors.black,
            size: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);
    Product product = catalogProvider.cartProducts[index];

    return Card(
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.network(
                          product.cpPhoto.length == 0
                              ? ''
                              : product.cpPhoto.first,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.cpName,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          product.cpDescription,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        CatalogDiscountTextWidget(
                            product.cpCost * product.quantity,
                            product.cpDiscountCost * product.quantity)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        quantityButton(false, catalogProvider, index),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(product.quantity.toString())),
                        quantityButton(true, catalogProvider, index),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.black26,
            width: double.infinity,
            height: 0.5,
          ),
          InkWell(
            onTap: () {
              catalogProvider.deleteCartItem(product);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.black38,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text("Remove"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PriceDetailSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    int totalCostWithoutDiscount = 0;
    int totalCost = 0;

    catalogProvider.cartProducts.map((e) {
      totalCostWithoutDiscount += e.cpCost * e.quantity;
      totalCost += e.cpDiscountCost == 0
          ? e.cpCost * e.quantity
          : e.cpDiscountCost * e.quantity;
    }).toList();

    return Card(
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              "PRICE DETAILS",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.black26,
            width: double.infinity,
            height: 0.5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Price (${catalogProvider.cartProducts.length} items)"),
                    Text("₹$totalCostWithoutDiscount")
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                if (totalCostWithoutDiscount - totalCost > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Discount"),
                      Text(
                        "₹${totalCostWithoutDiscount - totalCost}",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 16),
            color: Colors.black26,
            width: double.infinity,
            height: 0.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "₹$totalCost",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            color: Colors.black26,
            width: double.infinity,
            height: 0.5,
          ),
          if (totalCostWithoutDiscount - totalCost > 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "You will save ₹${totalCostWithoutDiscount - totalCost} on this order",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            )
        ],
      ),
    );
  }
}
