class Category {
  int? id;
  String? slug;
  String? libelle;
  String? image;
  int? level;
  Null? banner;
  Null? icon;
  bool? isAbstract;
  bool? hasChildren;
  int? childrenCount;
  String? description;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  List<Null>? children;

  Category(
      {this.id,
        this.slug,
        this.libelle,
        this.image,
        this.level,
        this.banner,
        this.icon,
        this.isAbstract,
        this.hasChildren,
        this.childrenCount,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.children});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    libelle = json['libelle'];
    image = json['image'];
    level = json['level'];
    banner = json['banner'];
    icon = json['icon'];
    isAbstract = json['is_abstract'];
    hasChildren = json['has_children'];
    childrenCount = json['children_count'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['libelle'] = this.libelle;
    data['image'] = this.image;
    data['level'] = this.level;
    data['banner'] = this.banner;
    data['icon'] = this.icon;
    data['is_abstract'] = this.isAbstract;
    data['has_children'] = this.hasChildren;
    data['children_count'] = this.childrenCount;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}