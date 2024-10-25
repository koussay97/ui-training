part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {

  const ProductEvent();

}

final class AddToCartEvent extends ProductEvent{
  final String userId;

  const AddToCartEvent({ required this.userId});
  @override
  List<Object?> get props => [userId];

}
final class PrepareOrderEvent extends ProductEvent{
   final Product? product;
   final int? productCount;
   final String? colorVariant;
   final double? pickedPrice;

  const PrepareOrderEvent({ this.product, this.colorVariant, this.productCount, this.pickedPrice});
  @override
  List<Object?> get props =>[product,colorVariant, pickedPrice,productCount];

  PrepareOrderEvent copyWith ({
     int? productCount,
     String? colorVariant,
     double? pickedPrice,

}){
    final newProduct = product?.copyWith(
      productCount: productCount??product?.productCount,
      currentColor: colorVariant??product?.currentColor,
      pickedPrice: pickedPrice?? product?.productPickedPrice,
    );
    final newInstance = PrepareOrderEvent(
      product: newProduct
    );
    return newInstance;
  }
}
final class DownloadImagesEvent extends ProductEvent{

  final List<String>images;
  const DownloadImagesEvent({
    required this.images,
});

  @override
  List<Object?> get props => [images];
}

final class RegisterStreams extends ProductEvent {
  @override
  List<Object?> get props => [];
}

final class AddToFavoriteEvent extends ProductEvent{

  final Product product;
  final String userId;

 const AddToFavoriteEvent({required this.product, required this.userId});

  @override
  List<Object?> get props => [product, userId];
}
