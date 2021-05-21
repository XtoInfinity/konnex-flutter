import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/konnex/konnex.dart';
import 'package:konnex_aerothon/konnex/konnex_handler.dart';
import 'package:konnex_aerothon/models/catalog.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/utils/log_util.dart';
import 'package:konnex_aerothon/widgets/bottom_button.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class AddAddressScreen extends StatefulWidget {
  static const routeName = '/AddAddressScreen';
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  textWidget(TextEditingController controller, String label, bool isNumber) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  stateDropdown() {
    return Container(
      child: DropdownButtonFormField<String>(
        value: "Karnataka",
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'State',
        ),
        items: ["Karnataka"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (val) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider =
        Provider.of<CatalogProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Add Delivery Address",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      floatingActionButton:
          KonnexWidget(currentRoute: AddAddressScreen.routeName),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    RenderMetricsObject(
                      id: 'nameEditText',
                      manager: KonnexHandler.instance.manager,
                      child: textWidget(nameController, "Name", false),
                    ),
                    RenderMetricsObject(
                      id: 'addressEditText',
                      manager: KonnexHandler.instance.manager,
                      child: textWidget(addressController, "Address", false),
                    ),
                    RenderMetricsObject(
                      id: 'cityEditText',
                      manager: KonnexHandler.instance.manager,
                      child: textWidget(cityController, "City", false),
                    ),
                    RenderMetricsObject(
                      id: 'stateEditText',
                      manager: KonnexHandler.instance.manager,
                      child: stateDropdown(),
                    ),
                    RenderMetricsObject(
                      id: 'pinCodeEditText',
                      manager: KonnexHandler.instance.manager,
                      child: textWidget(pincodeController, "Pin Code", true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          RenderMetricsObject(
            id: 'addAddressButton',
            manager: KonnexHandler.instance.manager,
            child: BottomButton(
              onTap: () {
                String name = nameController.text;
                String address = addressController.text;
                String city = cityController.text;
                String pincode = pincodeController.text;
                if (name.length > 0 &&
                    address.length > 0 &&
                    city.length > 0 &&
                    pincode.length > 0) {
                  Get.close(1);
                  catalogProvider.addUserAddress(UserAddress(
                      name: name,
                      address: address,
                      city: city,
                      pincode: pincode,
                      state: "Karnataka"));
                  LogUtil.instance.log('Added New Address');
                } else {
                  Get.rawSnackbar(message: "Please enter all the details");
                }
              },
              text: "Add Address",
            ),
          )
        ],
      ),
    );
  }
}
