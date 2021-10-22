import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_tv/movie_tv.dart';
import 'package:path_provider/path_provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'dy2018.dart';
import 'meijumi_series.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initApp().then((value) {
    runApp(MyApp());
  });
}

initApp() async {
  if (!kIsWeb) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '这是一个爬虫',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '这是一个爬虫'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    refreshData();

    Timer.periodic(Duration(seconds: 60), (timer) {
      refreshData();
    });
  }

  Future<void> refreshData() async {
    await dy2018.getResponse();
    for (MeiJuMi meijumiSeries in meijumiSeriesList) {
      await meijumiSeries.getResponse();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: children(),
          ),
        ),
      ),
    );
  }

  List<Widget> children() {
    List<Widget> widgets = [];
    for (MeiJuMi meijumiSeries in meijumiSeriesList) {
      getMovieTvWidget(widgets, meijumiSeries);
    }

    getMovieTvWidget(widgets, dy2018);

    if (kIsWeb) {
      widgets.add(Text("To run web in Chrome\n"
          "1- Go to flutter\\bin\\cache and remove a file named: flutter_tools.stamp\n"
          "2- Go to flutter\\packages\\flutter_tools\\lib\\src\\web and open the file chrome.dart.\n"
          "3- Find '--disable-extensions'\n"
          "4- Add '--disable-web-security'\n"
          "5- Add '--user-data-dir=/Users/mt/Desktop/chromedata'"));
    }
    return widgets;
  }

  getMovieTvWidget(List<Widget> widgets, MovieTv movieTv)  {
    widgets.add(GestureDetector(
      child: Text(movieTv.title + "   更新次数${movieTv.updateNum}"),
      onTap: () async {
        setState(() {
          movieTv.response = "";
        });
        await movieTv.getResponse();
        setState(() {});
      },
    ));
    widgets.add(Html(
      data: movieTv.response,
      onLinkTap: (url, _, __, ___) {
        // Clipboard.setData(ClipboardData(text: url));
        launch(url.contains("http") ? url : movieTv.url + url);
      },
    ));
  }
}
