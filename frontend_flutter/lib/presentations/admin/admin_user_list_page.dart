import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/pusher.dart';
import 'package:frontend_flutter/service/api_config.dart';

class AdminUserListPage extends StatefulWidget {
  const AdminUserListPage({super.key});

  @override
  State<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  final StreamController<Map<String, dynamic>> _userStreamController =
      StreamController<Map<String, dynamic>>();

  PusherService pusherService = PusherService();

  Future<void> fetchFromApi() async {
    ApiConfig().fetchAllUserStream().listen((data) {
      print("ini adalah data from api");
      _userStreamController.add(data);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFromApi();
    pusherService.initializePusher();
    pusherService.subscribeToChannel("user-added", (event) => fetchFromApi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backGreyColor,
        body: StreamBuilder<Map<String, dynamic>>(
            stream: _userStreamController.stream,
            builder: (context, snapshot) {
              List<dynamic>? userData = snapshot.data?["data"];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (userData?.length == 0) {
                return Center(child: Text("Tidak ada data"));
              } else {
                return ListView.builder(
                    itemCount: userData?.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic>? mapData = userData?[index];
                      return ListTile(
                        leading: Text(mapData?["no_telp"]),
                        title: Text(mapData?["name"]),
                      );
                    });
              }
            }));
  }
}
