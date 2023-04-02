import 'package:align_positioned/align_positioned.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/navbar_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/models/enums/app/tab_item.dart';
import 'package:cvetovik/pages/cart/cart_page.dart';
import 'package:cvetovik/pages/cart/provider/cart_count_provider.dart';
import 'package:cvetovik/pages/catalog/catalog_page.dart';
import 'package:cvetovik/pages/favorites/favorites_page.dart';
import 'package:cvetovik/pages/home/home_page.dart';
import 'package:cvetovik/pages/profile/orders/order_list/orders_model.dart';
import 'package:cvetovik/pages/profile/profile_page.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:cvetovik/widgets/share/circle_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../main.dart';

class HomeTabNavigator extends ConsumerStatefulWidget {
  const HomeTabNavigator({Key? key, required this.isDark}) : super(key: key);

  final bool isDark;

  @override
  _HomeTabNavigatorState createState() => _HomeTabNavigatorState();
}

class _HomeTabNavigatorState extends ConsumerState<HomeTabNavigator> {
  TabItem _currentTab = (isProd) ? TabItem.catalog : TabItem.main;
  bool isInitCatalog = false;

  final CupertinoTabController _controller = CupertinoTabController();
  final homeNavKey = NavData(navKey: GlobalKey<NavigatorState>());
  final catalogNavKey = NavData(navKey: GlobalKey<NavigatorState>());
  final profileNavKey = NavData(navKey: GlobalKey<NavigatorState>());
  final cartNavKey = NavData(navKey: GlobalKey<NavigatorState>());
  final favNavKey = NavData(navKey: GlobalKey<NavigatorState>());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var barProvider = ref.read(navBarProvider);
      barProvider.init((TabItem tab) {
        setState(() {
          var index = tab.index;
          if (isProd) {
            index = index - 1;
            if (index < 0) {
              index = 0;
            }
          }
          _currentTab = tab;
          _controller.index = index;
        });
      });
      print('init');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double widthIcon = 19.43.w;
    final double heightIcon = 17.h;
    return Localizations(
      locale: Locale('en'),
      delegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      child: CupertinoTabScaffold(
        controller: _controller,
        tabBuilder: (BuildContext context, int index) {
          if (isProd) {
            index = index + 1;
          }
          var selectedTab = TabItem.values[index];
          switch (selectedTab) {
            case TabItem.main:
              return HomePage(
                navKey: homeNavKey,
              );
            case TabItem.catalog:
              return CatalogPage(
                title: AppRes.catalog,
                navKey: catalogNavKey,
              );
            case TabItem.cart:
              return CartPage(
                navKey: cartNavKey,
              );
            case TabItem.favorites:
              return FavoritesPage(
                navKey: favNavKey,
              );
            case TabItem.profile:
              return ProfilePage(
                navKey: profileNavKey,
              );
          }
        },
        tabBar: CupertinoTabBar(
            border: Border(),
            backgroundColor: AppColors.getBackground(widget.isDark),
            inactiveColor: AppColors.getInactiveColor(widget.isDark),
            activeColor: AppColors.primary,
            onTap: (index) async {
              if (isProd) {
                index = index + 1;
              }
              var selectedTab = TabItem.values[index];
              if (_currentTab != selectedTab) {
                if (selectedTab == TabItem.profile) {
                  ref.read(ordersModelProvider.notifier).reload();

                  ref.read(personalStartModelProvider.notifier).init();
                }
                setState(() {
                  _currentTab = selectedTab;
                });
              } else {
                //to first tab
                switch (selectedTab) {
                  case TabItem.main:
                    _openFirstPageForTab(homeNavKey);
                    break;
                  case TabItem.catalog:
                    _openFirstPageForTab(catalogNavKey);
                    break;
                  case TabItem.cart:
                    _openFirstPageForTab(cartNavKey);
                    break;
                  case TabItem.favorites:
                    _openFirstPageForTab(favNavKey);
                    break;
                  case TabItem.profile:
                    _openFirstPageForTab(profileNavKey);
                    break;
                }
              }
            },
            items: <BottomNavigationBarItem>[
              if (!isProd)
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.home,
                      color: _getTabColor(TabItem.main),
                      width: widthIcon,
                      height: heightIcon,
                    ),
                    label: AppRes.main),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.catalog,
                  color: _getTabColor(TabItem.catalog),
                  width: widthIcon,
                  height: heightIcon,
                ),
                label: AppRes.catalog,
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Center(
                        child: SvgPicture.asset(
                      AppIcons.cart,
                      color: _getTabColor(TabItem.cart),
                      width: widthIcon,
                      height: heightIcon,
                    )),
                    Consumer(builder: (BuildContext context, watch, _) {
                      var count = ref.watch(cartCountProvider);
                      if (count.count > 0) {
                        return AlignPositioned(
                          child: CirclePoint(
                            size: 8.r,
                          ),
                          alignment: Alignment(0.5, -0.5),
                          touch: Touch.middle,
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                  ],
                ),
                label: AppRes.cart,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.favorite,
                  color: _getTabColor(TabItem.favorites),
                  width: widthIcon,
                  height: heightIcon,
                ),
                label: AppRes.favorites,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.profile,
                  color: _getTabColor(TabItem.profile),
                  width: widthIcon,
                  height: heightIcon,
                ),
                label: AppRes.appName,
              ),
            ]),
      ),
    );
  }

  void _openFirstPageForTab(NavData navData) {
    /*key.currentState!.pushNamedAndRemoveUntil("/",
        (route) => route.isFirst && route.settings.name == "/" ? false : true);
    return;*/
    if (navData.observer.history.length > 1) {
      navData.observer.clear();
      navData.navKey.currentState!
          .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
    }
  }

  Color _getTabColor(TabItem item) {
    if (_currentTab == item)
      return AppColors.primary;
    else
      return AppAllColors.lightDarkGrey;
  }
}
