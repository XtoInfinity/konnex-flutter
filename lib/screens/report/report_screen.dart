import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konnex_aerothon/screens/misc/done_screen.dart';
import 'package:konnex_aerothon/services/help_service.dart';
import 'package:konnex_aerothon/widgets/bottom_button.dart';
import 'package:konnex_aerothon/widgets/dialog.dart';
import 'package:konnex_aerothon/widgets/loading.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<File> files = [];

  List categories = ["Payment", "Order"];
  List payments = ["Trouble paying", "UPI not working", "Not depositing"];
  List orders = [
    "Order not accepting",
    "Not able to place order",
    "Button not working"
  ];
  bool isLoad = false;
  String selectedCategory;
  String selectedSubCategory;
  TextEditingController controller = TextEditingController();

  pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile;
    if (pickedFile != null) {
      croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.png,
          maxHeight: 1080,
          maxWidth: 1080,
          compressQuality: 80,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
    }
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

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

  Widget attachmentHolder(int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 16, 10),
      width: 120,
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
          onTap: () {
            Get.dialog(
                CustomDialog("Remove Item", "Do you want to remove this item?",
                    negativeButtonOnTap: () => Get.close(1),
                    positiveButtonOnTap: () async {
                      files.removeAt(index);
                      setState(() {});
                      Get.close(1);
                    },
                    positiveButtonColor: Colors.red,
                    negativeButtonColor: Colors.green,
                    positiveButtonText: "Remove"));
          },
          child: Image.file(
            File(files[index].path),
            fit: BoxFit.cover,
          ),
        ),
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
          onTap: () async {
            FocusScope.of(Get.context).unfocus();
            File file = await pickImage();
            if (file != null) {
              files.add(file);
              setState(() {});
            }
          },
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

  addReport() async {
    String message = controller.text;

    if (message.length > 0 &&
        selectedCategory != null &&
        selectedSubCategory != null) {
      isLoad = true;
      setState(() {});
      HelpService helpService = HelpService();
      await helpService.addReport(
          files, selectedCategory, selectedSubCategory, message);
      Get.to(DoneScreen(
        onTap: () => Get.close(2),
        title: "Report Submitted",
        subTitle:
            "We will go through your report and try to solve it. Thank you",
      ));
    } else {
      Get.rawSnackbar(message: "Please enter all details");
    }
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
      body: isLoad
          ? CustomLoading()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                            controller: controller,
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
                                if (files.length == 5) {
                                  return attachmentHolder(index);
                                } else if (index == 0) {
                                  return addAttachmentHolder();
                                } else {
                                  return attachmentHolder(index - 1);
                                }
                              },
                              itemCount: files.length == 5
                                  ? files.length
                                  : files.length + 1,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomButton(
                  onTap: () {
                    addReport();
                  },
                  text: "Submit",
                )
              ],
            ),
    );
  }
}
