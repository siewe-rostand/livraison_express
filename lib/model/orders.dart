import 'package:livraison_express/model/client.dart';
import 'package:livraison_express/model/extra.dart';
import 'package:livraison_express/model/order.dart';
import 'package:livraison_express/model/payment.dart';
import 'package:livraison_express/model/shop.dart';

import 'infos.dart';

class Command {
  Infos? infos;
  Client? client;
  Client? sender;
  Client? receiver;
  Shops? magasin;
  Orders? orders;
  List<dynamic>? attachments;
  Payment? paiement;
  Extra? extra;

  Command(
      {this.infos,
      this.client,
      this.sender,
      this.receiver,
      this.magasin,
      this.orders,
      this.attachments,
      this.paiement,
      this.extra});

  Command.fromJson(Map<String, dynamic> json) {
    infos = json["infos"] == null ? null : Infos.fromJson(json["infos"]);
    client = json["client"] == null ? null : Client.fromJson(json["client"]);
    sender = json["sender"] == null ? null : Client.fromJson(json["sender"]);
    receiver =
        json["receiver"] == null ? null : Client.fromJson(json["receiver"]);
    magasin =
        json["magasin"] == null ? null : Shops.fromJson(json["magasin"]);
    orders = json["orders"] == null ? null : Orders.fromJson(json["orders"]);
    attachments = json["attachments"] ?? [];
    paiement =
        json["paiement"] == null ? null : Payment.fromJson(json["paiement"]);
    extra = json["extra"] == null ? null : Extra.fromJson(json["extra"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (infos != null) {
      data["infos"] = infos?.toJson();
    }
    if (client != null) {
      data["client"] = client?.toJson();
    }
    if (sender != null) {
      data["sender"] = sender?.toJson();
    }
    if (receiver != null) {
      data["receiver"] = receiver?.toJson();
    }
    if (magasin != null) {
      data["magasin"] = magasin?.toJson();
    }
    if (orders != null) {
      data["orders"] = orders?.toJson();
    }
    if (attachments != null) {
      data["attachments"] = attachments;
    }
    if (paiement != null) {
      data["paiement"] = paiement?.toJson();
    }
    if (extra != null) {
      data["extra"] = extra?.toJson();
    }
    return data;
  }
}