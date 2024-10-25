import 'dart:io';

import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_project/product_presentation/product_model.dart';
import 'package:test_project/repositories/product_repository_utils.dart';
import 'package:test_project/services/cart_service.dart';
import 'package:test_project/services/favorite_service.dart';
import 'package:test_project/services/product_service.dart';


/// [preCartStream]. [productCartStream]. [favoriteStream] ::
/// we are using streams to insure bloc to bloc communication
/// via injecting the same repository instance to the required blocs
/// meaning that we should register this repository as a singleton
/// and use DI ( dependency inversion ) to inject the implementation
/// rather than the abstract contract.

abstract interface class IProductRepository {

  Stream<Product> get preCartStream ;

  Stream<double> get downloadStream ;

  Stream<Product> get productCartStream ;

  Stream<Product> get favoriteStream ;

  Future<Result<List<Product>, ApplicationErrors>> getAllProducts();

  //// product crud : create / delete / getbyId / update ... etc
  Future<void> editProductPrefs({required Product editedProduct});

  Future<void> addProductToCart(
      {required String userId});

  Future<void> addProductToFavorite(
      {required Product product, required String userId});

  Future<Result<List<Product>, ApplicationErrors>> getListOfFavoriteProducts(
      {required String userId});

  Future<Result<List<Product>, ApplicationErrors>> getListOfCartProducts(
      {required String userId});

  Future<void> deleteListOfCartProducts(
      {required String userId, required List<String> productIdsToBeRemoved});

  Future<void> deleteListOfFavoriteProducts(
      {required String userId, required List<String> productIdsToBeRemoved});

  Future<Result<List<File?>, ApplicationErrors>> downloadFiles({
    required List<String> filesURL
});

  void dispose();
}

class ProductRepositoryIMPL implements IProductRepository {

  final IMockProductService productService;
  final IMockCartService cartService;
  final INetworkChecker networkChecker;
  final IMockFavoriteService favoriteService;

   final ReplaySubject<Product> _preCartStream =
  ReplaySubject<Product>(maxSize: 5);
   final ReplaySubject<Product> _productCartStream =
  ReplaySubject<Product>(maxSize: 20);
   final ReplaySubject<Product> _favoriteStream =
  ReplaySubject<Product>(maxSize: 20,);

   final BehaviorSubject<double> _downloadStreamController = BehaviorSubject<double>();
  ProductRepositoryIMPL({
    required this.productService,
    required this.cartService,
    required this.favoriteService,
    required this.networkChecker
  });
  @override
  Stream<Product> get preCartStream => _preCartStream.stream;

  @override
  Stream<Product> get productCartStream => _productCartStream.stream;

  @override
  Stream<Product> get favoriteStream => _favoriteStream.stream;

  @override
  Future<void> editProductPrefs({required Product editedProduct}) async {
    _preCartStream.add(editedProduct);
  }

  @override
  Future<Result<List<Product>, ApplicationErrors>> getAllProducts() async {
    try {
      if (await networkChecker.isConnected) {
        final result = await productService.getAllProductsFromApi();
        return Success(result);
      }
      return const Failure(NetworkError(
          errorMessage: 'Lost connection to internet', errorCode: 500));
    } on DioException catch (e) {
      return Failure(NetworkError(
          errorMessage: e.response?.statusMessage ?? e.error.toString(),
          errorCode: e.response?.statusCode));
    } catch (e) {
      return Failure(ApiError(
          errorMessage: e.toString(),
          errorCode: 500,
          stackTrace: 'product repository'));
    }
  }

  @override
  Future<void> addProductToCart(
      { required String userId}) async {
    try {
      if (await networkChecker.isConnected) {
        final lastPickedProduct = await preCartStream.last;
        final result = await cartService.addProductToCart(
            product: lastPickedProduct, userId: userId);
        _productCartStream.add(result);
      }
      _productCartStream.addError(const NetworkError(
          errorMessage: 'Lost connection to internet', errorCode: 500));
    } on DioException catch (e) {
      _productCartStream.addError(ApiError(
          errorMessage: e.response?.statusMessage ?? e.error.toString(),
          errorCode: e.response?.statusCode));
    } catch (e) {
      _productCartStream.addError(const NetworkError(
          errorMessage: 'Lost connection to internet', errorCode: 500));
    }
  }

  @override
  Future<void> addProductToFavorite(
      {required Product product, required String userId}) async {
    try {
      if (await networkChecker.isConnected) {
        final result = await favoriteService.addProductToFavorite(
            product: product, userId: userId);
        _favoriteStream.add(result);
      }
      _productCartStream.addError(const NetworkError(
          errorMessage: 'Lost connection to internet', errorCode: 500));
    } on DioException catch (e) {
      _productCartStream.addError(ApiError(
          errorMessage: e.response?.statusMessage ?? e.error.toString(),
          errorCode: e.response?.statusCode));
    } catch (e) {
      _productCartStream.addError(const NetworkError(
          errorMessage: 'Lost connection to internet', errorCode: 500));
    }
  }

  @override
  Future<Result<List<String>, ApplicationErrors>> deleteListOfCartProducts(
      {required String userId, required List<String> productIdsToBeRemoved}) {
// TODO: implement getListOfFavoriteProducts
    throw UnimplementedError();
  }

  @override
  Future<Result<List<String>, ApplicationErrors>> deleteListOfFavoriteProducts(
      {required String userId, required List<String> productIdsToBeRemoved})async {
   throw UnimplementedError();
}

@override
Future<Result<List<Product>, ApplicationErrors>> getListOfCartProducts(
    {required String userId}) async{

  try {
    if (await networkChecker.isConnected) {
      final result = await cartService.getAllCartItems(
          userId: userId);
      /// we will empty the stream and replace the values with the new list
      _productCartStream.stream.drain(result);
      return Success(result);
    }
    return const Failure( NetworkError(
        errorMessage: 'Lost connection to internet', errorCode: 500));
  } on DioException catch (e) {

    _productCartStream.addError(ApiError(
        errorMessage: e.response?.statusMessage ?? e.error.toString(),
        errorCode: e.response?.statusCode));
    return  Failure( ApiError(
        errorMessage: e.response?.statusMessage ?? e.error.toString(),
        errorCode: e.response?.statusCode));

  } catch (e) {

    _productCartStream.addError(const NetworkError(
        errorMessage: 'Lost connection to internet', errorCode: 500));

    return  const Failure( NetworkError(
        errorMessage: 'Server Error', errorCode: 500));
  }
}

@override
Future<Result<List<Product>, ApplicationErrors>> getListOfFavoriteProducts(
    {required String userId}) {
  // TODO: implement getListOfFavoriteProducts
  throw UnimplementedError();
}


  @override
  Future<Result<List<File?>, ApplicationErrors>> downloadFiles({required List<String> filesURL})async {
    try{
      if(await networkChecker.isConnected){
       final res=  await productService.downloadFiles(filesPath: filesURL,);
       productService.downloadProgress.listen(
           (onData){
             _downloadStreamController.add(onData);
           },
         onError: (e){
          _downloadStreamController.addError(e);
         }
       );
       return Success(res);
      }
      return  const Failure(NetworkError(
          errorMessage: 'Server Error', errorCode: 500));
    }on DioException catch(e){
      return   Failure(ApiError(
          errorMessage: e.response?.statusMessage ?? e.error.toString(), errorCode: e.response?.statusCode));
    } catch(e){
      return Failure(ApiError(
          errorMessage: e.toString(), errorCode: 500));
    }
  }

  @override
  void dispose() {
    _preCartStream.close();
    _productCartStream.close();
    _favoriteStream.close();
    _downloadStreamController.close();
    productService.dispose();
  }

  @override
  Stream<double> get downloadStream => _downloadStreamController.stream;
}
