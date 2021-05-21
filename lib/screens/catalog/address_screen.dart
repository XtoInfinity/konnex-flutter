import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/konnex/konnex.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/screens/catalog/add_address_screen.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:konnex_aerothon/widgets/bottom_button.dart';
import 'package:konnex_aerothon/widgets/catalog/home_delivery_section.dart';
import 'package:konnex_aerothon/widgets/catalog/pickup_section.dart';
import 'package:konnex_aerothon/widgets/loading.dart';

import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/AddressScreen';
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    if (!catalogProvider.initAddress) {
      catalogProvider.initAddress = true;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Select Delivery Type",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      floatingActionButton: KonnexWidget(currentRoute: AddressScreen.routeName),
      body: catalogProvider.isAddressLoad
          ? CustomLoading()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            catalogProvider.selectedAddressId = 0;
                            catalogProvider.notify();
                            LogUtil.instance
                                .log('Selected Pickup as delivery option');
                          },
                          child: Card(
                            child: PickupSection(() {
                              catalogProvider.selectedAddressId = 0;
                              catalogProvider.notify();
                            }, catalogProvider.selectedAddressId),
                          ),
                        ),
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16, top: 16),
                                child: Text(
                                  "Home Delivery",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              ListView.builder(
                                itemCount: catalogProvider.userAddresses.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  UserAddress userAddress =
                                      catalogProvider.userAddresses[index];
                                  return HomeDeliverySection(() {
                                    catalogProvider.selectedAddressId =
                                        userAddress.addressId;
                                    catalogProvider.notify();
                                    LogUtil.instance.log(
                                        'Chose personal Address for delivery.');
                                  },
                                      userAddress.addressId,
                                      catalogProvider.selectedAddressId,
                                      userAddress);
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  LogUtil.instance
                                      .log('Opened add address screen');
                                  Get.to(() => AddAddressScreen(),
                                      transition: Transition.rightToLeft);
                                },
                                child: RenderMetricsObject(
                                  manager: KonnexHandler.instance.manager,
                                  id: 'addAdressButton',
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text("Add Address"),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                RenderMetricsObject(
                  manager: KonnexHandler.instance.manager,
                  id: 'confirmButton',
                  child: BottomButton(
                    onTap: () {
                      Get.close(1);
                    },
                    text: "Confirm",
                    backColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
    );
  }
}
