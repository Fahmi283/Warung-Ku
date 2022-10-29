import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warung_ku/model/sales_model.dart';

class SellingServices {
  late Dio _dio;
  static const baseUrl =
      'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/sellingData.json';

  SellingServices() {
    _dio = Dio();
  }
  Future<List<Sales>> getdata() async {
    List<Sales> dataList = [];
    final Response response = await _dio.get(baseUrl);
    if (response.data != null) {
      response.data.forEach((id, data) {
        dataList.add(Sales(
          id: id,
          uId: data['uId'],
          name: data['name'],
          sellingPrice: data['sellingPrice'],
          barcode: data['barcode'],
          sum: data['sum'],
          date: data['date'],
        ));
      });
      return dataList;
    }
    return [];
  }

  Future<String> add(Sales data) async {
    Map<String, dynamic> map = {
      "uId": data.uId,
      "name": data.name,
      "sellingPrice": data.sellingPrice,
      "barcode": data.barcode,
      "sum": data.sum,
      "date": data.date
    };
    final response = await _dio.post(baseUrl, data: map);
    if (response.data != null) {
      return 'Data berhasil ditambahkan';
    } else {
      return 'Gagal menambah data';
    }
  }

  Future<String> delete(Sales data) async {
    User user = FirebaseAuth.instance.currentUser!;
    if (user.uid == data.uId) {
      final response = await _dio.delete(
          'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/sellingData/${data.id}.json');
      return response.data.toString();
    } else {
      return 'Akses di larang';
    }
  }

  Future<String> updateItem(Sales data) async {
    Map<String, dynamic> map = {
      "uId": data.uId,
      "name": data.name,
      "sellingPrice": data.sellingPrice,
      "barcode": data.barcode,
      "stock": data.sum,
      "date": data.date,
    };
    final response = await _dio.put(
        'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/sellingData/${data.id}.json',
        data: map);

    if (response.data != null) {
      return 'Berhasil di update';
    } else {
      return 'Gagal di update';
    }
  }
}
