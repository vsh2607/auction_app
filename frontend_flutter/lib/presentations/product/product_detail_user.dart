import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_flutter/blocs/bidding/bloc/bidding_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/pusher.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailUserPage extends StatefulWidget {
  final int? productId;

  const ProductDetailUserPage({super.key, this.productId});

  @override
  State<ProductDetailUserPage> createState() => _ProductDetailUserPageState();
}

class _ProductDetailUserPageState extends State<ProductDetailUserPage> {
  StreamController<Map<String, dynamic>> _productDetailController =
      StreamController<Map<String, dynamic>>();
  StreamController<Map<String, dynamic>> _bidderProductDetailController =
      StreamController<Map<String, dynamic>>();
  PusherService pusherService = PusherService();

  late int _userId;

  Future<void> fetchFromApi() async {
    ApiConfig().fetchProductDetailStream(widget.productId).listen((data) {
      _productDetailController.add(data);
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
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      backgroundColor: AppColors.backGreyColor,
      body: StreamBuilder<Map<String, dynamic>>(
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
                            SizedBox(height: 25),
                            AppLargeText(
                                text:
                                    "${detailData["product_name"]} ${detailData["product_size"]} ${detailData["product_unit"]}",
                                color: AppColors.mainColor,
                                size: 30),
                            SizedBox(height: 10),
                            AppText(
                                text: "${detailData["product_description"]}",
                                size: 25,
                                color: Colors.black45),
                          ],
                        )),
                      ),
                    ],
                  ),
                  Positioned(
                      top: AppConstants.customScreenHeight(context, 0.60),
                      left: 25,
                      right: 25,
                      child: Container(
                        width: double.infinity,
                        height: 110,
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
                                    size: 25,
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
                                            fontSize: 25,
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
                      )),
                  Positioned(
                      left: 30,
                      right: 30,
                      top: AppConstants.customScreenHeight(context, 0.9),
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: AppLargeText(
                                      text: "Masukkan Harga Tawaran",
                                      size: 20,
                                      color: AppColors.mainColor,
                                    ),
                                    content:
                                        BlocConsumer<BiddingBloc, BiddingState>(
                                      listener: (context, state) {
                                        if (state is AddBiddingFailed) {
                                          showMyDialog(state.message);
                                        } else if (state is AddBiddingSuccess) {
                                          showMyDialog(state.message);
                                        }
                                      },
                                      builder: (context, state) {
                                        return FormBuilder(
                                          key: _formKey,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FormBuilderTextField(
                                                  name: "bidding_price",
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: const InputDecoration(
                                                      labelText:
                                                          "Harga tawaran",
                                                      border:
                                                          OutlineInputBorder()),
                                                  validator: (_) {
                                                    String? biddingInput =
                                                        _formKey
                                                            .currentState
                                                            ?.fields[
                                                                "bidding_price"]
                                                            ?.value;
                                                    int biddingPrice = detailData[
                                                            "product_current_price"] +
                                                        1000;
                                                    print(
                                                        "ini adalah bidding price : $biddingInput");
                                                    if (biddingInput == null) {
                                                      return "Input harga tidak boleh kosong";
                                                    } else if (int.parse(
                                                            biddingInput) <
                                                        biddingPrice) {
                                                      return "Harga harus lebih tinggi dari $biddingPrice";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: AppColors
                                                                    .mainColor,
                                                                minimumSize:
                                                                    const Size(
                                                                        230,
                                                                        30)),
                                                        onPressed: () {
                                                          String? biddingInput =_formKey.currentState?.fields["bidding_price"]?.value;
                                                          if (_formKey.currentState!.saveAndValidate()) {
                                                            if (DateTime.parse(detailData["product_ddl"]).isBefore(DateTime.now())) {
                                                                showMyDialog("Masa Waktu Lelang Telah Habis");
                                                            }else{
                                                                BlocProvider.of<BiddingBloc>(context).add(AddBidding(userId: _userId.toString(), productId: widget.productId.toString(), biddingAmount: biddingInput!));
                                                            }

                                                            
                                                          }
                                                        },
                                                        child: const Text("Input harga")))
                                              ]),
                                        );
                                      },
                                    ),
                                  );
                                });
                          },
                          child: Text("Tambah Tawaran"),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.mainColor,
                          ))),
                ],
              ),
            ]);
          }),
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
