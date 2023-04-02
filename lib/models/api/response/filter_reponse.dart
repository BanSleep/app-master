// To parse this JSON data, do
//
//     final filterResponse = filterResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:cvetovik/models/api/shared/prices.dart';

FilterResponse filterResponseFromJson(String str) =>
    FilterResponse.fromJson(json.decode(str));

//String filterResponseToJson(FilterResponse data) => json.encode(data.toJson());

class FilterResponse extends AppBaseResponse {
  FilterResponse({
    result,
    this.data,
  }) : super(result);

  FilterItemData? data;

  factory FilterResponse.fromJson(Map<String, dynamic> json) => FilterResponse(
        result: json["result"],
        data: FilterItemData.fromJson(json["data"]),
      );
}

class FilterItemData {
  FilterItemData({
    required this.prices,
    required this.filters,
  });

  Prices prices;
  Map<String, Filter>? filters;

  factory FilterItemData.fromJson(Map<String, dynamic> json) {
    try {
      var filter = FilterItemData(
        prices: Prices.fromJson(json["prices"]),
        filters: json["filters"] != null
            ? Map.from(json["filters"])
                .map((k, v) => MapEntry<String, Filter>(k, Filter.fromJson(v)))
            : null,
      );
      return filter;
    } catch (e) {
      var filter = FilterItemData(
        prices: Prices.fromJson(json["prices"]),
        filters: null,
      );
      return filter;
    }
  }

  Map<String, dynamic> toJson() => {
        "prices": prices.toJson(),
        "filters": filters != null
            ? Map.from(filters!)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson()))
            : null,
      };
}

class Filter {
  Filter({
    required this.id,
    required this.title,
    required this.color,
    required this.options,
  });

  int id;
  String title;
  bool color;
  Map<String, String> options;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        id: json["id"],
        title: json["title"],
        color: json["color"],
        options: Map.from(json["options"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "color": color,
        "options":
            Map.from(options).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
