import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  late PusherChannelsFlutter _pusher;

  Future<void> initializePusher() async {
    try {
      _pusher = PusherChannelsFlutter.getInstance();
      await _pusher.init(
        apiKey: "eefd7b8cb5d4753440bb",
        cluster: "ap1",
      );
      await _pusher.connect();
    } catch (e) {
      print("Error Pusher $e");
    }
  }

  Future<void> subscribeToChannel(
      String channelName, Function(dynamic) onEventCallback) async {
    await _pusher.subscribe(
        channelName: channelName,
        onEvent: (event) {
          onEventCallback(event);
        });
  }

  Future<void> disconnectPusher() async {
    try {
      await _pusher.disconnect();
    } catch (e) {
      print("Error disconnect pusher $e");
    }
  }
}
