
import 'day_item.dart';

class Days {
  List<DayItem>? items;
  bool? opened;
  bool? enabled;

  Days({this.items, this.opened, this.enabled});

  Days.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <DayItem>[];
      json['items'].forEach((v) {
        items!.add(DayItem.fromJson(v));
      });
    }
    opened = json['opened'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['opened'] = opened;
    data['enabled'] = enabled;
    return data;
  }
}