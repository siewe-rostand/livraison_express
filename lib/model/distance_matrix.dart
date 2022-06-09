class DistanceMatrix {
  String? destination;
  String? origin;
  Values? values;
  String? distanceText;
  int? distance;
  String? durationText;
  int? duration;
  int? prix;
  bool? acceptable;
  String? status;

  DistanceMatrix(
      {this.destination,
      this.origin,
      this.values,
      this.distanceText,
      this.distance,
      this.durationText,
      this.duration,
      this.status,
        this.acceptable,
      this.prix});

  DistanceMatrix.fromJson(Map<String, dynamic> json) {
    destination = json["destination"];
    origin = json["origin"];
    values = json["values"] == null ? null : Values.fromJson(json["values"]);
    distanceText = json["distance_text"];
    distance = json["distance"];
    durationText = json["duration_text"];
    duration = json["duration"];
    prix = json["prix"];
    status = json["status"];
    acceptable = json["acceptable"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["destination"] = destination;
    data["origin"] = origin;
    if (values != null) {
      data["values"] = values?.toJson();
    }
    data["distance_text"] = distanceText;
    data["distance"] = distance;
    data["duration_text"] = durationText;
    data["duration"] = duration;
    data["prix"] = prix;
    data["status"] = status;
    data["acceptable"] = acceptable;
    return data;
  }
}

class Values {
  Distance? distance;
  Durations? duration;
  String? status;

  Values({this.distance, this.duration, this.status});

  Values.fromJson(Map<String, dynamic> json) {
    distance =
        json["distance"] == null ? null : Distance.fromJson(json["distance"]);
    duration =
        json["duration"] == null ? null : Durations.fromJson(json["duration"]);
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) {
      data["distance"] = distance?.toJson();
    }
    if (duration != null) {
      data["duration"] = duration?.toJson();
    }
    data["status"] = status;
    return data;
  }
}

class Durations {
  String? text;
  int? value;

  Durations({this.text, this.value});

  Durations.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    data["value"] = value;
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    data["value"] = value;
    return data;
  }
}
