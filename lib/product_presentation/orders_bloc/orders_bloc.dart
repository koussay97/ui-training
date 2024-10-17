import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../mock_order_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {

  final OrderRepository repository;

  OrdersBloc({required this.repository}) : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit)async {
     if (event is AddToCartEvent){
       emit(AddToCartLoadingState());
      final res= await repository.addElementToCartRemotely() ;
      res.fold((onSuccess){

        emit(AddedToCartSuccess(count: onSuccess));
      }, (onFailure){
        emit(AddedToCartErrorState(message: onFailure.toString()));
      });
     }

  });
  }
}


