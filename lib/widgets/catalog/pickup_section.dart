import 'package:flutter/material.dart';

class PickupSection extends StatelessWidget {
  final Function onTap;
  final int addressId;

  PickupSection(this.onTap, this.addressId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16, top: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio(
            value: 0,
            groupValue: addressId,
            onChanged: (_) => onTap(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pickup",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    "Visit this business to collect your order. You can view location and contact details of the business in their profile.")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
