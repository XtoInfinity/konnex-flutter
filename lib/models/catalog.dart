class Category {
  Category({
    this.ccId,
    this.ccName,
    this.ccPhoto,
  });

  int ccId;
  String ccName;
  String ccPhoto;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        ccId: json["cc_id"],
        ccName: json["cc_name"],
        ccPhoto: json["cc_photo"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "cc_id": ccId,
        "cc_name": ccName,
        "cc_photo": ccPhoto,
      };
}

class Product {
  Product(
      {this.cpId,
      this.ccId,
      this.cpCost,
      this.cpDiscountCost,
      this.cpDescription,
      this.cpName,
      this.cpPriority,
      this.cpStock,
      this.cpHide,
      this.ccName,
      this.ccPhoto,
      this.cpUrl,
      this.cpmId,
      this.cpPhoto,
      this.officialId,
      this.quantity,
      this.cartId});

  String cpId;
  int ccId;
  int cpCost;
  int cpDiscountCost;
  String cpDescription;
  String cpName;
  int cpPriority;
  int cpStock;
  int cpHide;
  String ccName;
  String ccPhoto;
  String cpUrl;
  List<String> cpmId;
  List<String> cpPhoto;
  int officialId;
  int quantity;
  int cartId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      officialId: json["official_id"],
      cpId: json["cp_id"],
      ccId: json["cc_id"],
      cpCost: json["cp_cost"],
      cpDiscountCost: json["cp_discountCost"],
      cpDescription: json["cp_description"],
      cpName: json["cp_name"],
      cpPriority: json["cp_priority"],
      cpStock: json["cp_stock"],
      cpHide: json["cp_hide"],
      ccName: json["cc_name"],
      ccPhoto: json["cc_photo"],
      cpUrl: json["cp_url"],
      cpmId: json["cpm_id"] == null ? [] : json["cpm_id"].toString().split(','),
      cpPhoto: json["cp_photo"] == null
          ? []
          : json["cp_photo"].toString().split(','),
      quantity: json['quantity'],
      cartId: json['cart_id']);
}

class Priority {
  int priorityNumber;
  String priorityName;

  Priority(this.priorityNumber, this.priorityName);
}

class Stock {
  int stockNumber;
  String stockName;

  Stock(this.stockNumber, this.stockName);
}

class UserAddress {
  UserAddress({
    this.addressId,
    this.address,
    this.userId,
    this.name,
    this.city,
    this.state,
    this.pincode,
  });

  int addressId;
  String address;
  int userId;
  String name;
  String city;
  String state;
  String pincode;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        addressId: json["address_id"],
        address: json["address"],
        userId: json["user_id"],
        name: json["name"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "address": address,
        "user_id": userId,
        "name": name,
        "city": city,
        "state": state,
        "pincode": pincode,
      };
}

class Order {
  Order(
      {this.id,
      this.orderId,
      this.userId,
      this.officialId,
      this.statusId,
      this.cost,
      this.discountCost,
      this.deliveryTypeId,
      this.updatedAt,
      this.createdAt,
      this.name,
      this.address,
      this.city,
      this.state,
      this.pincode,
      this.officialsName,
      this.officialDisplayPhone,
      this.officialPhoto,
      this.statusName,
      this.deliveryTypeName});

  int id;
  String orderId;
  int userId;
  int officialId;
  int statusId;
  int cost;
  int discountCost;
  int deliveryTypeId;
  DateTime updatedAt;
  DateTime createdAt;
  String name;
  String address;
  String city;
  String state;
  String pincode;
  String officialsName;
  String officialDisplayPhone;
  String officialPhoto;
  String statusName;
  String deliveryTypeName;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json["id"],
      orderId: json["order_id"],
      userId: json["user_id"],
      officialId: json["official_id"],
      statusId: json["status_id"],
      cost: json["cost"],
      discountCost: json["discount_cost"],
      deliveryTypeId: json["delivery_type_id"],
      updatedAt: DateTime.parse(json["updated_at"]),
      createdAt: DateTime.parse(json["created_at"]),
      name: json["name"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"],
      officialsName: json["officials_name"],
      officialDisplayPhone: json["official_display_phone"],
      officialPhoto: json["official_photo"],
      statusName: json["status_name"],
      deliveryTypeName: json["delivery_type_name"]);
}

class OrderDetail {
  OrderDetail({
    this.oiId,
    this.orderId,
    this.cpId,
    this.quantity,
    this.cost,
    this.discountCost,
    this.cpName,
    this.cpDescription,
    this.productPhotos,
  });

  int oiId;
  int orderId;
  String cpId;
  int quantity;
  int cost;
  int discountCost;
  String cpName;
  String cpDescription;
  List<String> productPhotos;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        oiId: json["oi_id"],
        orderId: json["order_id"],
        cpId: json["cp_id"],
        quantity: json["quantity"],
        cost: json["cost"],
        discountCost: json["discount_cost"],
        cpName: json["cp_name"],
        cpDescription: json["cp_description"],
        productPhotos: json["product_photos"] == null
            ? []
            : json["product_photos"].toString().split(","),
      );
}
