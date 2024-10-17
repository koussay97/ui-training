import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/product_presentation/orders_bloc/orders_bloc.dart';


class CartNotificationWidget extends StatelessWidget {
  const CartNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        debugPrint('Go to Cart Screen');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: deviceWidth * 0.1,
              height: deviceWidth * 0.1,
              //  color: Colors.amber,
            ),
            Positioned(
                width: deviceWidth * 0.07,
                /// todo : replace this with the design icon
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: deviceWidth * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(300),
                  ),
                  child: Icon(
                    size: deviceWidth * 0.04,
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                )),
            Positioned(
              top: -5,
              right: -5,

              /// todo : replace this with the design icon
              child: Container(
                padding: const EdgeInsets.all(4),
                height: deviceWidth * 0.07,
                width: deviceWidth * 0.07,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(300),
                ),
                /// todo ::: change this bloc to the corresponding cart bloc
                child: BlocBuilder<OrdersBloc, OrdersState>(
                    builder: (context, state) {
                  if (state is AddedToCartSuccess) {
                    return Center(
                      child: Text(
                        '${state.count}',
                        style: TextStyle(color: Colors.white,fontSize: deviceWidth * 0.002),
                      ),
                    );
                  }
                  else if(state is AddedToCartErrorState){
                    return  Center(
                      child: Text(
                        '--',
                        style: TextStyle(color: Colors.white,
                            fontSize: deviceWidth * 0.002),
                      ),
                    );
                  }
                  else if(state is AddToCartLoadingState){
                    return const Center(child: CircularProgressIndicator(color: Colors.white,),);
                  }
                  else{
                    return const Center(
                      child: Text(
                        '0',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
