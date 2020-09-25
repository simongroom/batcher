import 'package:flutter/material.dart';

class Product {
  String clientName;
  String productName;
  int productCode;
  int shelfLife;

  Product({
    @required this.clientName,
    @required this.productName,
    @required this.productCode,
    @required this.shelfLife,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      clientName: json['client_name'],
      productName: json['product_name'],
      productCode: json['product_code'],
      shelfLife: json['shelf_life'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {
      'client_name': this.clientName,
      'product_name': this.productName,
      'product_code': this.productCode,
      'shelf_life': this.shelfLife,
    };
    return _data;
  }
}
