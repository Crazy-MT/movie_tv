import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_tv/server_key.dart';

class MovieTv{
  String title;
  String url;
  String response = "";
  Box lastResponseBox;

  MovieTv() {
    initData();
  }

  Future getResponse() async {
    String lastResponse = lastResponseBox.get(url, defaultValue: "");
    if(lastResponse.isNotEmpty && lastResponse != response) {
      print('MTMTMT $title 不同 ');
      await Dio().get("https://sctapi.ftqq.com/$key.send?title=$title有更新");
    }

    lastResponseBox.put(url, response);
  }

  Future<void> initData() async {
    lastResponseBox = await Hive.openBox<String>("movie_tv_box");
  }
}