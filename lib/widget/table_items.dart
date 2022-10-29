import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:warung_ku/provider/selling_provider.dart';
import 'package:warung_ku/provider/theme_provider.dart';

class TableData extends StatelessWidget {
  TableData({super.key});
  final currency = NumberFormat("#,##0.00", "id_ID");
  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue, content: Text(message.toString())));
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
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                )
              ],
            ),
          );
        }
        if (value.items.isNotEmpty) {
          SmartDialog.dismiss();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 50,
              rightHandSideColumnWidth: 900,
              isFixedHeader: true,
              headerWidgets: _getTitleWidget(context),
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder: _generateRightHandSideColumnRow,
              itemCount: value.items.length,
              rowSeparatorWidget: Divider(
                color: (context.watch<ThemeProvider>().isdark)
                    ? Colors.black54
                    : Colors.white,
                height: 1.0,
                thickness: 0.0,
              ),
              leftHandSideColBackgroundColor:
                  const Color.fromARGB(0, 255, 255, 255),
              rightHandSideColBackgroundColor:
                  const Color.fromARGB(0, 255, 255, 255),
            ),
          );
        } else {
          SmartDialog.dismiss();
          return Center(
            child: TextButton(
              onPressed: () {
                value.get();
              },
              child: const Text('List is Empty'),
            ),
          );
        }
      },
    );
  }

  List<Widget> _getTitleWidget(BuildContext context) {
    return [
      _getTitleItemWidget('No', 50, context),
      _getTitleItemWidget('Items Name', 300, context),
      _getTitleItemWidget('Harga Jual', 200, context),
      _getTitleItemWidget('Jumlah', 100, context),
      _getTitleItemWidget('Tanggal', 300, context),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, BuildContext context) {
    return Container(
      color: (context.watch<ThemeProvider>().isdark)
          ? Colors.blue[200]
          : Colors.grey[700],
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
    var data = Provider.of<SellingProvider>(context);
    return InkWell(
      onTap: () {},
      onLongPress: () async {
        final result = await data.delete(data.items[index]);
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
            child:
                Text('Rp. ${currency.format(data.items[index].sellingPrice)}'),
          ),
          Container(
            width: 100,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(data.items[index].sum.toString()),
          ),
          Container(
            width: 300,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(data.items[index].date),
          ),
        ],
      ),
    );
  }
}
