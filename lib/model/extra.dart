
import 'mapt_static_url.dart';

class Extra {
  MapStaticUrls? mapStaticUrls;
  String? factureDownload;
  String? factureLink;
  String? commandesAchats;
  String? produits;
  String? factureAchatsDownload;
  String? factureAchatsLink;

  Extra(
      {this.mapStaticUrls,
        this.factureDownload,
        this.factureLink,
        this.commandesAchats,
        this.produits,
        this.factureAchatsDownload,
        this.factureAchatsLink});

  Extra.fromJson(Map<String, dynamic> json) {
    mapStaticUrls = json["map_static_urls"] == null
        ? null
        : MapStaticUrls.fromJson(json["map_static_urls"]);
    factureDownload = json["facture_download"];
    factureLink = json["facture_link"];
    commandesAchats = json["commandes_achats"];
    produits = json["produits"];
    factureAchatsDownload = json["facture_achats_download"];
    factureAchatsLink = json["facture_achats_link"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mapStaticUrls != null) {
      data["map_static_urls"] = mapStaticUrls?.toJson();
    }
    data["facture_download"] = factureDownload;
    data["facture_link"] = factureLink;
    data["commandes_achats"] = commandesAchats;
    data["produits"] = produits;
    data["facture_achats_download"] = factureAchatsDownload;
    data["facture_achats_link"] = factureAchatsLink;
    return data;
  }
}