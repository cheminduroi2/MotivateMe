import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationHandler {
  static const CHANNEL_ID = '1',
      CHANNEL_NAME = 'Main Channel',
      CHANNEL_DESC = 'Channel for motivational quotes';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings initializationSettingsAndroid;
  IOSInitializationSettings initializationSettingsIOS;
  InitializationSettings initializationSettings;
  AndroidNotificationDetails androidPlatformChannelSpecifics;
  IOSNotificationDetails iOSPlatformChannelSpecifics;
  NotificationDetails platformChannelSpecifics;

  final BuildContext hostWidgetContext;

  NotificationHandler(this.hostWidgetContext) {
    // some initialization code for the notification plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      CHANNEL_ID,
      CHANNEL_NAME,
      CHANNEL_DESC,
    );
    iOSPlatformChannelSpecifics = IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
  }

  startDailyNotifications(Map<String, String> quote) async {
    // show notification at 8am everyday
    // will maybe allow user to choose notification time in the future
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Quote of the Day',
      '${quote['quote']} (${quote['author']})',
      Time(3, 46, 0),
      platformChannelSpecifics,
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
      context: hostWidgetContext,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('CLOSE'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }
}
