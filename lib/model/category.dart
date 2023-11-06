class Category {
  int? id;
  String? slug;
  String? libelle;
  String? image;
  int? level;
  bool? isAbstract;
  bool? hasChildren;
  int? childrenCount;
  String? description;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
        this.slug,
        this.libelle,
        this.image,
        this.level,
        this.isAbstract,
        this.hasChildren,
        this.childrenCount,
        this.description,
        this.createdAt,
        this.updatedAt,});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    libelle = json['libelle'];
    image = json['image'];
    level = json['level'];
    isAbstract = json['is_abstract'];
    hasChildren = json['has_children'];
    childrenCount = json['children_count'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['libelle'] = libelle;
    data['image'] = image;
    data['level'] = level;
    data['is_abstract'] = isAbstract;
    data['has_children'] = hasChildren;
    data['children_count'] = childrenCount;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}