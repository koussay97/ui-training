import 'dart:math';

import 'package:result_dart/result_dart.dart';

class OrderRepository{


  Future<Result< int,Exception>> addElementToCartRemotely()async{
    await Future.delayed(const Duration(seconds: 1));
    final int number = Random().nextInt(5);
    return Result.success(number);
  }

}