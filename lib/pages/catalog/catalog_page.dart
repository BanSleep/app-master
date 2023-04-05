import 'package:collection/collection.dart';
import 'package:cvetovik/core/services/providers/delivery_info_provider.dart';
import 'package:cvetovik/core/services/providers/region_info_provider.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/models/state/catalog_state.dart';
import 'package:cvetovik/pages/catalog/catalog_model.dart';
import 'package:cvetovik/pages/catalog/widget/catalog_content.dart';
import 'package:cvetovik/pages/catalog/widget/suggestions_page.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_type.dart';
import 'package:cvetovik/pages/products/pages/suggestion_page.dart';
import 'package:cvetovik/pages/search/search_result_page.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:cvetovik/widgets/region/provider/current_region_provider.dart';
import 'package:cvetovik/widgets/region/region_popup.dart';
import 'package:cvetovik/widgets/search_bar/search_bar_widget.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/state/not_data_widget.dart';
import 'package:cvetovik/widgets/tab_root.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class CatalogPage extends ConsumerStatefulWidget {
  final int parentId;
  final String title;
  final NavData? navKey;

  const CatalogPage({required this.title, this.parentId = 0, this.navKey});

  @override
  ConsumerState createState() => _CatalogWidgetState();
}

class _CatalogWidgetState extends ConsumerState<CatalogPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoaded = false;
  List<Region> regItems = [];
  late Region selectedRegion;
  bool filtered = false;
  bool needBack = false;

  //final searchKey = GlobalKey();

  int relevantRegionId = 0;

  @override
  Widget build(BuildContext context) {
    var catalog = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: _getLeading(context),
        title: SearchBarWidget(
          onChanged: (str) async {
            if (str.length > 2) {
              var model = _getModel();
              await model.getSuggestionsByText(str);
            } else if (str.length == 0) {
              var model = _getModel();
              await model.getSuggestions();
            }
          },
          onTap: () async {
            setState(() {
              needBack = true;
            });
            var model = _getModel();
            await model.getSuggestions();
          },
          //key: searchKey,
          action: (String text) async {
            filtered = text.isNotEmpty;
            await _searchAction(text);
          },
        ),
        leadingWidth: AppUi.leadingWidth,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        Widget? body;

        final stateCatalogModel =
            ref.watch(catalogModelProvider(widget.parentId));

        stateCatalogModel.maybeWhen(
          suggestions: (data) {
            print("data ${data}");
            body = SuggestionsPage(isSearch: false, suggestions: data, onTap: (str) async {
              await _searchAction(str);
            },);
          },
            suggestionsByText: (data) {
              body = SuggestionsPage(isSearch: true, model: data.data, onTap: (str) async {
                await _searchAction(str);
              },);
            },
            searchProducts: (data, favorites, search) {
              body = SearchResultPage(
                data: data,
                search: search,
                favorites: favorites,
                sortType: SortType.downPop,
                onSort: (sort) async {
                  var model = _getModel();
                  await model.applySort(sortType: sort);
                },
              );
            },
            loaded: (data, reg) {
              var items = data.data!.values.toList();
              body = CatalogContent(
                title: widget.title,
                items: items,
                parentId: widget.parentId,
              );
              if (isProd)
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) async {
                    regItems = reg;
                    var currentRegion =
                        ref.watch(currentRegionProvider.notifier);
                    currentRegion.init();
                    var regId = currentRegion.getTrueRegionId();

                    if (regId == null) {
                      selectedRegion = regItems.first;
                      await currentRegion.saveRegion(
                          selectedRegion.id, selectedRegion.title);
                      if (!isLoaded) {
                        isLoaded = true;
                        await Future.delayed(Duration(milliseconds: 50));
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return RegionPopup(
                              items: regItems,
                              onSelected: _onSelected,
                              selected: selectedRegion.title,
                              showCancel: false,
                            );
                          },
                        ).then((value) {
                          print('');
                        });
                      }
                    }
                  },
                );
            },
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
            orElse: () {
              body = LoadingWidget();
            });

        return body ?? Container();
      }),
    );
    if (widget.parentId == 0)
      return TabRoot(
        catalog,
        navData: widget.navKey,
      );
    else {
      return catalog;
    }
  }

  CatalogModel _getModel() =>
      ref.watch(catalogModelProvider(widget.parentId).notifier);

  Widget? _getLeading(BuildContext context) {
    return (widget.parentId > 0 || filtered)
        ? AppBackButton(tap: () async {
            if (filtered) {
              filtered = false;
              await _searchAction('');
              //await (searchKey.currentState as ClearValueMixin).clear();
            } else {
              Navigator.pop(context);
            }
          })
        : needBack ? AppBackButton(tap: () async {
          FocusManager.instance.primaryFocus!.unfocus();
          var model = _getModel();
          model.state = CatalogState.initializing();
          await model.load();
          setState(() {
            needBack = false;
          });
    }) : null;
  }

  Future<void> _searchAction(String text) async {
    var model = _getModel();
    await model.search(text);
  }

  Future<void> _onSelected(String title) async {
    var item = regItems.firstWhereOrNull((element) => element.title == title);
    if (item != null && item.title != selectedRegion.title) {
      selectedRegion = item;
      ref.watch(deliveryInfoProvider.notifier).init();
      ref.read(repositoryInfoProvider).init();

      await ref
          .read(currentRegionProvider.notifier)
          .saveRegion(selectedRegion.id, selectedRegion.title);
      await _getModel().load();
    }
  }
}
