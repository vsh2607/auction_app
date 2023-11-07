import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/admin/admin_home_page.dart';
import 'package:frontend_flutter/pusher.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailAdminPage extends StatefulWidget {
  final int? productId;
  const ProductDetailAdminPage({super.key, this.productId});

  @override
  State<ProductDetailAdminPage> createState() => _ProductDetailAdminPageState();
}

class _ProductDetailAdminPageState extends State<ProductDetailAdminPage> {
  StreamController<Map<String, dynamic>> _productDetailController =
      StreamController<Map<String, dynamic>>();
  StreamController<Map<String, dynamic>> _bidderProductDetailController =
      StreamController<Map<String, dynamic>>();
  PusherService pusherService = PusherService();

  Future<void> fetchFromApi() async {
    ApiConfig().fetchProductDetailStream(widget.productId).listen((data) {
      _productDetailController.add(data);
    });

    ApiConfig().fetchBiddersByProductIdStream(widget.productId).listen((data) {
      _bidderProductDetailController.add(data);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFromApi();
    pusherService.initializePusher();
    pusherService.subscribeToChannel(
        "bidding-added", (event) => fetchFromApi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGreyColor,
      body: WillPopScope(
        onWillPop: () async{
          pusherService.disconnectPusher();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminHomePage(status: 1)));
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
              return Column(children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: AppConstants.customScreenHeight(context, 0.45),
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
                          margin: const EdgeInsets.only(left: 30),
                          width: double.infinity,
                          height: AppConstants.customScreenHeight(context, 0.55),
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 50),
                              AppLargeText(
                                  text:
                                      "${detailData["product_name"]} ${detailData["product_size"]} ${detailData["product_unit"]}",
                                  color: AppColors.mainColor,
                                  size: 25),
                              SizedBox(height: 10),
                              AppText(
                                  text: "${detailData["product_description"]}",
                                  size: 15,
                                  color: Colors.black45),
                              SizedBox(height: 20),
                              AppLargeText(
                                  text: "Penawar",
                                  size: 20,
                                  color: AppColors.mainColor),
                              Container(
                                  margin: const EdgeInsets.only(right: 30),
                                  width: double.infinity,
                                  height: AppConstants.customScreenHeight(
                                      context, 0.32),
                                  child: Center(
                                    child: StreamBuilder<Map<String, dynamic>>(
                                      stream:
                                          _bidderProductDetailController.stream,
                                      builder: (context, snapshot) {
                                        List<dynamic>? biddersList =
                                            snapshot.data?["data"];
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: CircularProgressIndicator());
                                        } else if (biddersList?.length == null ||
                                            biddersList?.length == 0) {
                                          return Center(
                                              child: Text("Belum ada penawar"));
                                        }
                                        return ListView.builder(
                                          itemCount: biddersList?.length,
                                          itemBuilder: ((context, index) {
                                            Map<String, dynamic>? bidderUserData =
                                                biddersList?[index]["user"];
                                            return Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    top: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(10))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AppLargeText(
                                                          text:
                                                              "${bidderUserData?["name"]}",
                                                          size: 17,
                                                          color:
                                                              AppColors.mainColor,
                                                        ),
                                                        SizedBox(height: 10),
                                                        AppLargeText(
                                                          text:
                                                              "Harga Tawaran : ${biddersList?[index]['max_bidding_amount']}",
                                                          size: 14,
                                                          color: Colors.black45,
                                                        )
                                                      ],
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        final phoneNumber =
                                                            '${bidderUserData?["no_telp"]}';
                                                        String num =
                                                            "+62${phoneNumber.substring(1)}";
                                                        const message =
                                                            'Halo dari Aplikasi Lelang LaHaP!';
      
                                                        final whatsappUrl =
                                                            'https://wa.me/$num/?text=${Uri.parse(message)}';
      
                                                        launchUrl(Uri.parse(
                                                            whatsappUrl));
                                                      },
                                                      icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .whatsapp),
                                                      color: AppColors.mainColor,
                                                    )
                                                  ],
                                                ));
                                          }),
                                        );
                                      },
                                    ),
                                  )),
                            ],
                          )),
                        ),
                      ],
                    ),
                    Positioned(
                        top: AppConstants.customScreenHeight(context, 0.36),
                        left: 30,
                        right: 30,
                        child: Container(
                          width: double.infinity,
                          height: 90,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    spreadRadius: 1,
                                    blurRadius: 4)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppLargeText(
                                      text: AppFunctions.rupiahFormat.format(
                                          detailData["product_current_price"]),
                                      size: 20,
                                      color: AppColors.mainColor,
                                    ),
                                    SizedBox(height: 15),
                                    AppText(
                                      text: "Harga sekarang",
                                      size: 15,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 60),
                              Container(
                                margin: const EdgeInsets.only(top: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.timer_outlined,
                                            color: AppColors.mainColor),
                                        const SizedBox(width: 5),
                                        TimerCountdown(
                                          format: CountDownTimerFormat
                                              .hoursMinutesSeconds,
                                          endTime: DateTime.parse(
                                              detailData["product_ddl"]),
                                          timeTextStyle: const TextStyle(
                                              fontSize: 20,
                                              color: AppColors.mainColor,
                                              fontWeight: FontWeight.bold),
                                          spacerWidth: 2,
                                          enableDescriptions: false,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    const AppText(
                                      text: "Waktu Akhir Lelang",
                                      size: 15,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ]);
            }),
      ),
    );
  }
}
