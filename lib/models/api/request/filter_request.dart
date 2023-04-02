// To parse this JSON data, do
//
//     final filterRequest = filterRequestFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/shared/prices.dart';

FilterRequest filterRequestFromJson(String str) =>
    FilterRequest.fromJson(json.decode(str));

String filterRequestToJson(FilterRequest data) => json.encode(data.toJson());

class FilterRequest {
  FilterRequest({
    this.filters,
    this.prices,
    this.sort,
  });

  List<FilterOptions>? filters;
  Prices? prices;
  SortData? sort;

  factory FilterRequest.fromJson(Map<String, dynamic> json) => FilterRequest(
        filters: List<FilterOptions>.from(
            json["filters"].map((x) => FilterOptions.fromJson(x))),
        prices: Prices.fromJson(json["prices"]),
        sort: SortData.fromJson(json["sort"]),
      );

  Map<String, dynamic> toJson() => {
        "filters": (filters != null)
            ? List<dynamic>.from(filters!.map((x) => x.toJson()))
            : null,
        "prices": (prices != null) ? prices!.toJson() : null,
        "sort": (sort != null) ? sort!.toJson() : null,
      };
}

class FilterOptions {
  FilterOptions({
    required this.filter,
    required this.options,
  });

  final String filter;
  final List<String> options;

  factory FilterOptions.fromJson(Map<String, dynamic> json) => FilterOptions(
        filter: json["filter"],
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "filter": filter,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}

class SortData {
  SortData({
    required this.field,
    required this.direction,
  });

  final String field;
  final String direction;

  factory SortData.fromJson(Map<String, dynamic> json) => SortData(
        field: json["field"],
        direction: json["direction"],
      );

  Map<String, dynamic> toJson() => {
        "field": field,
        "direction": direction,
      };
}
