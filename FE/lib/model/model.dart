import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../api.dart';

class SecurityModel extends ChangeNotifier {
  late LocalStorage storage;
  bool authenticated = false;
  String? userName;
  String? authorization;
  dynamic userLoginCurren;
  int countSVDK = 0;

  setCountSVDK(int newCount) {
    countSVDK = newCount;
    notifyListeners();
  }

  SecurityModel(this.storage) {
    authorization = storage.getItem("authorization");
    // print(authorization != null);
    authenticated = authorization != null;
  }

  // void logout() {
  //   authorization = null;
  //   authenticated = false;
  //   this.userLoginCurren = null;
  //   storage.setItem("authorization", null);
  //   storage.deleteItem('userName');
  //   notifyListeners();
  // }

  int getcountSVDK() {
    return storage.getItem("countSVDK");
  }

  setAuthorization({String? authorization, var userName}) async {
    this.authorization = authorization;
    authenticated = authorization != null;
    storage.setItem("authorization", "$authorization");
    storage.setItem("userName", userName);
    SecurityModel(storage);
    notifyListeners();
  }

  reload() async {
    var authorization = storage.getItem("authorization");

    if (authorization != null) {}
    notifyListeners();
  }
}
