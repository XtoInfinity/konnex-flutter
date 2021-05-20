import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/screens/catalog/add_address_screen.dart';
import 'package:konnex_aerothon/widgets/bottom_button.dart';
import 'package:konnex_aerothon/widgets/catalog/home_delivery_section.dart';
import 'package:konnex_aerothon/widgets/catalog/pickup_section.dart';
import 'package:konnex_aerothon/widgets/loading.dart';

import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
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
                                  },
                                      userAddress.addressId,
                                      catalogProvider.selectedAddressId,
                                      userAddress);
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => AddAddressScreen(),
                                      transition: Transition.rightToLeft);
                                },
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
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                BottomButton(
                  onTap: () {
                    Get.close(1);
                  },
                  text: "Confirm",
                  backColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                )
              ],
            ),
    );
  }
}
