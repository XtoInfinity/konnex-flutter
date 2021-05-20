import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/config/constants.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/screens/catalog/image_view_screen.dart';
import 'package:konnex_aerothon/widgets/catalog/catalog_discount_text_widget.dart';
import 'package:konnex_aerothon/widgets/custom_divider.dart';
import 'package:konnex_aerothon/widgets/custom_network_image.dart';
import 'package:provider/provider.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  imageCard(String url) {
    return InkWell(
      onTap: () => Get.to(() => ImageViewScreen(url)),
      child: CustomNetWorkImage(
        url,
        assetLink: Constants.productHolderURL,
      ),
    );
  }

  optionCard(String title, IconData iconData, Function onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Get.theme.primaryColor,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);
    Product product =
        catalogProvider.products[catalogProvider.selectedProductIndex];

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 250.0,
                width: double.infinity,
                child: product.cpPhoto.length == 0
                    ? CustomNetWorkImage(
                        '',
                        assetLink: Constants.productHolderURL,
                      )
                    : Carousel(
                        images: product.cpPhoto.map((e) {
                          return imageCard(e);
                        }).toList(),
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Get.theme.accentColor,
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.transparent,
                        borderRadius: false,
                        autoplay: false,
                      ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (product.cpPriority == 1 || product.cpStock == 0)
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.cpStock == 0)
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        decoration: BoxDecoration(color: Colors.red),
                        child: Text(
                          "Out of Stock",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    if (product.cpPriority == 1)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        decoration:
                            BoxDecoration(color: Get.theme.primaryColor),
                        child: Text(
                          "Featured",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            Text(
              product.cpName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(product.cpDescription),
            const SizedBox(
              height: 8,
            ),
            CatalogDiscountTextWidget(product.cpCost, product.cpDiscountCost),
            const SizedBox(
              height: 16,
            ),
            CustomDivider(),
            optionCard("Share", Icons.share, () {}),
          ],
        ),
      ),
    );
  }
}
