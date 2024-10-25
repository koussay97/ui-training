
import 'package:test_project/product_presentation/product_model.dart';

abstract interface class IMockCartService {

  Future<Product> addProductToCart({
    required Product product,
    required String userId,
});

  Future<List<Product>> getAllCartItems({required String userId});

  Future<List<String>> deleteCartItems({required List<String> productIds});


}

class MockCartServiceIMPL implements IMockCartService{
  @override
  Future<Product> addProductToCart({required Product product, required String userId}) {

    return Future.delayed(const Duration(milliseconds: 300), () => product,);

  }

  @override
  Future<List<Product>> getAllCartItems({required String userId}) {

    return Future.delayed(const Duration(milliseconds: 300), () => [],);
  }

  @override
  Future<List<String>> deleteCartItems({required List<String> productIds}) {

    return Future.delayed(const Duration(milliseconds: 300), () => productIds,);
  }

}