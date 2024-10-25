import 'package:test_project/product_presentation/product_model.dart';

abstract interface class IMockFavoriteService {

  Future<Product> addProductToFavorite({
    required Product product,
    required String userId,
  });

  Future<List<Product>> getAllFavoriteItems({required String userId});


  Future<List<String>> deleteFavoriteItems({required List<String> productIds});

}

class MockFavoriteServiceIMPL implements IMockFavoriteService{


  @override
  Future<Product> addProductToFavorite({required Product product, required String userId}) {
    return Future.delayed(const Duration(milliseconds: 300), () => product,);
  }

  @override
  Future<List<String>> deleteFavoriteItems({required List<String> productIds}) async{
    return Future.delayed(const Duration(milliseconds: 300), () => [],);
  }

  @override
  Future<List<Product>> getAllFavoriteItems({required String userId}) async{
    return Future.delayed(const Duration(milliseconds: 300), () => [],);
  }

}