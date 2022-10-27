import 'package:dio/dio.dart';
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

  Future<String> delete(String id) async {
    final response = await _dio.delete(
        'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/sellingData/$id.json');
    return response.data.toString();
  }

  Future<String> updateItem(Sales data) async {
    Map<String, dynamic> map = {
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
