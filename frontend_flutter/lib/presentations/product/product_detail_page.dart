import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend_flutter/blocs/bidding/bloc/bidding_bloc.dart';
import 'package:frontend_flutter/blocs/product/bloc/product_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/admin/admin_bidders_list_page.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_text.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  final int? productId;
  const ProductDetailPage({super.key, this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _userType = "";
  int _userId = 0;
  late Future<Map<String, dynamic>> input;

  Future<void> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString("user_type");
    setState(() {
      _userType = type!;
    });
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");
    setState(() {
      _userId = userId!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserType();
    getUserId();
    input = ProductBloc().fetchDetailProduct(widget.productId!);
    pusher();
  }

  Future<void> pusher() async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: "eefd7b8cb5d4753440bb",
        cluster: "ap1",
      );
      final myChannel = await pusher.subscribe(
          channelName: "bidding-added",
          onEvent: (event) {
            print("This is the event : $event");
            setState(() {
              input = ProductBloc().fetchDetailProduct(widget.productId!);
            });
          });

      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: input,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data!;
              final Map<String, dynamic> result = data["data"];
              return Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ListView(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Image.network(
                                ProductBloc().fetchImageProduct(
                                    result["product_img_path"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 20),
                              child: Row(
                                children: [
                                  AppLargeText(
                                    text: result["product_name"],
                                    size: 25,
                                  ),
                                  SizedBox(width: 20),
                                  AppText(
                                    text: result["product_size"].toString(),
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  AppText(
                                    text: result["product_unit"],
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 5),
                              child: Row(
                                children: [
                                  AppText(
                                    text: result["product_description"],
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppText(
                                      text: AppTimer.dateDeadlineFormat(
                                          result["product_ddl"]),
                                      size: 18,
                                    )
                                  ]),
                            ),
                            SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 200,
                                child: Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 20, top: 50),
                                            child: Column(
                                              children: [
                                                AppText(
                                                  text: AppFunctions
                                                      .rupiahFormat
                                                      .format(result[
                                                          "product_initial_price"]),
                                                  size: 20,
                                                ),
                                                SizedBox(height: 20),
                                                AppText(
                                                  text: "Harga Mulai",
                                                  size: 18,
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 20, top: 50),
                                            child: Column(
                                              children: [
                                                AppText(
                                                  text: AppFunctions
                                                      .rupiahFormat
                                                      .format(result[
                                                          "product_current_price"]),
                                                  size: 20,
                                                ),
                                                SizedBox(height: 20),
                                                AppText(
                                                  text: "Harga Tertinggi",
                                                  size: 18,
                                                )
                                              ],
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                            _userType == "admin"
                                ? Container(
                                    padding: EdgeInsets.all(16.0),
                                    width: double.infinity,
                                    height: 80.0,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListBiddersPage(
                                                          productId:
                                                              result["id"])));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: AppColors.mainColor,
                                        ),
                                        child: Text("Lihat Penawar")),
                                  )
                                : Container(
                                    child:
                                        BlocConsumer<BiddingBloc, BiddingState>(
                                      listener: (context, state) {
                                        if (state is AddBiddingFailed) {
                                          showMyDialog(state.message);
                                        } else if (state is AddBiddingSuccess) {
                                          showMyDialog(state.message);
                                        }
                                      },
                                      builder: (context, state) {
                                        final _formKey =
                                            GlobalKey<FormBuilderState>();

                                        return Container(
                                          padding: EdgeInsets.all(16.0),
                                          width: double.infinity,
                                          height: 80.0,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Masukkan harga tawaran"),
                                                    content: FormBuilder(
                                                      key: _formKey,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FormBuilderTextField(
                                                            name:
                                                                "harga_lelang",
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  "Harga tawaran",
                                                            ),
                                                            validator: (_) {
                                                              if (int.parse(_formKey
                                                                      .currentState
                                                                      ?.fields[
                                                                          "harga_lelang"]
                                                                      ?.value) <=
                                                                  result[
                                                                      "product_current_price"]) {
                                                                return "Harga tawaran harus lebih tinggi dari harga saat ini";
                                                              } else if (_formKey
                                                                      .currentState
                                                                      ?.fields[
                                                                          "harga_lelang"]
                                                                      ?.value
                                                                      .toString() ==
                                                                  "") {
                                                                return "This field cannot be empty.";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(height: 20),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              String? price = _formKey
                                                                  .currentState
                                                                  ?.fields[
                                                                      "harga_lelang"]
                                                                  ?.value;
                                                              if (_formKey
                                                                  .currentState!
                                                                  .saveAndValidate()) {
                                                                BlocProvider.of<BiddingBloc>(context).add(AddBidding(
                                                                    userId: _userId
                                                                        .toString(),
                                                                    productId: result[
                                                                            "id"]
                                                                        .toString(),
                                                                    biddingAmount:
                                                                        price!));
                                                              }

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text("Simpan"),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary:
                                                                        AppColors
                                                                            .mainColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColors.mainColor,
                                            ),
                                            child: Text('Pasang Harga'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
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
