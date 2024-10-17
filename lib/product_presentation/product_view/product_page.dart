import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/product_presentation/mock_order_repository.dart';
import 'package:test_project/product_presentation/orders_bloc/orders_bloc.dart';
import 'package:test_project/product_presentation/product_model.dart';

import 'package:test_project/product_presentation/product_view/product_page_content.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Product?;

   /* Navigator.of(context).push(
      MaterialPageRoute(
          settings: Product(),
          builder: (context,)=>ProductPage()),);
    */
    return RepositoryProvider<OrderRepository>(
      create: (context) => OrderRepository(),
      child: MultiBlocProvider(
          providers: [
        BlocProvider<OrdersBloc>(
            create: (context) =>
                OrdersBloc(repository: context.read<OrderRepository>())),
      ],
          child:  ProductPageContent(
            product: args,
          )),
    );
  }


}

