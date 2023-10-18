import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend_flutter/blocs/product/bloc/product_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/admin/admin_home_page.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddProductPage extends StatefulWidget {
  const AdminAddProductPage({super.key});

  @override
  State<AdminAddProductPage> createState() => _AdminAddProductPageState();
}

class _AdminAddProductPageState extends State<AdminAddProductPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  File? _image;
  List<dynamic> itemUnit = [];
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 5);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> fetchProductUnit() async {
    final units = await ProductBloc().fetchProductUnits();
    for (var unit in units) {
      setState(() {
        itemUnit.add(unit);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductUnit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLargeText(
            text: "Tambah Produk Lelang", size: 17, color: Colors.white),
        backgroundColor: AppColors.mainColor,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is AddProductFailed) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Gagal'),
                content: Text(state.message),
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
          if (state is AddProductSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminHomePage(status: 1)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _getImage,
                              child: _image == null
                                  ? Icon(Icons.camera_alt, size: 150.0)
                                  : Image.file(_image!,
                                      width: 400, height: 100),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: "product_name",
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Nama Produk"),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: "product_size",
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Ukuran Produk"),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 10),
                            FormBuilderDropdown(
                              name: "product_unit",
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Satuan",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              items: itemUnit
                                  .map((unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: "product_description",
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Deskripsi Produk (Opsional)"),
                              maxLines: 3,
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: "product_initial_price",
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Harga Awal Produk"),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 10),
                            FormBuilderDateTimePicker(
                              name: "product_ddl",
                              firstDate: DateTime.now(),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Batas Waktu Lelang",
                                  suffixIcon: Icon(Icons.punch_clock)),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  FormBuilderState? formBuilderState =
                                      _formKey.currentState;

                                  File? productImage = _image;
                                  String productName = formBuilderState!
                                      .fields["product_name"]!.value
                                      .toString();
                                  String productUnit = formBuilderState
                                      .fields["product_unit"]!.value
                                      .toString();
                                  String productSize = formBuilderState
                                      .fields["product_size"]!.value
                                      .toString();
                                  String productDescription = formBuilderState
                                      .fields["product_description"]!.value
                                      .toString();
                                  String productInitialPrice = formBuilderState
                                      .fields["product_initial_price"]!.value
                                      .toString();
                                  String productDeadline = formBuilderState
                                      .fields["product_ddl"]!.value
                                      .toString();

                                  if (_formKey.currentState!
                                      .saveAndValidate()) {
                                    BlocProvider.of<ProductBloc>(context).add(
                                        AddProduct(
                                            productImage: productImage,
                                            productName: productName,
                                            productSize: int.parse(productSize),
                                            productUnit: productUnit,
                                            productDeadline: productDeadline,
                                            productDescription:
                                                productDescription,
                                            productInitialPrice: int.parse(
                                                productInitialPrice)));
                                  }
                                },
                                child: Text("Tambah Produk"),
                                style: ElevatedButton.styleFrom(
                                    primary: AppColors.mainColor),
                              ),
                            )
                          ],
                        ))),
              ),
              if (state is ProductLoading)
                Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                        child: CircularProgressIndicator(
                      backgroundColor: AppColors.mainColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.3)),
                    ))),
            ],
          );
        },
      ),
    );
  }
}
