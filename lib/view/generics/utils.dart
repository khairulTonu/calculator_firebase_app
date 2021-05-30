import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'HexColor.dart';

class Utils {
  static Color primaryColor = HexColor("#002B42");
  static Color secondaryColor = HexColor("#006c6c");
  static Color numberButtonColor = HexColor("#013243");
  static Color operatorButtonColor = HexColor("#28B8F0");
  static Color equalButtonColor = HexColor("#59CFFF");

  static Future<bool> checkNetwork() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}