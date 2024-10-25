import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:test_project/product_presentation/product_bloc/product_bloc.dart';
import 'package:test_project/product_presentation/product_model.dart';

import 'package:test_project/product_presentation/product_view/product_page_content.dart';
import 'package:test_project/repositories/product_repository.dart';
import 'package:test_project/repositories/product_repository_utils.dart';
import 'package:test_project/services/cart_service.dart';
import 'package:test_project/services/favorite_service.dart';
import 'package:test_project/services/product_service.dart';

class ProductPage extends StatelessWidget {
  const  ProductPage({super.key});
 static Dio dio = Dio();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Product?;

   /* Navigator.of(context).push(
      MaterialPageRoute(
          settings: Product(),
          builder: (context,)=>ProductPage()),);
    */
    return RepositoryProvider<IProductRepository>(
      create: (context) => ProductRepositoryIMPL(
          productService: MockProductService(dioInstance: dio),
          cartService: MockCartServiceIMPL(),
          favoriteService: MockFavoriteServiceIMPL(),
          networkChecker: NetworkCheckerIMPL(checker: InternetConnection())
      ),
      child: MultiBlocProvider(
          providers: [
        BlocProvider<ProductBloc>(
            create: (context) =>
                ProductBloc(
                    productRepository: context.read<IProductRepository>())..add(RegisterStreams())
        ),
      ],
          child: ProductPageContent(
            product: args,
          )),
    );
  }


}

