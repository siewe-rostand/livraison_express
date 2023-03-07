
class OrderStatus {
  int? id;
  String? logName;
  String? description;
  int? subjectId;
  String? subjectType;
  int? causerId;
  String? causerType;
  List<dynamic>? properties;
  String? createdAt;
  String? updatedAt;

  OrderStatus({this.id, this.logName, this.description, this.subjectId, this.subjectType, this.causerId, this.causerType, this.properties, this.createdAt, this.updatedAt});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["log_name"] is String) {
      logName = json["log_name"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["subject_id"] is int) {
      subjectId = json["subject_id"];
    }
    if(json["subject_type"] is String) {
      subjectType = json["subject_type"];
    }
    if(json["causer_id"] is int) {
      causerId = json["causer_id"];
    }
    if(json["causer_type"] is String) {
      causerType = json["causer_type"];
    }
    if(json["properties"] is List) {
      properties = json["properties"] ?? [];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["log_name"] = logName;
    data["description"] = description;
    data["subject_id"] = subjectId;
    data["subject_type"] = subjectType;
    data["causer_id"] = causerId;
    data["causer_type"] = causerType;
    if(properties != null) {
      data["properties"] = properties;
    }
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}