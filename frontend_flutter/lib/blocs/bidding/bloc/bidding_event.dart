part of 'bidding_bloc.dart';

abstract class BiddingEvent {}

class AddBidding extends BiddingEvent {
  String userId;
  String productId;
  String biddingAmount;

  AddBidding(
      {required this.userId,
      required this.productId,
      required this.biddingAmount});
}
