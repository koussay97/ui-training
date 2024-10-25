part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  ProductState copyWith();

  void matcher({
    required Function(Product) onPreOrderEvent,
    required Function(Product, int) onAddedToCartSuccess,
    required Function(String) onAddedToCartFailure,
    required VoidCallback onAddToCartLoading,
  }) {}
}

final class ProductInitial extends ProductState {
  @override
  List<Object> get props => [];

  @override
  ProductState copyWith() {
    return this;
  }
}

final class AddedToCartSuccess extends ProductState {
  final Product product;
  final int globalCount;

  const AddedToCartSuccess({required this.product, required this.globalCount});

  @override
  List<Object?> get props => [product];

  @override
  ProductState copyWith({int? newCount, Product? newLastAddedProduct}) {
    return AddedToCartSuccess(
        globalCount: newCount ?? globalCount,
        product: newLastAddedProduct ?? product);
  }
}

final class AddedToCartErrorState extends ProductState {
  final String message;

  const AddedToCartErrorState({required this.message});

  @override
  ProductState copyWith({String? newErrorMessage}) {
    return AddedToCartErrorState(message: newErrorMessage ?? message);
  }

  @override
  List<Object?> get props => [message];
}

final class AddToCartLoadingState extends ProductState {
  @override
  ProductState copyWith() {
    return this;
  }

  @override
  List<Object?> get props => [];
}

final class PreparedProductOrderSuccess extends ProductState {
  final Product product;

  const PreparedProductOrderSuccess({required this.product});

  @override
  ProductState copyWith({Product? product}) {
    return PreparedProductOrderSuccess(product: product ?? this.product);
  }

  @override
  List<Object?> get props => [product];
}

final class AddToFavoriteLoadingState extends ProductState {
  @override
  ProductState copyWith() {
    return this;
  }

  @override
  List<Object?> get props => [];
}

final class AddedToFavoriteSuccessState extends ProductState {
  final Product product;
  final int globalCount;

  const AddedToFavoriteSuccessState(
      {required this.product, required this.globalCount});

  @override
  ProductState copyWith({
    Product? newProduct,
    int? newGlobalCount,
  }) {
    return AddedToFavoriteSuccessState(
      product: newProduct ?? product,
      globalCount: newGlobalCount ?? globalCount,
    );
  }

  @override
  List<Object?> get props => [product, globalCount];
}

final class AddedToFavoriteErrorState extends ProductState {
  final String errorMessage;

  const AddedToFavoriteErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];

  @override
  ProductState copyWith({String? message}) {
    return AddedToFavoriteErrorState(errorMessage: message ?? errorMessage);
  }
}

final class AddedToFavoriteLoadingState extends ProductState {
  @override
  List<Object?> get props => [];

  @override
  ProductState copyWith() {
    return this;
  }
}

final class DownloadImagesSuccess extends ProductState {
  final List<File?> images;

  const DownloadImagesSuccess({required this.images});

  @override
  ProductState copyWith({List<File?>? files}) {
    return DownloadImagesSuccess(images: files ?? images);
  }

  @override
  List<Object?> get props => [images];
}

final class DownloadImagesProgress extends ProductState {
  final double downloadPercentage;

  const DownloadImagesProgress({required this.downloadPercentage});

  @override
  ProductState copyWith({
    double? percentage,
  }) {
    return DownloadImagesProgress(
        downloadPercentage: percentage ?? downloadPercentage);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [downloadPercentage];
}

final class DownloadImagesFailure extends ProductState {
  final String message;

  const DownloadImagesFailure({required this.message});

  @override
  ProductState copyWith({String? message}) {
    return DownloadImagesFailure(message: message ?? this.message);
  }

  @override
  List<Object?> get props => [message];
}
