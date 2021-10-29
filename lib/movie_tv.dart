import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_tv/server_key.dart';

class MovieTv {
  String title = "";
  String url = "";
  String response = "";
  int updateNum = 0;
  String appendResponse = "";

  Future getResponse() async {
    Box lastResponseBox = await Hive.openBox<String>("movie_tv_box");
    String lastResponse = lastResponseBox.get(url, defaultValue: "");
    if (lastResponse.isNotEmpty && lastResponse != response) {
      print('MTMTMT $title 有更新 ');
      updateNum++;
      appendResponse += response;
      try {
        await Dio().get("https://sctapi.ftqq.com/$key.send?title=$title有更新");
      } catch (e) {}
    }

    lastResponseBox.put(url, response); // 浏览器关闭之后数据会丢失
  }
}
