
import 'package:livraison_express/model/product.dart';


class Orders {
  int? idLivraison;
  int? idAchat;
  int? moduleId;
  String? module;
  int? magasinId;
  String? magasin;
  int? montantLivraison;
  int? montantRecuperation;
  int? montantExpedition;
  int? montantAchat;
  int? montantTotal;
  String? codePromo;
  String? commentaire;
  String? type;
  String? gratuitePour;
  String? commentaireClient;
  String? description;
  List<Products>? listeArticles;

  Orders(
      {this.idLivraison,
        this.idAchat,
        this.moduleId,
        this.module,
        this.magasinId,
        this.magasin,
        this.montantLivraison,
        this.montantRecuperation,
        this.montantExpedition,
        this.montantAchat,
        this.montantTotal,
        this.codePromo,
        this.commentaire,
        this.type,
        this.gratuitePour,
        this.commentaireClient,
        this.description});

  Orders.fromJson(Map<String, dynamic> json) {
    idLivraison = json["id_livraison"];
    idAchat = json["id_achat"];
    moduleId = json["module_id"];
    module = json["module"];
    magasinId = json["magasin_id"];
    magasin = json["magasin"];
    montantLivraison = json["montant_livraison"];
    montantRecuperation = json["montant_recuperation"];
    montantExpedition = json["montant_expedition"];
    montantAchat = json["montant_achat"];
    montantTotal = json["montant_total"];
    codePromo = json["code_promo"];
    commentaire = json["commentaire"];
    type = json["type"];
    gratuitePour = json["gratuite_pour"];
    commentaireClient = json["commentaire_client"];
    description = json["description"];
    listeArticles = json["liste_articles"] == null
        ? null
        : (json["liste_articles"] as List).map((e) => Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id_livraison"] = idLivraison;
    data["id_achat"] = idAchat;
    data["module_id"] = moduleId;
    data["module"] = module;
    data["magasin_id"] = magasinId;
    data["magasin"] = magasin;
    data["montant_livraison"] = montantLivraison;
    data["montant_recuperation"] = montantRecuperation;
    data["montant_expedition"] = montantExpedition;
    data["montant_achat"] = montantAchat;
    data["montant_total"] = montantTotal;
    data["code_promo"] = codePromo;
    data["commentaire"] = commentaire;
    data["type"] = type;
    data["gratuite_pour"] = gratuitePour;
    data["commentaire_client"] = commentaireClient;
    data["description"] = description;
    if (listeArticles != null) {
      data["liste_articles"] = listeArticles?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}