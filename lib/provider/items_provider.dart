import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warung_ku/model/items_model.dart';
import 'package:warung_ku/services/items_services.dart';

enum ViewState {
  none,
  loading,
  error,
}

class ItemsProvider extends ChangeNotifier {
  List<Items> _items = [];
  ViewState _state = ViewState.none;
  final ItemsServices _service = ItemsServices();

  List<Items> get items => _items;
  ViewState get state => _state;
  // ItemsProvider() {
  //   get();
  // }
  changeState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<String> add(Items data) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.add(data);

      notifyListeners();
      changeState(ViewState.none);
      return result;
    } catch (e) {
      changeState(ViewState.error);
      return '';
    }
  }

  void get() async {
    changeState(ViewState.loading);

    try {
      final result = await _service.get();
      _items = result;
      notifyListeners();
      changeState(ViewState.none);
    } catch (e) {
      changeState(ViewState.error);
    }
  }

  Future<String> edit(Items data) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.updateItem(data);

      notifyListeners();
      changeState(ViewState.none);
      return result;
    } on FirebaseAuthException catch (e) {
      changeState(ViewState.error);
      return e.toString();
    }
  }

  Future<String> delete(String id) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.delete(id);

      notifyListeners();
      changeState(ViewState.none);
      return result;
    } on FirebaseAuthException catch (e) {
      changeState(ViewState.error);
      return e.toString();
    }
  }
}
