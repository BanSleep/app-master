import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_type.dart';
import 'package:cvetovik/pages/products/widget/sort/sort_list_widget.dart';
import 'package:cvetovik/pages/search/search_result_content_widget.dart';
import 'package:cvetovik/pages/search/search_result_empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultPage extends ConsumerWidget {
  const SearchResultPage(
      {Key? key,
      required this.data,
      required this.onSort,
      required this.sortType,
      required this.search,
      this.favorites})
      : super(key: key);
  final ProductsResponse data;
  final OnSort onSort;
  final SortType sortType;
  final List<FavoriteData>? favorites;
  final String search;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.result == false || data.data == null || data.data!.isEmpty)
      return SearchEmptyResultWidget(
        search: search,
      );
    else {
      return SearchResultContentWidget(
        data: data.data!,
        favorites: favorites,
        search: search,
        sortCallback: () async {
          await sortCallback(context, ref);
        },
      );
    }
  }

  Future<void> sortCallback(BuildContext context, WidgetRef ref) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return SortListWidget(
          sortType: sortType,
          onSort: onSort,
        );
      },
    );
  }
}
