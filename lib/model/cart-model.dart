class CartItem {
  int? id;
  String? title;
  int? quantity;
  int? price;
  int? unitPrice;
  int? quantityMax;
  int? totalPrice;
  int? productId;
  int? categoryId;
  int? userId;
  String image;
  String? complement;
  int? preparationTime;
  String? moduleSlug;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.image,
      required this.productId,
      this.unitPrice,
      this.userId,
      this.categoryId,
      this.complement,
      this.preparationTime,
      this.totalPrice,
      this.quantityMax,
      this.moduleSlug});

  CartItem copyWith({
    int? id,
    String? title,
    int? quantity,
    int? price,
    int? unitPrice,
    int? quantityMax,
    int? totalPrice,
    int? productId,
    int? categoryId,
    int? userId,
    String? image,
    String? complement,
    int? preparationTime,
    String? moduleSlug,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      image: image ?? this.image,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      preparationTime: preparationTime ?? this.preparationTime,
      moduleSlug: moduleSlug ?? this.moduleSlug,
      complement: complement ?? this.complement,
      quantityMax: quantityMax ?? this.quantityMax,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'prix_unitaire': unitPrice,
        'prix_total': totalPrice,
        'quantity': quantity,
        'image': image,
        'quantiteMax': quantityMax,
        'id_produit': productId,
        'id_categorie': categoryId,
        'id_user': userId,
        'complements': complement,
        'module_slug': moduleSlug,
        'temps_preparation': preparationTime,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'],
      unitPrice: json['prix_unitaire'],
      totalPrice: json['prix_total'],
      quantityMax: json['quantiteMax'],
      productId: json['id_produit'],
      categoryId: json['id_categorie'],
      userId: json['id_user'],
      complement: json['complement'],
      preparationTime: json['time_preparation'],
      moduleSlug: json['module_slug'],
    );
  }
}
