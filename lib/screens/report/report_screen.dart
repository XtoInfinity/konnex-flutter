import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List categories = ["Payment", "Order"];
  List payments = ["Trouble paying", "UPI not working", "Not depositing"];
  List orders = [
    "Order not accepting",
    "Not able to place order",
    "Button not working"
  ];

  String selectedCategory;
  String selectedSubCategory;

  categoryDropdown() {
    return Container(
      child: DropdownButtonFormField(
        value: selectedCategory,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Category',
        ),
        items: categories.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (val) {
          selectedCategory = val;
          selectedSubCategory = null;
          setState(() {});
        },
      ),
    );
  }

  subCategoryDropdown() {
    List tempList;
    if (selectedCategory == "Payment") {
      tempList = payments;
    } else {
      tempList = orders;
    }
    return Container(
      child: DropdownButtonFormField(
        value: selectedSubCategory,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Sub Category',
        ),
        items: tempList.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (val) {
          selectedSubCategory = val;
          setState(() {});
        },
      ),
    );
  }

  Widget addAttachmentHolder() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 16, 10),
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: InkWell(
          onTap: () async {},
          child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 30,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report a Bug",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              categoryDropdown(),
              if (selectedCategory != null) subCategoryDropdown(),
              SizedBox(
                height: 16,
              ),
              TextField(
                minLines: 8,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: "Enter your issue",
                  hintText: "Enter your issue in detail",
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Attach Photos",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                width: double.infinity,
                height: 120,
                child: ListView.builder(
                  padding: EdgeInsets.only(right: 16),
                  itemBuilder: (context, index) {
                    return addAttachmentHolder();
                  },
                  itemCount: 1,
                  scrollDirection: Axis.horizontal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
