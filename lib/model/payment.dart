class Payment {
  String? message;
  String? paymentMode;
  String? status;
  String? paymentIntent;
  String? datePayment;
  int? totalAmount;
  int? idPayment;
  Payment(
      {this.idPayment,
      this.totalAmount,
      this.message,
      this.paymentIntent,
      this.status,
      this.paymentMode,
      this.datePayment});

  Payment.fromJson(Map<String, dynamic> json) {
    idPayment = json['id_paiement'];
    totalAmount = json['montant_total'];
    message = json['message'];
    paymentIntent = json['payment_intent'];
    status = json['statut'];
    paymentMode = json['mode_paiment'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_paiement'] = idPayment;
    data['montant_total'] = totalAmount;
    data['message'] = message;
    data['payment_intent'] = paymentIntent;
    data['statut'] = status;
    data['mode_paiment'] = paymentMode;
    return data;
  }
}
