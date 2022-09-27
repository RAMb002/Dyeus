import 'package:flutter/widgets.dart';

class LoadingProvider extends ChangeNotifier{

  bool _status = false;

  bool get loadingStatus => _status;

  void changeLoadingStatus(bool value){
    _status = value;
    notifyListeners();
  }

}