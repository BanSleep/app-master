import 'dart:convert';

import 'filter_request.dart';

SearchParamRequest searchParamRequestFromJson(String str) =>
    SearchParamRequest.fromJson(json.decode(str));

String searchParamRequestToJson(SearchParamRequest data) =>
    json.encode(data.toJson());

class SearchParamRequest {
  SearchParamRequest({
    required this.searchText,
    required this.sort,
  });

  String searchText;
  SortData sort;

  factory SearchParamRequest.fromJson(Map<String, dynamic> json) =>
      SearchParamRequest(
        searchText: json["search_text"],
        sort: SortData.fromJson(json["sort"]),
      );

  Map<String, dynamic> toJson() => {
        "search_text": searchText,
        "sort": sort.toJson(),
      };
}
