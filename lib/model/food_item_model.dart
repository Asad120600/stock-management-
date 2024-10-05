class FoodItem {
  final int id;
  final String name;
  final String code;
  final int categoryId;
  final String salePrice;
  final String? ingredients;

  FoodItem({
    required this.id,
    required this.name,
    required this.code,
    required this.categoryId,
    required this.salePrice,
    this.ingredients,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      categoryId: json['category_id'],
      salePrice: json['sale_price'],
      ingredients: json['ingredients'],
    );
  }
}
