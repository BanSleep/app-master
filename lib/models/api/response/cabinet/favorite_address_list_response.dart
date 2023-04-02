import 'package:cvetovik/core/helpers/json_convertors.dart';
import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'favorite_address_list_response.g.dart';

class FavoriteAddressListResponse extends AppBaseResponse {
  FavoriteAddressListResponse({
    required result,
    this.data,
  }) : super(result);

  List<FavoriteAddress>? data;

  factory FavoriteAddressListResponse.fromJson(json) =>
      FavoriteAddressListResponse(
        result: json["result"],
        data: json["data"] != null
            ? FavoriteAddress.fromJsonToList(json["data"])
            : null,
      );
}

@JsonSerializable()
class EditFavoriteAddressRequest {
  const EditFavoriteAddressRequest({
    required this.title,
    required this.name,
    required this.phone,
    required this.address,
    required this.addressAdditional,
  });

  final String title;
  final String name;
  final String phone;
  final String address;
  @JsonKey(name: 'address_additional')
  final String addressAdditional;

  factory EditFavoriteAddressRequest.fromJson(json) =>
      _$EditFavoriteAddressRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EditFavoriteAddressRequestToJson(this);
}

@JsonSerializable()
class AddFavoriteAddressRequest {
  const AddFavoriteAddressRequest({
    required this.regionId,
    required this.title,
    required this.name,
    required this.phone,
    required this.address,
    required this.addressAdditional,
  });

  @JsonKey(name: 'region_id')
  @IntFromStringConverter()
  final int regionId;
  final String title;
  final String name;
  final String phone;
  final String address;
  @JsonKey(name: 'address_additional')
  final String addressAdditional;

  factory AddFavoriteAddressRequest.fromJson(json) =>
      _$AddFavoriteAddressRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddFavoriteAddressRequestToJson(this);
}

@JsonSerializable()
class FavoriteAddress {
  const FavoriteAddress({
    required this.id,
    required this.regionId,
    required this.title,
    required this.name,
    required this.phone,
    required this.address,
    required this.addressAdditional,
  });

  final int id;
  @IntFromStringConverter()
  @JsonKey(name: 'region_id')
  final int regionId;
  final String title;
  final String name;
  final String phone;
  final String address;
  @JsonKey(name: 'address_additional')
  final String addressAdditional;

  factory FavoriteAddress.fromJson(json) => _$FavoriteAddressFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteAddressToJson(this);

  static List<FavoriteAddress> fromJsonToList(json) {
    if (json is Map) json = json.values;
    return json
        .map((e) => FavoriteAddress.fromJson(e))
        .cast<FavoriteAddress>()
        .toList();
  }

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAddress &&
          id == other.id &&
          regionId == other.regionId &&
          title == other.title &&
          name == other.name &&
          phone == other.phone &&
          address == other.address &&
          addressAdditional == other.addressAdditional;
}

class FavoriteAddressWithPosition extends FavoriteAddress {
  FavoriteAddressWithPosition({
    required this.lat,
    required this.long,
    required FavoriteAddress favoriteAddress,
  }) : super(
          id: favoriteAddress.id,
          regionId: favoriteAddress.regionId,
          title: favoriteAddress.title,
          name: favoriteAddress.name,
          phone: favoriteAddress.phone,
          address: favoriteAddress.address,
          addressAdditional: favoriteAddress.addressAdditional,
        );
  final double lat;
  final double long;

  factory FavoriteAddressWithPosition.fromFavoriteAddress(
    FavoriteAddress favoriteAddress,
    Point point,
  ) {
    return FavoriteAddressWithPosition(
      lat: point.latitude,
      long: point.longitude,
      favoriteAddress: favoriteAddress,
    );
  }

  @override
  operator ==(Object other) {
    if (other is FavoriteAddress) {
      return regionId == other.regionId &&
          title == other.title &&
          name == other.name &&
          phone == other.phone &&
          address == other.address &&
          addressAdditional == other.addressAdditional;
    }

    return identical(this, other) ||
        other is FavoriteAddressWithPosition &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            regionId == other.regionId &&
            title == other.title &&
            name == other.name &&
            phone == other.phone &&
            address == other.address &&
            addressAdditional == other.addressAdditional &&
            lat == other.lat &&
            long == other.long;
  }
}
