import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
        backgroundColor: Colors.blue.shade200,
        content: Text(message.toString())));
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

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcode == '-1') {
        barcodeScanRes = '';
      } else {
        barcodeScanRes = barcode;
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      barcodeController.text = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ItemsProvider>(context, listen: false);
    return Consumer<SellingProvider>(
      builder: (context, manager, child) {
        if (manager.state == DataState.loading) {
          SmartDialog.showLoading();
        }
        if (manager.state == DataState.error) {
          SmartDialog.dismiss();
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Gagal memuat data'),
                ElevatedButton.icon(
                  onPressed: () {
                    manager.get();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                )
              ],
            ),
          );
        } else {
          return Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Text(
                        'Masukan Data Penjualan',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade200),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        onTap: () {
                          scanBarcodeNormal();
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: barcodeController,
                        cursorColor: Colors.blue.shade200,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          } else if (item.items.indexWhere((element) =>
                                  element.barcode == int.tryParse(value)) <
                              0) {
                            return 'Data Barcode Tidak Ditemukan';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade200),
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
                        cursorColor: Colors.blue.shade200,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade200),
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
                        keyboardType: TextInputType.number,
                        controller: sumController,
                        cursorColor: Colors.blue.shade200,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade200),
                            ),
                            hintText: 'jumlah'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (formKey.currentState!.validate()) {
                            SmartDialog.showLoading();
                            User user = FirebaseAuth.instance.currentUser!;

                            var indexItem = item.items.indexWhere((element) =>
                                element.barcode ==
                                int.parse(barcodeController.text));
                            Items dataItem = item.items[indexItem];
                            Sales data = Sales(
                                uId: user.uid,
                                name: dataItem.name,
                                sellingPrice: int.parse(priceController.text),
                                barcode: int.parse(barcodeController.text),
                                sum: int.parse(sumController.text),
                                date: DateFormat('yyyy-MM-dd – kk:mm')
                                    .format(DateTime.now())
                                    .toString());
                            var sum = dataItem.stock - data.sum;
                            var result = await manager.add(data);
                            manager.get();
                            item.get();
                            item.updateStock(dataItem, sum);
                            if (mounted) {}
                            showNotification(context, result);
                            barcodeController.clear();
                            sumController.clear();
                            priceController.clear();
                            SmartDialog.dismiss();
                          }
                        },
                        child: const Text('Add Data'),
                      ),
                    )
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
