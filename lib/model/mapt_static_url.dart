
class MapStaticUrls {
  String? chargement;
  String? livraison;

  MapStaticUrls({this.chargement, this.livraison});

  MapStaticUrls.fromJson(Map<String, dynamic> json) {
    chargement = json["chargement"];
    livraison = json["livraison"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["chargement"] = chargement;
    data["livraison"] = livraison;
    return data;
  }
}