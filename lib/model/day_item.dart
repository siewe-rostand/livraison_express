
class DayItem {
  bool? enabled;
  bool? opened;
  String? openedAt;
  String? closedAt;

  DayItem({this.enabled, this.opened, this.openedAt, this.closedAt});

  DayItem.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    opened = json['opened'];
    openedAt = json['opened_at'];
    closedAt = json['closed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['enabled'] = enabled;
    data['opened'] = opened;
    data['opened_at'] = openedAt;
    data['closed_at'] = closedAt;
    return data;
  }
}