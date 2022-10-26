class Sales {
  String? id;
  String name;
  int sellingPrice;
  int barcode;
  int sum;
  String date;

  Sales({
    this.id,
    required this.name,
    required this.sellingPrice,
    required this.barcode,
    required this.sum,
    required this.date,
  });
}
