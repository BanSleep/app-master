import 'package:cvetovik/models/api/response/cabinet/favorite_address_list_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_addresses_state.freezed.dart';

@freezed
class FavoriteAddressesState with _$FavoriteAddressesState {
  const factory FavoriteAddressesState.initializing() = _Initializing;
  const factory FavoriteAddressesState.loaded(List<FavoriteAddress> data) =
      _Loaded;
  const factory FavoriteAddressesState.emptyData() = _EmptyData;
  const factory FavoriteAddressesState.error(String? text) = _Error;
}
