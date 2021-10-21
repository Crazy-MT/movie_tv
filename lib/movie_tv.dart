import 'package:dio/dio.dart';
import 'package:movie_tv/server_key.dart';

class MovieTv{
  String title;
  String url;
  String response = "";
  String lastResponse = "";

  Future getResponse() async {

    if(lastResponse.isNotEmpty && lastResponse != response) {
      print('MTMTMT $title 不同 ');
      await Dio().get("https://sctapi.ftqq.com/$key.send?title=$title有更新");
    }

    lastResponse = response;
  }
}