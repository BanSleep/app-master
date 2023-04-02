import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentRegionProvider = StateNotifierProvider<CurrentRegion, int>((ref) {
  var set = ref.watch(settingsProvider);
  return CurrentRegion(0, set);
});

class CurrentRegion extends StateNotifier<int> {
  CurrentRegion(int state, this.set) : super(state) {
    init();
  }
  int get currState => state;
  final SettingsService set;

  void init() {
    state = getCurrentRegion();
  }

  int getCurrentRegion() {
    var id = set.getCurrentRegionId();
    return id;
  }

  int? getTrueRegionId() {
    var id = set.getTrueCurrentRegionId();
    return id;
  }

  Future<void> saveRegion(int id, String title) async {
    state = id;
    await set.setData<int>(SetKey.regionId, id);
    await set.setData<String>(SetKey.regionTitle, title);
  }
}
