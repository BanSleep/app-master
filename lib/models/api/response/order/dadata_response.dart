// To parse this JSON data, do
//
//     final dadataResponse = dadataResponseFromJson(jsonString);

import 'dart:convert';

DadataResponse dadataResponseFromJson(String str) =>
    DadataResponse.fromJson(json.decode(str));

String dadataResponseToJson(DadataResponse data) => json.encode(data.toJson());

class DadataResponse {
  DadataResponse({
    required this.suggestions,
  });

  List<Suggestion> suggestions;

  factory DadataResponse.fromJson(Map<String, dynamic> json) => DadataResponse(
        suggestions: List<Suggestion>.from(
            json["suggestions"].map((x) => Suggestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "suggestions": List<dynamic>.from(suggestions.map((x) => x.toJson())),
      };
}

class Suggestion {
  Suggestion({
    required this.value,
    required this.unrestrictedValue,
    required this.data,
  });

  String value;
  String unrestrictedValue;
  SuggestionData data;

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        value: json["value"],
        unrestrictedValue: json["unrestricted_value"],
        data: SuggestionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unrestricted_value": unrestrictedValue,
        "data": data.toJson(),
      };
}

class SuggestionData {
  SuggestionData({
    this.postalCode,
    this.country,
    this.countryIsoCode,
    this.federalDistrict,
    this.regionFiasId,
    this.regionKladrId,
    this.regionIsoCode,
    this.regionWithType,
    this.regionType,
    this.regionTypeFull,
    this.region,
    this.areaFiasId,
    this.areaKladrId,
    this.areaWithType,
    this.areaType,
    this.areaTypeFull,
    this.area,
    this.cityFiasId,
    this.cityKladrId,
    this.cityWithType,
    this.cityType,
    this.cityTypeFull,
    this.city,
    /*this.cityArea,
    this.cityDistrictFiasId,
    this.cityDistrictKladrId,
    this.cityDistrictWithType,
    this.cityDistrictType,
    this.cityDistrictTypeFull,
    this.cityDistrict,*/
    this.settlementFiasId,
    this.settlementKladrId,
    this.settlementWithType,
    this.settlementType,
    this.settlementTypeFull,
    this.settlement,
    this.streetFiasId,
    this.streetKladrId,
    this.streetWithType,
    this.streetType,
    this.streetTypeFull,
    this.street,
    this.historyValues,
    required this.geoLat,
    required this.geoLon,
    /*this.houseFiasId,
    this.houseKladrId,
    this.houseCadnum,
    this.houseType,
    this.houseTypeFull,
    this.house,
    this.blockType,
    this.blockTypeFull,
    this.block,
    this.entrance,
    this.floor,
    this.flatFiasId,
    this.flatCadnum,
    this.flatType,
    this.flatTypeFull,
    this.flat,
    this.flatArea,
    this.squareMeterPrice,
    this.flatPrice,
    this.postalBox,
    this.fiasId,
    this.fiasCode,
    this.fiasLevel,
    this.fiasActualityState,
    this.kladrId,
    this.geonameId,
    this.capitalMarker,
    this.okato,
    this.oktmo,
    this.taxOffice,
    this.taxOfficeLegal,
    this.timezone,
    this.beltwayHit,
    this.beltwayDistance,
    this.metro,
    this.qcGeo,
    this.qcComplete,
    this.qcHouse,
    this.unparsedParts,
    this.source,
    this.qc*/
  });

  String? postalCode;
  String? country;
  String? countryIsoCode;
  dynamic federalDistrict;
  String? regionFiasId;
  String? regionKladrId;
  String? regionIsoCode;
  String? regionWithType;
  String? regionType;
  String? regionTypeFull;
  String? region;
  String? areaFiasId;
  String? areaKladrId;
  String? areaWithType;
  String? areaType;
  String? areaTypeFull;
  String? area;
  String? cityFiasId;
  String? cityKladrId;
  String? cityWithType;
  String? cityType;
  String? cityTypeFull;
  String? city;
  /*dynamic cityArea;
  dynamic cityDistrictFiasId;
  dynamic cityDistrictKladrId;
  dynamic cityDistrictWithType;
  dynamic cityDistrictType;
  dynamic cityDistrictTypeFull;
  dynamic cityDistrict;*/
  String? settlementFiasId;
  String? settlementKladrId;
  String? settlementWithType;
  String? settlementType;
  String? settlementTypeFull;
  String? settlement;
  String? streetFiasId;
  String? streetKladrId;
  String? streetWithType;
  String? streetType;
  String? streetTypeFull;
  String? street;
  /*dynamic houseFiasId;
  dynamic houseKladrId;
  dynamic houseCadnum;
  dynamic houseType;
  dynamic houseTypeFull;
  dynamic house;
  dynamic blockType;
  dynamic blockTypeFull;
  dynamic block;
  dynamic entrance;
  dynamic floor;
  dynamic flatFiasId;
  dynamic flatCadnum;
  dynamic flatType;
  dynamic flatTypeFull;
  dynamic flat;
  dynamic flatArea;
  dynamic squareMeterPrice;
  dynamic flatPrice;
  dynamic postalBox;*/
  String? fiasId;
  String? fiasCode;
  String? fiasLevel;
  String? fiasActualityState;
  String? kladrId;
  String? geonameId;
  String? capitalMarker;
  String? okato;
  String? oktmo;
  String? taxOffice;
  String? taxOfficeLegal;
  String? geoLat;
  String? geoLon;
  String? qcGeo;
  List<String>? historyValues;

  /*dynamic timezone;
  dynamic beltwayHit;
  dynamic beltwayDistance;
  dynamic metro;
  dynamic qcComplete;
  dynamic qcHouse;
  dynamic unparsedParts;
  dynamic source;
  dynamic qc;*/

  factory SuggestionData.fromJson(Map<String, dynamic> json) => SuggestionData(
        postalCode: json["postal_code"] == null ? null : json["postal_code"],
        country: json["country"],
        countryIsoCode: json["country_iso_code"],
        federalDistrict: json["federal_district"],
        regionFiasId: json["region_fias_id"],
        regionKladrId: json["region_kladr_id"],
        regionIsoCode: json["region_iso_code"],
        regionWithType: json["region_with_type"],
        regionType: json["region_type"],
        regionTypeFull: json["region_type_full"],
        region: json["region"],
        areaFiasId: json["area_fias_id"] == null ? null : json["area_fias_id"],
        areaKladrId:
            json["area_kladr_id"] == null ? null : json["area_kladr_id"],
        areaWithType:
            json["area_with_type"] == null ? null : json["area_with_type"],
        areaType: json["area_type"] == null ? null : json["area_type"],
        areaTypeFull:
            json["area_type_full"] == null ? null : json["area_type_full"],
        area: json["area"] == null ? null : json["area"],
        cityFiasId: json["city_fias_id"] == null ? null : json["city_fias_id"],
        cityKladrId:
            json["city_kladr_id"] == null ? null : json["city_kladr_id"],
        cityWithType:
            json["city_with_type"] == null ? null : json["city_with_type"],
        cityType: json["city_type"] == null ? null : json["city_type"],
        cityTypeFull:
            json["city_type_full"] == null ? null : json["city_type_full"],
        city: json["city"] == null ? null : json["city"],
        /*cityArea: json["city_area"],
    cityDistrictFiasId: json["city_district_fias_id"],
    cityDistrictKladrId: json["city_district_kladr_id"],
    cityDistrictWithType: json["city_district_with_type"],
    cityDistrictType: json["city_district_type"],
    cityDistrictTypeFull: json["city_district_type_full"],
    cityDistrict: json["city_district"],*/
        settlementFiasId: json["settlement_fias_id"] == null
            ? null
            : json["settlement_fias_id"],
        settlementKladrId: json["settlement_kladr_id"] == null
            ? null
            : json["settlement_kladr_id"],
        settlementWithType: json["settlement_with_type"] == null
            ? null
            : json["settlement_with_type"],
        settlementType:
            json["settlement_type"] == null ? null : json["settlement_type"],
        settlementTypeFull: json["settlement_type_full"] == null
            ? null
            : json["settlement_type_full"],
        settlement: json["settlement"] == null ? null : json["settlement"],
        streetFiasId:
            json["street_fias_id"] == null ? null : json["street_fias_id"],
        streetKladrId:
            json["street_kladr_id"] == null ? null : json["street_kladr_id"],
        streetWithType:
            json["street_with_type"] == null ? null : json["street_with_type"],
        streetType: json["street_type"] == null ? null : json["street_type"],
        streetTypeFull:
            json["street_type_full"] == null ? null : json["street_type_full"],
        street: json["street"] == null ? null : json["street"],
        geoLat: json["geo_lat"] == null ? null : json["geo_lat"],
        geoLon: json["geo_lon"] == null ? null : json["geo_lon"],
        /*houseFiasId: json["house_fias_id"],
    houseKladrId: json["house_kladr_id"],
    houseCadnum: json["house_cadnum"],
    houseType: json["house_type"],
    houseTypeFull: json["house_type_full"],
    house: json["house"],
    blockType: json["block_type"],
    blockTypeFull: json["block_type_full"],
    block: json["block"],
    entrance: json["entrance"],
    floor: json["floor"],
    flatFiasId: json["flat_fias_id"],
    flatCadnum: json["flat_cadnum"],
    flatType: json["flat_type"],
    flatTypeFull: json["flat_type_full"],
    flat: json["flat"],
    flatArea: json["flat_area"],
    squareMeterPrice: json["square_meter_price"],
    flatPrice: json["flat_price"],
    postalBox: json["postal_box"],
    fiasId: json["fias_id"],
    fiasCode: json["fias_code"],
    fiasLevel: json["fias_level"],
    fiasActualityState: json["fias_actuality_state"],
    kladrId: json["kladr_id"],
    geonameId: json["geoname_id"] == null ? null : json["geoname_id"],
    capitalMarker: json["capital_marker"],
    okato: json["okato"],
    oktmo: json["oktmo"],
    taxOffice: json["tax_office"],
    taxOfficeLegal: json["tax_office_legal"],
    timezone: json["timezone"],
    beltwayHit: json["beltway_hit"],
    beltwayDistance: json["beltway_distance"],
    metro: json["metro"],
    qcGeo: json["qc_geo"] == null ? null : json["qc_geo"],
    qcComplete: json["qc_complete"],
    qcHouse: json["qc_house"],
    historyValues: json["history_values"] == null ? null : List<String>.from(json["history_values"].map((x) => x)),
    unparsedParts: json["unparsed_parts"],
    source: json["source"],
    qc: json["qc"],*/
      );

  Map<String, dynamic> toJson() => {
        "postal_code": postalCode == null ? null : postalCode,
        "country": country,
        "country_iso_code": countryIsoCode,
        "federal_district": federalDistrict,
        "region_fias_id": regionFiasId,
        "region_kladr_id": regionKladrId,
        "region_iso_code": regionIsoCode,
        "region_with_type": regionWithType,
        "region_type": regionType,
        "region_type_full": regionTypeFull,
        "region": region,
        "area_fias_id": areaFiasId == null ? null : areaFiasId,
        "area_kladr_id": areaKladrId == null ? null : areaKladrId,
        "area_with_type": areaWithType == null ? null : areaWithType,
        "area_type": areaType == null ? null : areaType,
        "area_type_full": areaTypeFull == null ? null : areaTypeFull,
        "area": area == null ? null : area,
        "city_fias_id": cityFiasId == null ? null : cityFiasId,
        "city_kladr_id": cityKladrId == null ? null : cityKladrId,
        "city_with_type": cityWithType == null ? null : cityWithType,
        "city_type": cityType == null ? null : cityType,
        "city_type_full": cityTypeFull == null ? null : cityTypeFull,
        "city": city == null ? null : city,
        /*"city_area": cityArea,
    "city_district_fias_id": cityDistrictFiasId,
    "city_district_kladr_id": cityDistrictKladrId,
    "city_district_with_type": cityDistrictWithType,
    "city_district_type": cityDistrictType,
    "city_district_type_full": cityDistrictTypeFull,
    "city_district": cityDistrict,*/
        "settlement_fias_id":
            settlementFiasId == null ? null : settlementFiasId,
        "settlement_kladr_id":
            settlementKladrId == null ? null : settlementKladrId,
        "settlement_with_type":
            settlementWithType == null ? null : settlementWithType,
        "settlement_type": settlementType == null ? null : settlementType,
        "settlement_type_full":
            settlementTypeFull == null ? null : settlementTypeFull,
        "settlement": settlement == null ? null : settlement,
        "street_fias_id": streetFiasId == null ? null : streetFiasId,
        "street_kladr_id": streetKladrId == null ? null : streetKladrId,
        "street_with_type": streetWithType == null ? null : streetWithType,
        "street_type": streetType == null ? null : streetType,
        "street_type_full": streetTypeFull == null ? null : streetTypeFull,
        "street": street == null ? null : street,
        /*"house_fias_id": houseFiasId,
    "house_kladr_id": houseKladrId,
    "house_cadnum": houseCadnum,
    "house_type": houseType,
    "house_type_full": houseTypeFull,
    "house": house,
    "block_type": blockType,
    "block_type_full": blockTypeFull,
    "block": block,
    "entrance": entrance,
    "floor": floor,
    "flat_fias_id": flatFiasId,
    "flat_cadnum": flatCadnum,
    "flat_type": flatType,
    "flat_type_full": flatTypeFull,
    "flat": flat,
    "flat_area": flatArea,
    "square_meter_price": squareMeterPrice,
    "flat_price": flatPrice,
    "postal_box": postalBox,*/
        "fias_id": fiasId,
        "fias_code": fiasCode,
        "fias_level": fiasLevel,
        "fias_actuality_state": fiasActualityState,
        "kladr_id": kladrId,
        "geoname_id": geonameId == null ? null : geonameId,
        "capital_marker": capitalMarker,
        "okato": okato,
        "oktmo": oktmo,
        "tax_office": taxOffice,
        "tax_office_legal": taxOfficeLegal,
        "geo_lat": geoLat,
        "geo_lon": geoLon,
        "qc_geo": qcGeo == null ? null : qcGeo,
        "history_values": historyValues == null
            ? null
            : List<dynamic>.from(historyValues!.map((x) => x)),
        /*"timezone": timezone,
    "beltway_hit": beltwayHit,
    "beltway_distance": beltwayDistance,
    "metro": metro,
    "qc_complete": qcComplete,
    "qc_house": qcHouse,
    "unparsed_parts": unparsedParts,
    "source": source,
    "qc": qc,*/
      };
}
