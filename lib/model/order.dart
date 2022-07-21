import 'package:livraison_express/model/articles.dart';

class Order{
  String? module;
  String? description;
  String? promoCode;
  String? commentaire;
  int? magasinId;
  int? montantTotal;
  int? montantLivraison;
  List<Article>? articles;

  Order({
   this.magasinId,this.description,this.module,this.articles,this.commentaire,this.montantLivraison,
   this.montantTotal,this.promoCode
});

  Order.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    description = json['description'];
    montantLivraison = json['montant_livraison'];
    montantTotal = json['montant_total'];
    promoCode = json['code_promo'];
    commentaire = json['commentaire'];
    if (json['liste_articles'] != null) {
      articles = <Article>[];
      json['liste_articles'].forEach((v) {
        articles!.add(Article.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module'] = module;
    data['magasin_id'] = magasinId;
    data['description'] = description;
    data['montant_livraison'] = montantLivraison;
    data['montant_total'] = montantTotal;
    data['code_promo'] = promoCode;
    data['commentaire'] = commentaire;
    if (articles != null) {
      data['liste_articles'] = articles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}