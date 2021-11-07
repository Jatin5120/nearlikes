// To parse this JSON data, do
//
//     final metricsData = metricsDataFromJson(jsonString);

import 'dart:convert';

MetricsData metricsDataFromJson(String str) => MetricsData.fromJson(json.decode(str));

String metricsDataToJson(MetricsData data) => json.encode(data.toJson());

class MetricsData {
  MetricsData({
    this.data,
  });

  List<Datum> data;

  factory MetricsData.fromJson(Map<String, dynamic> json) => MetricsData(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.name,
    this.period,
    this.values,
    this.title,
    this.description,
    this.id,
  });

  String name;
  String period;
  List<Value> values;
  String title;
  String description;
  String id;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    period: json["period"],
    values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    title: json["title"],
    description: json["description"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "period": period,
    "values": List<dynamic>.from(values.map((x) => x.toJson())),
    "title": title,
    "description": description,
    "id": id,
  };
}

class Value {
  Value({
    this.value,
  });

  int value;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
  };
}