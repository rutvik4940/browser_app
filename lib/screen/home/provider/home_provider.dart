import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirror_well_app/utils/shered_helper/share_helper.dart';



class HomeProvider with ChangeNotifier {
  bool isOn = true;
  double progress = 0;
  bool isOnline = false;
 List <String> book=[];
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
  void getData()async
  {
    if(await applyMark()==null)
      {
        book=[];
      }
    else
      {
        book=(await applyMark())!;
      }
    notifyListeners();
  }
  void setData(String url)
  {
    getData();
    book.add(url);
    saveBookmark(bookmark: book);
    getData();
    notifyListeners();


  }
  void deleteContact(int r)
  {
    book.removeAt(r);
    notifyListeners();
  }

}
