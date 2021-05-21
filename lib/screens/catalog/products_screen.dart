import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/config/constants.dart';
import 'package:konnex_aerothon/konnex/konnex.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/screens/catalog/cart_screen.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:konnex_aerothon/widgets/catalog/catalog_discount_text_widget.dart';
import 'package:konnex_aerothon/widgets/catalog/custom_error_widget.dart';
import 'package:konnex_aerothon/widgets/catalog/product_detail_bottom_sheet.dart';
import 'package:konnex_aerothon/widgets/custom_network_image.dart';
import 'package:konnex_aerothon/widgets/loading.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = '/ProductsScreen';
  productCard(int index, CatalogProvider catalogProvider) {
    Product product = catalogProvider.products[index];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            catalogProvider.selectedProductIndex = index;

            Get.bottomSheet(
              ProductDetailBottomSheet(),
              isScrollControlled: true,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    CustomNetWorkImage(
                      product.cpPhoto.length == 0 ? '' : product.cpPhoto.first,
                      assetLink: Constants.productHolderURL,
                    ),
                    if (product.cpPriority == 1 || product.cpStock == 0)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.cpStock == 0)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 6),
                                decoration: BoxDecoration(color: Colors.red),
                                child: Text(
                                  "Out of Stock",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            if (product.cpPriority == 1)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 6),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor),
                                child: Text(
                                  "Featured",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      product.cpName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(),
                    ),
                    if (product.cpDescription.length > 0)
                      Text(
                        product.cpDescription.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    const SizedBox(
                      height: 4,
                    ),
                    CatalogDiscountTextWidget(
                        product.cpCost, product.cpDiscountCost),
                    if (catalogProvider.isOrder)
                      Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: double.infinity,
                            child: product.quantity == null
                                ? RenderMetricsObject(
                                    manager: KonnexHandler.instance.manager,
                                    id: '${index}AddToCart',
                                    child: ElevatedButton(
                                      onPressed: () {
                                        catalogProvider
                                            .addItemToCart(product.cpId);
                                        LogUtil.instance.log(
                                            routeName,
                                            LogType.add_to_cart,
                                            '${product.officialId}');
                                      },
                                      child: Text("Add to Cart"),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => CartScreen(),
                                          transition: Transition.rightToLeft);
                                    },
                                    child: Text("Item in Cart"),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Get.theme.primaryColor),
                                  ),
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: catalogProvider.isProductSearch
            ? Container(
                child: TextField(
                  decoration:
                      InputDecoration.collapsed(hintText: "Enter product name"),
                  autofocus: true,
                  onChanged: (val) {
                    catalogProvider.productSearchValue = val;
                  },
                ),
              )
            : Text(
                catalogProvider
                    .categories[catalogProvider.selectedCategoryIndex].ccName,
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
        actions: [
          !catalogProvider.isProductSearch
              ? InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    catalogProvider.isProductSearch = true;
                    catalogProvider.notify();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 8),
                    child: Icon(
                      Icons.search,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    catalogProvider.productSearchValue = '';
                    catalogProvider.isProductSearch = false;
                    catalogProvider.notify();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 8),
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
          if (catalogProvider.isOrder)
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Get.to(() => CartScreen(), transition: Transition.rightToLeft);
              },
              child: RenderMetricsObject(
                manager: KonnexHandler.instance.manager,
                id: 'cartButton',
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 22),
                  alignment: Alignment.center,
                  child: Badge(
                    badgeContent: Text(
                      catalogProvider.cartProducts.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    position: BadgePosition.bottomEnd(),
                    showBadge: catalogProvider.cartProducts.length != 0,
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: catalogProvider.isProductLoad
          ? CustomLoading()
          : Container(
              child: catalogProvider.products.length == 0
                  ? CustomErrorWidget(
                      title: "No products found",
                      iconData: MdiIcons.shopping,
                    )
                  : GridView.builder(
                      itemCount: catalogProvider.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1 / 1.4,
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: Get.height * 0.02),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      itemBuilder: (context, index) {
                        return productCard(index, catalogProvider);
                      },
                    ),
            ),
      floatingActionButton: KonnexWidget(currentRoute: routeName),
    );
  }
}
