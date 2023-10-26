import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend_flutter/blocs/bidding/bloc/bidding_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/user/user_home_page.dart';
import 'package:frontend_flutter/pusher.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailUserPage extends StatefulWidget {
  final int? productId;

  const ProductDetailUserPage({super.key, this.productId});

  @override
  State<ProductDetailUserPage> createState() => _ProductDetailUserPageState();
}

class _ProductDetailUserPageState extends State<ProductDetailUserPage> {
  final StreamController<Map<String, dynamic>> _productDetailController =
      StreamController<Map<String, dynamic>>();
  PusherService pusherService = PusherService();

  late int _userId;
  late int _curPrice;

  Future<void> fetchFromApi() async {
    ApiConfig().fetchProductDetailStream(widget.productId).listen((data) {
      _productDetailController.add(data);
      setState(() {
        _curPrice = data["data"]["product_current_price"];
      });
    });
  }

  Future<void> fetchUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _userId = sp.getInt("user_id")!;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFromApi();
    fetchUserId();
    pusherService.initializePusher();
    pusherService.subscribeToChannel(
        "bidding-added", (event) => fetchFromApi());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGreyColor,
      body: WillPopScope(
        onWillPop: () async {
          pusherService.disconnectPusher();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserHomePage()));
          return false;
        },
        child: StreamBuilder<Map<String, dynamic>>(
            stream: _productDetailController.stream,
            builder: (context, snapshot) {
              Map<String, dynamic>? detailData = snapshot.data?["data"];

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (detailData == null) {
                return Center(child: Text("Tidak ada data"));
              }

              return BlocConsumer<BiddingBloc, BiddingState>(
                listener: (context, state) {
                  if (state is AddBiddingSuccess) {
                    showMyDialog(state.message);
                  } else if (state is AddBiddingFailed) {
                    showMyDialog(state.message);
                  }
                },
                builder: (context, state) {
                  return Column(children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: AppConstants.customScreenHeight(
                                  context, 0.45),
                              color: Colors.black,
                              child: Container(
                                child: Image.network(
                                  ApiConfig().fetchImageProduct(
                                      detailData["product_img_path"]),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              width: double.infinity,
                              height: AppConstants.customScreenHeight(
                                  context, 0.55),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    AppLargeText(
                                        text:
                                            "${detailData["product_name"]} ${detailData["product_size"]} ${detailData["product_unit"]}",
                                        color: AppColors.mainColor,
                                        size: 22),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.attach_money,
                                                      size: 16.0,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                    SizedBox(width: 4.0),
                                                    Text(
                                                      "Harga Awal",
                                                      style: TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  AppFunctions.rupiahFormat
                                                      .format(detailData[
                                                          "product_initial_price"]),
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.show_chart,
                                                      size: 16.0,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                    SizedBox(width: 4.0),
                                                    Text(
                                                      "Harga Sekarang",
                                                      style: TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  AppFunctions.rupiahFormat
                                                      .format(detailData[
                                                          "product_current_price"]),
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.timer_sharp,
                                                      size: 16.0,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                    SizedBox(width: 4.0),
                                                    Text(
                                                      "Sisa Waktu",
                                                      style: TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                  ],
                                                ),
                                                TimerCountdown(
                                                  format: CountDownTimerFormat
                                                      .hoursMinutesSeconds,
                                                  endTime: DateTime.parse(
                                                      detailData[
                                                          "product_ddl"]),
                                                  timeTextStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  spacerWidth: 2,
                                                  enableDescriptions: false,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015),
                                    Text(
                                      "Deskripsi Produk : ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mainColor),
                                    ),
                                    SizedBox(height: 10),
                                    AppText(
                                        text:
                                            "${detailData["product_description"]}",
                                        size: 18,
                                        color: Colors.black45),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 80,
                          left: -20,
                          right: -20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.mainColor)),
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.remove, color: Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        final temp = _curPrice - 1000;
                                        if (temp >=
                                            detailData[
                                                "product_current_price"]) {
                                          _curPrice = _curPrice - 1000;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    AppFunctions.rupiahFormat.format(_curPrice),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.mainColor)),
                                  child: IconButton(
                                    icon: Icon(Icons.add, color: Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        _curPrice = _curPrice + 1000;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (DateTime.parse(detailData["product_ddl"])
                                    .isBefore(DateTime.now())) {
                                  showMyDialog("Masa Waktu Lelang Telah Habis");
                                } else {
                                  BlocProvider.of<BiddingBloc>(context).add(
                                      AddBidding(
                                          userId: _userId.toString(),
                                          productId:
                                              detailData["id"].toString(),
                                          biddingAmount: _curPrice.toString()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Beli Sekarang",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state is BiddingLoading)
                          Container(
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: AppColors.mainColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.3)),
                              ))),
                      ],
                    ),
                  ]);
                },
              );
            }),
      ),
    );
  }

  Future<dynamic> showMyDialog(String message) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Informasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
