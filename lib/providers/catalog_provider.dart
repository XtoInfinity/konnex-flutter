import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/screens/catalog/cart_screen.dart';

class CatalogProvider extends ChangeNotifier {
  bool isCategoryLoad = false,
      isProductLoad = false,
      isAddressLoad = false,
      isCartLoad = false;
  bool initCategory = true, initProduct = true, initAddress = true;
  bool isProductSearch = false;
  bool isOrder = true;

  List<Product> products = [
    Product(
        cpCost: 200,
        cpDescription: "This is a orange",
        cpDiscountCost: 150,
        cpName: "Orange",
        cpId: "1",
        cpPhoto: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFdUlevaWPqu7lObc3QkkGCZEbkRaN_yA-bw&usqp=CAU"
        ],
        cpmId: [
          "1",
        ]),
    Product(
        cpCost: 300,
        cpDescription: "This is a apple",
        cpDiscountCost: 250,
        cpName: "Apple",
        cpId: "2",
        cpPhoto: [
          "https://post.healthline.com/wp-content/uploads/2020/09/Do_Apples_Affect_Diabetes_and_Blood_Sugar_Levels-732x549-thumbnail-1-732x549.jpg"
        ],
        cpmId: [
          "2",
        ]),
    Product(
        cpCost: 100,
        cpDescription: "This is a banana",
        cpDiscountCost: 80,
        cpName: "Banana",
        cpId: "3",
        cpPhoto: [
          "https://cdn.mos.cms.futurecdn.net/42E9as7NaTaAi4A6JcuFwG-1200-80.jpg"
        ],
        cpmId: [
          "3",
        ])
  ];
  List<Product> cartProducts = [];
  List<UserAddress> userAddresses = [];
  List<Category> categories = [
    Category(
        ccName: "Fruits",
        ccPhoto:
            "https://www.healthyeating.org/images/default-source/home-0.0/nutrition-topics-2.0/general-nutrition-wellness/2-2-2-3foodgroups_fruits_detailfeature_thumb.jpg?sfvrsn=7abe71fe_4",
        ccId: 1),
    Category(
        ccName: "Vegetables",
        ccPhoto:
            "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/slideshows/powerhouse_vegetables_slideshow/650x350_powerhouse_vegetables_slideshow.jpg",
        ccId: 2),
    Category(
        ccName: "Beauty",
        ccPhoto:
            "https://post.greatist.com/wp-content/uploads/2020/04/makeup_composition_overhead-732x549-thumbnail.jpg",
        ccId: 3),
    Category(
        ccName: "Electronics",
        ccPhoto:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5jI-Xnpp2OSNPBZDcmgDnUmGZPtynYxG50xBXTnZy4UXIdg7xE6vtve7LOQgzdobUUks&usqp=CAU",
        ccId: 4)
  ];

  int currentProductPage = 1;
  String productSearchValue = '';
  int selectedAddressId, selectedProductIndex, selectedCategoryIndex;

  clearData({allData = false}) {
    // isProductLoad = true;
    // initProduct = false;
    // isProductSearch = false;
    // products.clear();
    // productSearchValue = '';
    // currentProductPage = 1;
    // selectedProductIndex = null;
    // isCartLoad = false;
    //
    // if (allData) {
    //   isCategoryLoad = true;
    //   initCategory = false;
    //   isOrder = false;
    //   cartProducts.clear();
    //   categories.clear();
    //   userAddresses.clear();
    //   initAddress = false;
    //   isAddressLoad = true;
    //
    //   selectedAddressId = null;
    //   selectedCategoryIndex = null;
    // }
  }

  addItemToCart(String productId) async {
    products.map((e) {
      if (e.cpId == productId) {
        e.quantity = 1;
        cartProducts.add(e);
      }
    }).toList();
    notifyListeners();
    //await catalogService.addItemToCart(productId);
    Get.rawSnackbar(
      message: "Product added to your cart.",
      mainButton: TextButton(
        onPressed: () {
          Get.to(() => CartScreen(), transition: Transition.rightToLeft);
        },
        child: Text(
          "View Cart",
        ),
      ),
    );
  }

  addUserAddress(UserAddress userAddress) async {
    userAddresses.clear();
    isAddressLoad = true;
    notifyListeners();
    //await catalogService.addUserAddress(userAddress);
    //getAllUserAddress();
  }

  updateCartQuantity(int quantity, Product product) async {
    products.map((e) {
      if (e.cpId == product.cpId) {
        e.quantity = quantity;
      }
    }).toList();
    cartProducts.map((e) {
      if (e.cpId == product.cpId) {
        e.quantity = quantity;
      }
    }).toList();
    notifyListeners();
    //await catalogService.updateCartQuantity(quantity, product.cartId);
  }

  deleteCartItem(Product product) async {
    cartProducts.removeWhere((element) => element.cpId == product.cpId);
    products.map((e) {
      if (e.cpId == product.cpId) {
        e.quantity = null;
        e.cartId = null;
      }
    }).toList();
    notifyListeners();
    //await catalogService.deleteCartItem(product.cartId);
  }

  notify() {
    notifyListeners();
  }
}
