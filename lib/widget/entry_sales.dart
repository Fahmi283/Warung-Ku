import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:warung_ku/model/sales_model.dart';
import 'package:warung_ku/provider/items_provider.dart';
import 'package:warung_ku/provider/selling_provider.dart';

import '../model/items_model.dart';

class EntrySales extends StatefulWidget {
  const EntrySales({super.key});

  @override
  State<EntrySales> createState() => _EntrySalesState();
}

class _EntrySalesState extends State<EntrySales> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController barcodeController;
  late TextEditingController priceController;
  late TextEditingController sumController;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue, content: Text(message.toString())));
  }

  @override
  void initState() {
    barcodeController = TextEditingController();
    priceController = TextEditingController();
    sumController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    priceController.dispose();
    sumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SellingProvider>(
      builder: (context, value, child) {
        if (value.state == DataState.loading) {
          SmartDialog.showLoading();
        }
        if (value.state == DataState.error) {
          SmartDialog.dismiss();
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Gagal memuat data'),
                ElevatedButton.icon(
                  onPressed: () {
                    value.get();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                )
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Text(
                        'Masukan Data Barang',
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        controller: barcodeController,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'Barcode'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'Selling Price'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        controller: sumController,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'jumlah'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          SmartDialog.showLoading();
                          final sell = Provider.of<SellingProvider>(context,
                              listen: false);
                          final item =
                              Provider.of<ItemsProvider>(context).items;
                          var indexItem = item.indexWhere((element) =>
                              element.barcode ==
                              int.parse(barcodeController.text));
                          Items dataItem = item[indexItem];
                          Sales data = Sales(
                              name: dataItem.name,
                              sellingPrice: int.parse(priceController.text),
                              barcode: int.parse(barcodeController.text),
                              sum: int.parse(sumController.text),
                              date: DateTime.now().toString());
                          var result = await sell.add(data);
                          sell.get();
                          if (mounted) {}
                          showNotification(context, result);
                          SmartDialog.dismiss();
                        },
                        child: const Text('Add'))
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
