import 'package:flutter/material.dart';

class AppBuildSearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.black12,
            width: 2.0,
          ),
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Cari barang',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
