import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warung_ku/model/sales_model.dart';

class ItemsServices {
  CollectionReference item = FirebaseFirestore.instance.collection('sales');

  // static Future<Items> get() async {
  //   try {
  //     var result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     User? user = result.user;
  //     return user;
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e.toString());
  //     return null;
  //   }
  // }
  Future<List<Sales>> get() async {
    // final itemRef = FirebaseFirestore.instance
    //     .collection('items')
    //     .withConverter<Items>(
    //       fromFirestore: (snapshots, _) => Items.fromJson(snapshots.data()!),
    //       toFirestore: (movie, _) => movie.toJson(),
    //     );
    // final item = await itemRef.get();
    // final items = item.data();

    // await item.get().then((data) {
    //   return List<Items>.from(data.docs.map((data) => Items(
    //         name: data['name'],
    //         price: int.parse(data['price']),
    //         barcode: data['barcode'],
    //         stock: int.parse(data['stock']),
    //       )));
    // });
    // return [];
    List<Sales> data = [];
    await FirebaseFirestore.instance
        .collection('items')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        data.add(Sales(
          id: doc.id,
          name: doc["name"],
          sellingPrice: doc["sellingprice"],
          barcode: doc["barcode"],
          sum: doc["stock"],
          date: doc["date"].toString(),
        ));
      }
    });
    return data;
  }

  Future<String> add(Sales data) async {
    Map<String, dynamic> map = {
      "name": data.name,
      "sellingprice": data.sellingPrice,
      "barcode": data.barcode,
      "sum": data.sum,
      "date": FieldValue.serverTimestamp(),
    };
    try {
      await item.add(map);
      return 'Data berhasil ditambahkan';
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }
}
