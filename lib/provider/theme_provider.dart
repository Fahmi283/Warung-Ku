import 'package:flutter/foundation.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isdark = true;
  bool get isdark => _isdark;

  changeTheme() {
    _isdark = !_isdark;
    notifyListeners();
  }
}
