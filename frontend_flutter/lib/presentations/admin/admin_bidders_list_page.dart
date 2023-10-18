import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/blocs/bidding/bloc/bidding_bloc.dart';

class ListBiddersPage extends StatefulWidget {
  final int productId;
  const ListBiddersPage({super.key, required this.productId});

  @override
  State<ListBiddersPage> createState() => _ListBiddersPageState();
}

class _ListBiddersPageState extends State<ListBiddersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: BiddingBloc().fetchBidders(widget.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data;
              List<dynamic> result = data!["data"];
              return Center(child: Text("Tidak ada Penawar"));
            }
          },
        ),
      ),
    );
  }
}
