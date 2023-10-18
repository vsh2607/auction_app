import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend_flutter/blocs/product/bloc/product_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/product/product_detail_page.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ProductListPage extends StatefulWidget {
  final int status;
  const ProductListPage({super.key, required this.status});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<Map<String, dynamic>> data;

  Future<void> pusher() async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: "eefd7b8cb5d4753440bb",
        cluster: "ap1",
      );
      final myChannel = await pusher.subscribe(
          channelName: "product-added",
          onEvent: (event) {
            print("This is the event : $event");
            setState(() {
              data = ProductBloc().fethAllProduct(widget.status);
            });
          });

      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    data = ProductBloc().fethAllProduct(widget.status);
    pusher();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: FutureBuilder<Map<String, dynamic>>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final Map<String, dynamic> product = snapshot.data!;
              final List<dynamic> productData = product["data"];
              if (productData.isEmpty) {
                return Text('Tidak ada daftar barang');
              }
              return ListView.builder(
                itemCount: productData.length,
                itemBuilder: (context, index) {
                  final productItem = productData[index];
                  final data = productItem as Map<String, dynamic>;
                  final DateTime date = DateTime.parse(data["product_ddl"]);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                    productId: data["id"],
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
                                              data["product_img_path"]),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 50,
                                    right: 0,
                                    child: Container(
                                      width: 180,
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
                                            width: 45,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              '${data["product_size"]} ${data["product_unit"]}',
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
                                    text: data["product_name"],
                                    color: AppColors.mainColor,
                                    size: 18,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      AppLargeText(
                                        text: (AppFunctions.rupiahFormat
                                            .format(
                                                data["product_current_price"])
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
                },
              );
            }
          },
        ))
      ],
    );
  }
}
