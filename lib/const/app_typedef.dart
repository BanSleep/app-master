import 'package:cvetovik/pages/ordering/models/address_full_data.dart';

typedef OnSelectedAddressAsync = Future<void> Function(AddressFullData title);
typedef OnSelectedStrAsync = Future<void> Function(String title);
typedef OnProcess = void Function(bool state);
