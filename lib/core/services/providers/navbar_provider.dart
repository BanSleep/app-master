import 'package:cvetovik/models/enums/app/tab_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navBarProvider = Provider<NavBarProvider>((ref) {
  return NavBarProvider();
});

typedef OnTapCallback = void Function(TabItem tab);

class NavBarProvider {
  OnTapCallback? _onTapCallback;

  void init(OnTapCallback onTapCallback) {
    _onTapCallback = onTapCallback;
  }

  void onTap(TabItem tap) {
    if (_onTapCallback != null) {
      _onTapCallback!(tap);
    }
  }
}
