import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';



class HomeProvider with ChangeNotifier {
  bool isOn = true;
  double progress = 0;
  bool isOnline = false;

  void checkinternet() {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          isOn = false;
        } else {
          isOn = true;
        }
        notifyListeners();
      },
    );
  }

  void changeProgress(double p) {
    progress = p;
    notifyListeners();
  }

}
