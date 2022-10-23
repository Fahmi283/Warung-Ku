class Items {
  String name;
  int price;
  String barcode;
  int stock;

  Items({
    required this.name,
    required this.price,
    required this.barcode,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'barcode': barcode,
      'price': price,
      'stock': stock,
    };
  }
}
