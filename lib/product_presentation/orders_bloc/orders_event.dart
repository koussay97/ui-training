part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();
}

final class AddToCartEvent extends OrdersEvent{
  final int count;
  const AddToCartEvent({required this.count});
  @override
  List<Object?> get props => [count];
}
