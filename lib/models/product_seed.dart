class ProductSeed {
  final String user;
  final String productName;
  final String category;
  final String uom;
  final String id;
  final int qty;
  final String id2;
  bool checked;

  ProductSeed( {
    required this.user,
    required this.productName,
    required this.category,
    required this.uom,
    required this.id,
    required this.qty,
    required this.id2,
    this.checked = false,
  });

  factory ProductSeed.fromJson(Map<String, dynamic> json) {
    return ProductSeed(
      user: json['user']??'',
      productName: json['productName'].toString().toLowerCase(),
      category: json['category'],
      uom: json['uom'],
      id: json['_id'],
      qty: json['qty'],
      id2: json['id'] ?? '',
      checked: json['checked'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'productName': productName,
      'category': category,
      'uom': uom,
      'id': id,
      'qty': qty,
      'id2': id2,
      'checked': checked,
    };
  }
}
