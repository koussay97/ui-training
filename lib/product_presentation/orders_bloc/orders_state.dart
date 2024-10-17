part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  OrdersState copyWith();
}

final class OrdersInitial extends OrdersState {
  @override
  List<Object> get props => [];

  @override
  OrdersState copyWith() {
    return this;
  }
}

final class AddedToCartSuccess extends OrdersState {
  final int count;

  const AddedToCartSuccess({required this.count});

  @override
  List<Object?> get props => [count];

  @override
  OrdersState copyWith({int? newCount}) {
    return AddedToCartSuccess(count: count + (newCount ?? 0));
  }
}

final class AddedToCartErrorState extends OrdersState {
  final String message;

  const AddedToCartErrorState({ required this.message});

  @override
  OrdersState copyWith({ String? newErrorMessage}) {
    return AddedToCartErrorState(message: newErrorMessage?? message);
  }
  @override
  List<Object?> get props => [message];

}

final class AddToCartLoadingState extends OrdersState{
  @override
  OrdersState copyWith() {
   return this;
  }
  @override

  List<Object?> get props => [];

}