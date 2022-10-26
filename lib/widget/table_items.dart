import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/items_provider.dart';
import '../screen/entry_data.dart';

class TableData extends StatelessWidget {
  TableData({super.key});
  final currency = NumberFormat("#,##0.00", "id_ID");
  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue, content: Text(message.toString())));
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ItemsProvider>(context);
    return Consumer<ItemsProvider>(
      builder: (context, value, child) {
        if (value.state == ViewState.loading) {
          SmartDialog.showLoading();
        }
        if (value.state == ViewState.error) {
          SmartDialog.dismiss();
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Gagal memuat data'),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                )
              ],
            ),
          );
        }
        if (data.items.isNotEmpty) {
          SmartDialog.dismiss();
          return HorizontalDataTable(
            leftHandSideColumnWidth: 50,
            rightHandSideColumnWidth: 800,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(),
            leftSideItemBuilder: _generateFirstColumnRow,
            rightSideItemBuilder: _generateRightHandSideColumnRow,
            itemCount: data.items.length,
            rowSeparatorWidget: const Divider(
              color: Colors.black54,
              height: 1.0,
              thickness: 0.0,
            ),
            leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
            rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
          );
        } else {
          return Center(
            child: TextButton(
              onPressed: () {
                data.get();
              },
              child: const Text('List is Empty'),
            ),
          );
        }
      },
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('No', 50),
      _getTitleItemWidget('Items Name', 300),
      _getTitleItemWidget('price', 200),
      _getTitleItemWidget('barcode', 200),
      _getTitleItemWidget('stock', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 50,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text('${index + 1}.)'),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var data = Provider.of<ItemsProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          EntryItems.routeName,
          arguments: data.items[index],
        );
      },
      onLongPress: () async {
        final result = await data.delete(data.items[index].id!);
        data.get();

        // ignore: use_build_context_synchronously
        showNotification(context, result);
      },
      child: Row(
        children: <Widget>[
          Container(
            width: 300,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(data.items[index].name),
          ),
          Container(
            width: 200,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text('Rp. ${currency.format(data.items[index].price)}'),
          ),
          Container(
            width: 200,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(data.items[index].barcode.toString()),
          ),
          Container(
            width: 100,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(data.items[index].stock.toString()),
          ),
        ],
      ),
    );
  }
}
