import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogIdProvider = Provider<CatalogIdRepository>((ref) {
  return CatalogIdRepository();
});

class CatalogIdRepository {
  int id = 0;
  int addId = 0;

  void restore() {
    if (addId > 0) {
      id = addId;
      addId = 0;
    }
  }
}
