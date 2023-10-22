import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend_flutter/blocs/product/bloc/product_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/product/product_detail_page.dart';
import 'package:frontend_flutter/pusher.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ProductListPage extends StatefulWidget {
  final int status;
  const ProductListPage({super.key, required this.status});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final StreamController<Map<String, dynamic>> _productStreamController =
      StreamController<Map<String, dynamic>>();

  PusherService pusherService = PusherService();

  Future<void> fetchFromApi() async {
    Future.delayed(const Duration(seconds: 3));
    ApiConfig().fetchAllProductStream(widget.status).listen((data) {
      _productStreamController.add(data);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFromApi();
    pusherService.initializePusher();
    pusherService.subscribeToChannel("product-added", (event) {
      print(event);
      fetchFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backGreyColor,
        body: StreamBuilder<Map<String, dynamic>>(
          stream: _productStreamController.stream,
          builder: (context, snapshot) {
            List<dynamic>? test = snapshot.data?["data"];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (test?.length == 0) {
              return Center(child: Text("Tidak ada data"));
            }
            return ListView.builder(
                itemCount: test?.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> mapData = test?[index];
                  final DateTime date = DateTime.parse(mapData["product_ddl"]);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                    productId: mapData["id"],
                                  )));
                    },
                    child: SizedBox(
                      height: 270,
                      child: Stack(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 160,
                                        child: Image.network(
                                          ProductBloc().fetchImageProduct(
                                              mapData["product_img_path"]),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 50,
                                    right: 0,
                                    child: Container(
                                      width: 190,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 54,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              '${mapData["product_size"]} ${mapData["product_unit"]}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: TimerCountdown(
                                                format: CountDownTimerFormat
                                                    .hoursMinutesSeconds,
                                                endTime: date,
                                                timeTextStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                descriptionTextStyle:
                                                    const TextStyle(
                                                        fontSize: 11),
                                                spacerWidth: 2,
                                                enableDescriptions: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 40,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              // Atur jarak bawah antara teks
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLargeText(
                                    text: mapData["product_name"],
                                    color: AppColors.mainColor,
                                    size: 18,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      AppLargeText(
                                        text: (AppFunctions.rupiahFormat
                                            .format(mapData[
                                                "product_current_price"])
                                            .toString()),
                                        color: Colors.black,
                                        size: 15,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
