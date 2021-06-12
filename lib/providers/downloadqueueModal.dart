import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DownloadModel extends ChangeNotifier {
  Map<String,String> downloadList = {}; //contians all the task

  addImageInList({String name, /*String percent,*/ url}) {
    DownloadQueue downloadModel = DownloadQueue(name, /*percent,*/ url);
    downloadList[name]=url;

    notifyListeners();
    //code to do
  }
}

class DownloadQueue {
  String name;
  String url;

  String get getname => name;
  String get getpercent => url;

  DownloadQueue(this.name, /*this.percent*/ this.url);
}
