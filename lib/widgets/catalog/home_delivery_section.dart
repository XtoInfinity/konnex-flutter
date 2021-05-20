import 'package:flutter/material.dart';
import 'package:konnex_aerothon/models/catalog.dart';

class HomeDeliverySection extends StatelessWidget {
  final Function onTap;
  final int radioValue;
  final int groupValue;
  final UserAddress userAddress;

  HomeDeliverySection(
      this.onTap, this.radioValue, this.groupValue, this.userAddress);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.only(right: 16, top: 16, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio(
              value: radioValue,
              groupValue: groupValue,
              onChanged: (_) => onTap(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userAddress.name,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  userAddress.address +
                      ' ' +
                      userAddress.city +
                      ' ' +
                      userAddress.state +
                      ' ' +
                      userAddress.pincode,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
