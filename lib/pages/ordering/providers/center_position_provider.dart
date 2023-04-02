import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final centerPositionProvider = StateProvider<MapPosition?>((ref) {
  return MapPosition(latitude: 0, longitude: 0);
});
