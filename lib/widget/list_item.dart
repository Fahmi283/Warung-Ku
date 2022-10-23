import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warung_ku/provider/items_provider.dart';
import 'package:intl/intl.dart';

class ListItems extends StatelessWidget {
  ListItems({super.key});
  final currency = NumberFormat("#,##0.00", "id_ID");

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ItemsProvider>(context);

    if (data.items.isNotEmpty) {
      return ListView.separated(
        itemCount: data.items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: ListTile(
              onTap: () {
                data.get();
              },
              title: Text(data.items[index].name),
              subtitle: Text(data.items[index].price.toString()),
              trailing: Text(
                  'Rp. ${currency.format(data.items[index].stock.toString())}'),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 4,
        ),
      );
    } else {
      return Center(
        child: TextButton(
          onPressed: () {
            data.get();
          },
          child: const Text('Empty'),
        ),
      );
    }
  }
}
