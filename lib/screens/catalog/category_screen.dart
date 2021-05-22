import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/config/constants.dart';
import 'package:konnex_aerothon/konnex/konnex.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';
import 'package:konnex_aerothon/konnex/models/instruction_set.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/screens/catalog/cart_screen.dart';
import 'package:konnex_aerothon/screens/catalog/products_screen.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:konnex_aerothon/widgets/custom_network_image.dart';
import 'package:konnex_aerothon/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/CategoryScreen';

  categoryCard(int index, CatalogProvider catalogProvider) {
    Category category = catalogProvider.categories[index];

    return RenderMetricsObject(
      id: '$index',
      manager: KonnexHandler.instance.manager,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            catalogProvider.clearData();
            catalogProvider.selectedCategoryIndex = index;
            Get.to(() => ProductsScreen(), transition: Transition.rightToLeft);
          },
          child: Column(
            children: [
              Expanded(
                child: CustomNetWorkImage(
                  category.ccPhoto,
                  assetLink: Constants.productHolderURL,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  category.ccName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
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
        title: GestureDetector(
          onTap: () {
            // pushNavigationsInFirestore();
            GetStorage().write('seen-announcements', 'value');
          },
          child: Text(
            "Catalog",
            style: TextStyle(
              color: Get.theme.primaryColor,
            ),
          ),
        ),
        actions: [
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
      body: catalogProvider.isCategoryLoad
          ? CustomLoading()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: catalogProvider.categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 1.2,
                            crossAxisSpacing: Get.width * 0.03,
                            mainAxisSpacing: Get.height * 0.02),
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: categoryCard(index, catalogProvider),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: KonnexWidget(currentRoute: routeName),
    );
  }
}
