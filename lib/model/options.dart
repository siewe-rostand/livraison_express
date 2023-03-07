

class Options{
  int? id;
  String? name;
  int? price;
  int? quantity;
  Options({this.id,this.name,this.price,this.quantity});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['libelle'];
    price = json['prix'];
    quantity = json['quantite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = name;
    data['prix'] = price;
    data['quantite'] = quantity;
    return data;
  }
}