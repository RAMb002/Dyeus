import 'package:flutter/widgets.dart';

class ResendOtpProvider extends ChangeNotifier{

  bool _status = false;
  int _count = 0;

  bool get status => _status;
  int get count => _count;

  void changeStatus()async{
    _status = true;
    notifyListeners();
    for(int i=30;i>=0;i--){
      _count = i;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      if(i==0){
        _status = false;
        notifyListeners();
      }
    }
  }
}