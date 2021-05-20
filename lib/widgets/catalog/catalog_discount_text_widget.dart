import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konnex_aerothon/utils/misc_utils.dart';

class CatalogDiscountTextWidget extends StatelessWidget {
  final int cost;
  final int discountCost;

  CatalogDiscountTextWidget(this.cost, this.discountCost);

  @override
  Widget build(BuildContext context) {
    return discountCost == 0
        ? Text(
            "₹$cost",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )
        : RichText(
            text: TextSpan(
              style: Get.textTheme.bodyText1,
              children: <TextSpan>[
                TextSpan(
                    text: "₹$discountCost ",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                TextSpan(
                  text: "₹$cost",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.lineThrough),
                ),
                TextSpan(
                  text:
                      " ${MiscUtils.findPercentageOfTwoNumbers(discountCost, cost)}% off",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                ),
              ],
            ),
          );
  }
}
