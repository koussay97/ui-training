// let us suppose that this is the data stuct of the products

class Product {


  List<String> get availableColors=> _availableColors;


  final String name;
  final List<String>images;

  final List<String> _availableColors;
  final String id;
  // al fi2a
  final String category;

  /// makan al mancha2
  final String manifacturerLocation;

  /// naw3 tawrid
  final String typeOfImportation;

  /// ism al 3alema tijereya
  final String benchMarkName;

  /// iste3mel
  final String whereToUse;

  /// alwadhifa
  final String function;

  /// lawnlMontaj
  final String color;

  /// al7ad al a9sa
  final double maxPrice;

  /// al7ad al adna
  final double minPrice;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String targetGender;
  final String categoryDescription;

  const Product({
    required this.name,
    required this.images,
    required this.categoryDescription,
    required this.targetGender,
    required  List<String>availableColors,
    required this.id,
    required this.benchMarkName,
    required this.category,
    required this.color,
    required this.createdAt,
    required this.function,
    required this.manifacturerLocation,
    required this.maxPrice,
    required this.minPrice,
    required this.typeOfImportation,
    required this.updatedAt,
    required this.whereToUse
  }): _availableColors = availableColors;

  Product copyWith({
    String? name,
    String? id,
    String? benchMarkName,
    String? category,
    String? color,
    DateTime? createdAt,
    String? function,
    String? manifacturerLocation,
    double? maxPrice,
    double? minPrice,
    String? typeOfImportation,
    DateTime? updatedAt,
    String? whereToUse,
    List<String>?availableCo,
    List<String>?images,
    String? targetGender,
    String? categoryDescription,
  }) {
    return Product(
      categoryDescription: categoryDescription?? this.categoryDescription,
      targetGender: targetGender?? this.targetGender,
      name: name??this.name,
      images: images??this.images,
        availableColors:availableCo?? _availableColors,
        id: id??this.id,
        benchMarkName: benchMarkName ?? this.benchMarkName,
        category: category ?? this.category,
        color: color ?? this.color,
        createdAt: createdAt ?? this.createdAt,
        function: function ?? this.function,
        manifacturerLocation: manifacturerLocation ?? this.manifacturerLocation,
        maxPrice: maxPrice ?? this.maxPrice,
        minPrice: minPrice ?? this.minPrice,
        typeOfImportation: typeOfImportation ?? this.typeOfImportation,
        updatedAt: updatedAt ?? this.updatedAt,
        whereToUse: whereToUse ?? this.whereToUse);
  }

  static Product empty() {
    return Product(
      targetGender: 'female',
      categoryDescription: 'bla bla',
      name: 'product 1',
      images: [],
        availableColors: ['red', 'green',],
        id: '1',
        benchMarkName: '--',
        category: '--',
        color: '--',
        createdAt: DateTime.now(),
        function: '--',
        manifacturerLocation: '--',
        maxPrice: 0.0,
        minPrice: 0.0,
        typeOfImportation: '--',
        updatedAt: DateTime.now(),
        whereToUse: '--');
  }
}