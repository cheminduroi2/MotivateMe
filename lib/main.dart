import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:motivate_me/NotificationHandler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivate Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationHandler _nHandler;
  static const QUOTE_OF_DAY_URL =
      'http://quotes.rest/qod.json?category=inspire';

  @override
  initState() {
    super.initState();
    _getQuote(QUOTE_OF_DAY_URL).then(
      (Map<String, String> quote) {
        _nHandler.startDailyNotifications(quote);
      },
    );
  }

  Future<Map<String, String>> _getQuote(String url) async {
    final http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to retrieve quote: ${response.reasonPhrase}');
    }

    Map<String, dynamic> decodedBody = jsonDecode(response.body);
    return {
      'quote': decodedBody['contents']['quotes'][0]['quote'],
      'author': decodedBody['contents']['quotes'][0]['author'],
    };
  }

  TextStyle _getAppDescTextStyle(Color textColor) {
    return TextStyle(
      color: textColor,
      fontSize: 40.0,
      fontFamily: 'Times New Roman',
    );
  }

  @override
  Widget build(BuildContext context) {
    _nHandler = NotificationHandler(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: '"Daily notifications of ',
                  style: _getAppDescTextStyle(Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'self-motivational',
                      style: _getAppDescTextStyle(Colors.green),
                    ),
                    TextSpan(
                      text: ' quotes."',
                      style: _getAppDescTextStyle(Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '- Motivate Me',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Times New Roman',
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
