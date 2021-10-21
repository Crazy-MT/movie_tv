import 'package:dio/dio.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

import 'movie_tv.dart';

MeiJuMi walkingDeadSeries =
MeiJuMi("行尸走肉第十一季(点击刷新)", "https://www.meijumi.net/32883.html", 3);
MeiJuMi seeSeries =
MeiJuMi("看见第二季(点击刷新)", "https://www.meijumi.net/32978.html", 2);
List<MeiJuMi> meijumiSeriesList = [walkingDeadSeries, seeSeries];
// List<MeiJuMi> meijumiSeriesList = [];

class MeiJuMi extends MovieTv{
  int pIndex;

  MeiJuMi(String title, String url, int pIndex) {
    this.title = title;
    this.url = url;
    this.pIndex = pIndex;
  }

  @override
  Future getResponse() async {
    response = "";
    try {
      response = (await Dio().get(url)).toString();
      dom.Document document = htmlparser.parse(response);
      List<dom.Element> elements =
      document.getElementsByClassName("single-content");
      for (dom.Element element in elements) {
        List<dom.Element> ps = element.getElementsByTagName("p");
        response = ps[pIndex].innerHtml;
      }
    } catch (e) {
      response = "反正是有异常 ${e.toString()}";
      print(e);
    }

    if(lastResponse.isNotEmpty && lastResponse != response) {
      print('MTMTMT Dy2018.getResponse 不同 ');
    }

    lastResponse = response;
    return ;
  }
}