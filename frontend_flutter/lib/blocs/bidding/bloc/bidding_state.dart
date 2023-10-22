part of 'bidding_bloc.dart';

abstract class BiddingState {}

final class BiddingInitial extends BiddingState {}

class AddBiddingFailed extends BiddingState {
  String message;
  AddBiddingFailed({required this.message});
}

class AddBiddingSuccess extends BiddingState {
  String message;
  AddBiddingSuccess({required this.message});
}
