import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warung_ku/model/items_model.dart';

class ItemsServices {
  CollectionReference item = FirebaseFirestore.instance.collection('items');

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
  Future<List<Items>> get() async {
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
    List<Items> data = [];
    await FirebaseFirestore.instance
        .collection('items')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        data.add(Items(
          name: doc["name"],
          price: doc["price"]! as int,
          barcode: doc["barcode"],
          stock: doc["stock"]! as int,
        ));
      }
    });
    return data;
  }

  Future<String> add(Items data) async {
    Map<String, dynamic> map = {
      "name": data.name,
      "price": data.price,
      "barcode": data.barcode,
      "stock": data.stock,
    };
    try {
      await item.add(map);
      return 'Data berhasil ditambahkan';
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }
}
