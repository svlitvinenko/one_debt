import 'package:flutter/foundation.dart';

final class PublicNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
