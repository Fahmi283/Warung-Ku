import 'package:flutter/material.dart';
import 'package:warung_ku/model/items_model.dart';
import 'package:warung_ku/services/items_services.dart';

enum ViewState {
  none,
  loading,
  error,
}

class ItemsProvider extends ChangeNotifier {
  String _response = "";
  List<Items> _items = [];
  ViewState _state = ViewState.none;
  final ItemsServices _service = ItemsServices();

  List<Items> get items => _items;
  String get response => _response;
  ViewState get state => _state;

  changeState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void add(Items data) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.add(data);
      _response = result;
      notifyListeners();
      changeState(ViewState.none);
    } catch (e) {
      changeState(ViewState.error);
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
}
