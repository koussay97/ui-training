import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/product_presentation/product_bloc/product_bloc.dart';
import 'package:test_project/repositories/product_repository.dart';
import 'package:test_project/repositories/product_repository_utils.dart';

abstract class ProductBlocUtils {
  static Future<void> registerStreams({
    required Emitter<ProductState> emit,
    required IProductRepository productRepository,
  }) async {
    /// DO NOT AWAIT the lists at the very start, because
    /// final lastAddedProductsToCart =  await productRepository.productCartStream.toList();
    /// will only complete when receiving a value in the stream!!

    
    /// register preCartStream
    await emit.forEach(
      productRepository.preCartStream,
      onData: (onData) {
        return PreparedProductOrderSuccess(product: onData);
      },
    );
    await emit.forEach(productRepository.downloadStream, onData: (onData) {
      return DownloadImagesProgress(downloadPercentage: onData);
    }, onError: (er, stacktrace) {
      return DownloadImagesFailure(
          message: (er as ApplicationErrors).errorMessage);
    });

    final lastAddedProductsToCart =
    await productRepository.productCartStream.toList();
   await emit.forEach(productRepository.productCartStream, onData: (onData) {
      int number = 0;
      if (lastAddedProductsToCart.isEmpty) {

        return AddedToCartSuccess(
            product: onData, globalCount: onData.productCount);
      }
      lastAddedProductsToCart.forEach((el) {
        number += el.productCount;
      });
      return AddedToCartSuccess(product: onData, globalCount: number);
    }, onError: (err, stacktrace) {
      return AddedToCartErrorState(
          message: (err as ApplicationErrors).errorMessage);
    });

    final lastAddedProductsToFav =
    await productRepository.favoriteStream.toList();
    await emit.forEach(productRepository.favoriteStream, onData: (onData) {
      return AddedToFavoriteSuccessState(
          product: onData, globalCount: lastAddedProductsToFav.length);
    }, onError: (error, stackTrace) {
      return AddedToFavoriteErrorState(
          errorMessage: (error as ApplicationErrors).errorMessage);
    });

  }
}
