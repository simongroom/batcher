class Product {
  String productId;
  String clientName;
  String productName;
  int productCode;
  int shelfLife;

  Product({
    this.productId,
    this.clientName,
    this.productName,
    this.productCode,
    this.shelfLife,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      clientName: json['client_name'],
      productName: json['product_name'],
      productCode: json['product_code'],
      shelfLife: json['shelf_life'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {
      'product_id': productId,
      'client_name': clientName,
      'product_name': productName,
      'product_code': productCode,
      'shelf_life': shelfLife,
    };
    return _data;
  }
}
