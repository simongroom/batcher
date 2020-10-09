class Product {
  String productId;
  String clientName;
  String productName;
  int productCode;
  int shelfLife;
  bool isColdFill = false;

  Product({
    this.productId,
    this.clientName,
    this.productName,
    this.productCode,
    this.shelfLife,
    this.isColdFill = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      clientName: json['client_name'],
      productName: json['product_name'],
      productCode: json['product_code'],
      shelfLife: json['shelf_life'],
      isColdFill: json['is_cold_fill'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {
      'product_id': productId,
      'client_name': clientName,
      'product_name': productName,
      'product_code': productCode,
      'shelf_life': shelfLife,
      'is_cold_fill': isColdFill,
    };
    return _data;
  }
}
