import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

import 'movie_tv.dart';

Dy2018 dy2018 = new Dy2018();

class Dy2018 extends MovieTv {
  Dy2018() {
    title = "dy2018(点击刷新)";
    url = "https://www.dy2018.com/";
  }

  @override
  Future getResponse() async {
    try {
      response = (await Dio().get(url, options: Options(
        responseDecoder: (res, _, responseBody) {
          return gbk.decode(res);
        }
      ))).toString();
      response = response.replaceAll("gb2312", "utf-8");
      dom.Document document = htmlparser.parse(response);
      List<dom.Element> elements = document.getElementsByClassName("co_content222");
      if (elements == null || elements.length <= 0) {
        return ;
      }
      response = elements[0].children[0].innerHtml;
    } catch (e) {
      response = "反正是有异常 ${e.toString()}";
      print(e);
    }

    if(lastResponse.isNotEmpty && lastResponse != response) {
      print('MTMTMT Dy2018.getResponse 不同 ');
    }

    lastResponse = response;
    // print('MTMTMT Dy2018.getResponse ${response} ');
    return ;
  }
}
