import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      
    );
  }

  static void showLocalNotification(String productName) async {
    var android = AndroidNotificationDetails(
      'channel id',
      'channel name',
      enableVibration: true, 
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
    );
    var platform = NotificationDetails(android: android);
    
    await flutterLocalNotificationsPlugin.show(0,'Waktu Lelang telah habis','Cek produk yang barusan anda tawar untuk mengecek apakah anda pemenangnya!',platform);

  }
}