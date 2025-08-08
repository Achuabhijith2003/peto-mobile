import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetProvider extends ChangeNotifier {
  Future<bool> checkinternet() async {
    final completer = Completer<bool>();
    final listener = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      switch (status) {
        case InternetStatus.connected:
          completer.complete(true);
          notifyListeners();
          break;

        case InternetStatus.disconnected:
          completer.complete(false);
          notifyListeners();
          break;
      }
    });

    final result = await completer.future;
    listener.cancel(); // Cancel the listener to avoid memory leaks
    return result;
  }
}
