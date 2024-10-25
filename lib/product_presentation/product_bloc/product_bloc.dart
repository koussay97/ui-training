import 'dart:ui';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_project/product_presentation/product_model.dart';
import 'package:test_project/repositories/product_repository.dart';

import 'product_bloc_utils.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IProductRepository productRepository;

  PrepareOrderEvent? previousEditPrefsEvent;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is RegisterStreams) {
     await ProductBlocUtils.registerStreams(emit: emit, productRepository: productRepository);

      } else if (event is AddToCartEvent) {
        emit(AddToCartLoadingState());
        final res = await productRepository.addProductToCart(userId: event.userId);

        /// we do not have to fold anything because the result will be available in the streams
      } else if (event is PrepareOrderEvent) {

        if (previousEditPrefsEvent != null &&
            previousEditPrefsEvent!.product != null) {
          final replacement = previousEditPrefsEvent!.copyWith(
              pickedPrice: event.pickedPrice,
              productCount: event.productCount,
              colorVariant: event.colorVariant);
          previousEditPrefsEvent = replacement;
        } else {
          previousEditPrefsEvent = event;
        }
      await productRepository.editProductPrefs(
            editedProduct: previousEditPrefsEvent!.product!);
      } else if (event is AddToFavoriteEvent) {
        emit(AddToFavoriteLoadingState());
        final result = await productRepository.addProductToFavorite(
            product: event.product, userId: event.userId);
      } else if (event is DownloadImagesEvent) {}
    });
  }

  @override
  Future<void> close() {
    productRepository.dispose();
    return super.close();
  }
}
