import 'package:bloc/bloc.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bidding_event.dart';
part 'bidding_state.dart';

class BiddingBloc extends Bloc<BiddingEvent, BiddingState> {
  BiddingBloc() : super(BiddingInitial()) {
    on<BiddingEvent>((event, emit) {});
    on<AddBidding>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("user_token");
      emit(BiddingLoading());
      final response = await ApiConfig().addNewBidding(
          event.productId, event.userId, event.biddingAmount, token!);
      if (response["data"] == null) {
        emit(AddBiddingFailed(message: response["message"]));
      } else {
        emit(AddBiddingSuccess(
            message: "Selamat! Tawaran Anda telah ditambahkan"));
      }
      print(response);
    });
  }
}
