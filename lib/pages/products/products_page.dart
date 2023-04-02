import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/shared/filter_data.dart';
import 'package:cvetovik/pages/catalog/models/catalog_second_data.dart';
import 'package:cvetovik/pages/products/products_model.dart';
import 'package:cvetovik/pages/products/widget/filter/filter_dialog.dart';
import 'package:cvetovik/pages/products/widget/product/products_content.dart';
import 'package:cvetovik/pages/products/widget/sort/sort_list_widget.dart';
import 'package:cvetovik/pages/search/search_result_page.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:cvetovik/widgets/region/provider/current_region_provider.dart';
import 'package:cvetovik/widgets/search_bar/search_bar_widget.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/state/not_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/enum/sort/sort_type.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage(
      {Key? key,
      required this.productId,
      required this.title,
      this.count,
      this.secondItems})
      : super(key: key);
  final int productId;
  final String title;
  final String? count;
  final List<CatalogSecondData>? secondItems;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductsPage> {
  //final searchKey = GlobalKey();
  int relevantRegionId = 0;

  @override
  Widget build(
    BuildContext scaffoldContext,
  ) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: AppBackButton(tap: () async {
          if (filtered) {
            filtered = false;
            //await (searchKey.currentState as ClearValueMixin).clear();
            await _searchAction('');
          } else {
            Navigator.pop(scaffoldContext);
          }
        }),
        title: SearchBarWidget(
          //key: searchKey,
          action: _searchAction,
        ),
        leadingWidth: AppUi.leadingWidth,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          Widget? body;

          int stateRegion = ref.watch(currentRegionProvider.notifier).currState;

          if (stateRegion != relevantRegionId) {
            print("relevant region: $relevantRegionId");
            if (relevantRegionId != 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _getModel().load();
                print("get model loaded");
                Navigator.popUntil(scaffoldContext,
                    (Route<dynamic> predicate) => predicate.isFirst);
                return;
              });
            }

            relevantRegionId = stateRegion;
            print("loaded new product model");
          }

          final state = ref.watch(productsModelProvider(widget.productId));
          state.maybeWhen(
            searchProducts: (data, favorites, search) {
              body = SearchResultPage(
                data: data,
                search: search,
                favorites: favorites,
                sortType: SortType.downPop,
                onSort: (sort) async {
                  var model = _getModel();
                  await model.applySortForSearch(sort);
                },
              );
            },
            loaded: (data, info, favorites,bannerText) {
              var items = data.data!.toList();
              // print("badges products_page: ${items.map((e) => e.badges).toSet()}");
              body = ProductsContent(bannerText: bannerText,
                  key: GlobalKey(),
                  title: widget.title,
                  items: items,
                  secondItems: widget.secondItems,
                  filterIsSelected: filterIsSelected,
                  filterCallback: () async {
                    await filterCallback(context);
                  },
                  sortCallback: () async {
                    await sortCallback(context);
                  },
                  count: widget.count,
                  info: info,
                  favorites: favorites,
                  productId: widget.productId);
            },
            orElse: () => body = Container(),
            initializing: () => body = LoadingWidget(),
            emptyData: () => body = NotDataWidget(),
            error: (String? text) {
              body = AppErrorWidget(
                text: text,
                tryAgain: () async {
                  await _getModel().load();
                },
              );
            },
          );
          return body ?? Container();
        },
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => _hui(scaffoldContext),
      ),*/
    );
  }

  bool filterIsSelected = false;
  bool filtered = false;

  Future<void> filterCallback(BuildContext context) async {
    var model = _getModel();
    var data = await model.getFilters();
    showDialog(
      context: context,
      builder: (_) => FilterDialog(data, model.filter),
    ).then((filter) async {
      if (filter != _filter && filter != null) {
        await _getModel().applyFilters(filter: filter);
      } else {
        if (filter == null && _filter != null) {
          await _getModel().load();
        }
      }
      _filter = filter;
      setState(() {
        filterIsSelected = (filter != null);
      });
    });
  }

  FilterData? _filter;

  Future<void> sortCallback(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return SortListWidget(
          sortType: _getModel().sortType,
          onSort: _onSort,
        );
      },
    );
  }

  Future<void> _onSort(SortType sort) async {
    var model = _getModel();
    await model.applyFilters(sort: sort, filter: _filter);
  }

  ProductsModel _getModel() {
    var model = ref.read(productsModelProvider(widget.productId).notifier);
    return model;
  }

  Future<void> _searchAction(String text) async {
    var model = _getModel();
    filtered = text.isNotEmpty;
    await model.search(text);
  }
}
