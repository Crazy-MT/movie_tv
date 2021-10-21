import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:url_launcher/url_launcher.dart';

import 'dy2018.dart';
import 'meijumi_series.dart';

void main() {
  runApp(MyApp());
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

    Timer.periodic(Duration(seconds: 60), (timer) {
      refreshData();
    });
  }

  Future<void> refreshData() async {
    print('MTMTMT _MyHomePageState.refreshData ');
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
      widgets.add(GestureDetector(
        child: Text(meijumiSeries.title),
        onTap: () async {
          setState(() {
            meijumiSeries.response = "";
          });
          await meijumiSeries.getResponse();
          setState(() {});
        },
      ));
      widgets.add(Html(
        data: meijumiSeries.response,
        onLinkTap: (url, _, __, ___) {
          // Clipboard.setData(ClipboardData(text: url));
          launch(url);
        },
      ));
    }

    widgets.add(GestureDetector(
      child: Text(dy2018.title),
      onTap: ()  async {
        setState(() {
          dy2018.response = "";
        });
        await dy2018.getResponse();
        setState(() {});
      },
    ));
    widgets.add((
        Html(
          data: dy2018.response,
          onLinkTap: (url, _, __, ___) {
            // Clipboard.setData(ClipboardData(text: url));
            launch(dy2018.url + url);
          },
        )
    ));
    // print('MTMTMT _MyHomePageState.children ${Platform.localHostname} ');
    if(kIsWeb) {
      widgets.add(Text(
          "To run web in Chrome\n"
              "1- Go to flutter\\bin\\cache and remove a file named: flutter_tools.stamp\n"
              "2- Go to flutter\\packages\\flutter_tools\\lib\\src\\web and open the file chrome.dart.\n"
              "3- Find '--disable-extensions'\n"
              "4- Add '--disable-web-security'\n"
              "5- Add '--user-data-dir=/Users/mt/Desktop/chromedata'"
      ));
    }
    return widgets;
  }
}