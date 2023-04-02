// To parse this JSON data, do
//
//     final geocoderResponse = geocoderResponseFromJson(jsonString);

import 'dart:convert';

GeocoderResponse geocoderResponseFromJson(String str) =>
    GeocoderResponse.fromJson(json.decode(str));

String geocoderResponseToJson(GeocoderResponse data) =>
    json.encode(data.toJson());

class GeocoderResponse {
  GeocoderResponse({
    required this.response,
  });

  GeocoderData response;

  factory GeocoderResponse.fromJson(Map<String, dynamic> json) =>
      GeocoderResponse(
        response: GeocoderData.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
      };
}

class GeocoderData {
  GeocoderData({
    required this.geoObjectCollection,
  });

  GeoObjectCollection geoObjectCollection;

  factory GeocoderData.fromJson(Map<String, dynamic> json) => GeocoderData(
        geoObjectCollection:
            GeoObjectCollection.fromJson(json["GeoObjectCollection"]),
      );

  Map<String, dynamic> toJson() => {
        "GeoObjectCollection": geoObjectCollection.toJson(),
      };
}

class GeoObjectCollection {
  GeoObjectCollection({
    required this.metaDataProperty,
    required this.featureMember,
  });

  GeoObjectCollectionMetaDataProperty metaDataProperty;
  List<FeatureMember> featureMember;

  factory GeoObjectCollection.fromJson(Map<String, dynamic> json) =>
      GeoObjectCollection(
        metaDataProperty: GeoObjectCollectionMetaDataProperty.fromJson(
            json["metaDataProperty"]),
        featureMember: List<FeatureMember>.from(
            json["featureMember"].map((x) => FeatureMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "metaDataProperty": metaDataProperty.toJson(),
        "featureMember":
            List<dynamic>.from(featureMember.map((x) => x.toJson())),
      };
}

class FeatureMember {
  FeatureMember({
    required this.geoObject,
  });

  GeoObject geoObject;

  factory FeatureMember.fromJson(Map<String, dynamic> json) => FeatureMember(
        geoObject: GeoObject.fromJson(json["GeoObject"]),
      );

  Map<String, dynamic> toJson() => {
        "GeoObject": geoObject.toJson(),
      };
}

class GeoObject {
  GeoObject({
    /*required this.metaDataProperty,

    required this.description,
    required this.boundedBy,*/
    required this.name,
    required this.point,
  });

  //GeoObjectMetaDataProperty metaDataProperty;
  String name;
  //String description;
  //BoundedBy boundedBy;
  GeocoderPoint point;

  factory GeoObject.fromJson(Map<String, dynamic> json) => GeoObject(
        /*metaDataProperty: GeoObjectMetaDataProperty.fromJson(json["metaDataProperty"]),
    description: json["description"],
    boundedBy: BoundedBy.fromJson(json["boundedBy"]),*/
        name: json["name"],
        point: GeocoderPoint.fromJson(json["Point"]),
      );

  Map<String, dynamic> toJson() => {
        /*"metaDataProperty": metaDataProperty.toJson(),
    "name": name,
    "description": description,
    "boundedBy": boundedBy.toJson(),*/
        "Point": point.toJson(),
      };
}

class BoundedBy {
  BoundedBy({
    required this.envelope,
  });

  GeocoderEnvelope envelope;

  factory BoundedBy.fromJson(Map<String, dynamic> json) => BoundedBy(
        envelope: GeocoderEnvelope.fromJson(json["Envelope"]),
      );

  Map<String, dynamic> toJson() => {
        "Envelope": envelope.toJson(),
      };
}

class GeocoderEnvelope {
  GeocoderEnvelope({
    required this.lowerCorner,
    required this.upperCorner,
  });

  String lowerCorner;
  String upperCorner;

  factory GeocoderEnvelope.fromJson(Map<String, dynamic> json) =>
      GeocoderEnvelope(
        lowerCorner: json["lowerCorner"],
        upperCorner: json["upperCorner"],
      );

  Map<String, dynamic> toJson() => {
        "lowerCorner": lowerCorner,
        "upperCorner": upperCorner,
      };
}

class GeoObjectMetaDataProperty {
  GeoObjectMetaDataProperty({
    required this.geocoderMetaData,
  });

  GeocoderMetaData geocoderMetaData;

  factory GeoObjectMetaDataProperty.fromJson(Map<String, dynamic> json) =>
      GeoObjectMetaDataProperty(
        geocoderMetaData: GeocoderMetaData.fromJson(json["GeocoderMetaData"]),
      );

  Map<String, dynamic> toJson() => {
        "GeocoderMetaData": geocoderMetaData.toJson(),
      };
}

class GeocoderMetaData {
  GeocoderMetaData({
    required this.precision,
    required this.text,
    required this.kind,
    required this.address,
    required this.addressDetails,
  });

  String precision;
  String text;
  String kind;
  GeocoderAddress address;
  GeocoderAddressDetails addressDetails;

  factory GeocoderMetaData.fromJson(Map<String, dynamic> json) =>
      GeocoderMetaData(
        precision: json["precision"],
        text: json["text"],
        kind: json["kind"],
        address: GeocoderAddress.fromJson(json["Address"]),
        addressDetails: GeocoderAddressDetails.fromJson(json["AddressDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "precision": precision,
        "text": text,
        "kind": kind,
        "Address": address.toJson(),
        "AddressDetails": addressDetails.toJson(),
      };
}

class GeocoderAddress {
  GeocoderAddress({
    required this.countryCode,
    required this.formatted,
    required this.postalCode,
    required this.components,
  });

  String? countryCode;
  String? formatted;
  String? postalCode;
  List<GeocoderComponent> components;

  factory GeocoderAddress.fromJson(Map<String, dynamic> json) =>
      GeocoderAddress(
        countryCode: json["country_code"],
        formatted: json["formatted"],
        postalCode: json["postal_code"],
        components: List<GeocoderComponent>.from(
            json["Components"].map((x) => GeocoderComponent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "formatted": formatted,
        "postal_code": postalCode,
        "Components": List<dynamic>.from(components.map((x) => x.toJson())),
      };
}

class GeocoderComponent {
  GeocoderComponent({
    required this.kind,
    required this.name,
  });

  String kind;
  String name;

  factory GeocoderComponent.fromJson(Map<String, dynamic> json) =>
      GeocoderComponent(
        kind: json["kind"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "name": name,
      };
}

class GeocoderAddressDetails {
  GeocoderAddressDetails({
    required this.country,
  });

  GeocoderCountry country;

  factory GeocoderAddressDetails.fromJson(Map<String, dynamic> json) =>
      GeocoderAddressDetails(
        country: GeocoderCountry.fromJson(json["Country"]),
      );

  Map<String, dynamic> toJson() => {
        "Country": country.toJson(),
      };
}

class GeocoderCountry {
  GeocoderCountry({
    required this.addressLine,
    required this.countryNameCode,
    required this.countryName,
    required this.administrativeArea,
  });

  String addressLine;
  String countryNameCode;
  String countryName;
  GeocoderAdministrativeArea administrativeArea;

  factory GeocoderCountry.fromJson(Map<String, dynamic> json) =>
      GeocoderCountry(
        addressLine: json["AddressLine"],
        countryNameCode: json["CountryNameCode"],
        countryName: json["CountryName"],
        administrativeArea:
            GeocoderAdministrativeArea.fromJson(json["AdministrativeArea"]),
      );

  Map<String, dynamic> toJson() => {
        "AddressLine": addressLine,
        "CountryNameCode": countryNameCode,
        "CountryName": countryName,
        "AdministrativeArea": administrativeArea.toJson(),
      };
}

class GeocoderAdministrativeArea {
  GeocoderAdministrativeArea({
    required this.administrativeAreaName,
    required this.locality,
  });

  String administrativeAreaName;
  GeocoderLocality locality;

  factory GeocoderAdministrativeArea.fromJson(Map<String, dynamic> json) =>
      GeocoderAdministrativeArea(
        administrativeAreaName: json["AdministrativeAreaName"],
        locality: GeocoderLocality.fromJson(json["Locality"]),
      );

  Map<String, dynamic> toJson() => {
        "AdministrativeAreaName": administrativeAreaName,
        "Locality": locality.toJson(),
      };
}

class GeocoderLocality {
  GeocoderLocality({
    required this.localityName,
    required this.thoroughfare,
  });

  String localityName;
  Thoroughfare thoroughfare;

  factory GeocoderLocality.fromJson(Map<String, dynamic> json) =>
      GeocoderLocality(
        localityName: json["LocalityName"],
        thoroughfare: Thoroughfare.fromJson(json["Thoroughfare"]),
      );

  Map<String, dynamic> toJson() => {
        "LocalityName": localityName,
        "Thoroughfare": thoroughfare.toJson(),
      };
}

class Thoroughfare {
  Thoroughfare({
    required this.thoroughfareName,
    required this.premise,
  });

  String thoroughfareName;
  GeocoderPremise premise;

  factory Thoroughfare.fromJson(Map<String, dynamic> json) => Thoroughfare(
        thoroughfareName: json["ThoroughfareName"],
        premise: GeocoderPremise.fromJson(json["Premise"]),
      );

  Map<String, dynamic> toJson() => {
        "ThoroughfareName": thoroughfareName,
        "Premise": premise.toJson(),
      };
}

class GeocoderPremise {
  GeocoderPremise({
    required this.premiseNumber,
    required this.postalCode,
  });

  String premiseNumber;
  PostalCode postalCode;

  factory GeocoderPremise.fromJson(Map<String, dynamic> json) =>
      GeocoderPremise(
        premiseNumber: json["PremiseNumber"],
        postalCode: PostalCode.fromJson(json["PostalCode"]),
      );

  Map<String, dynamic> toJson() => {
        "PremiseNumber": premiseNumber,
        "PostalCode": postalCode.toJson(),
      };
}

class PostalCode {
  PostalCode({
    required this.postalCodeNumber,
  });

  String postalCodeNumber;

  factory PostalCode.fromJson(Map<String, dynamic> json) => PostalCode(
        postalCodeNumber: json["PostalCodeNumber"],
      );

  Map<String, dynamic> toJson() => {
        "PostalCodeNumber": postalCodeNumber,
      };
}

class GeocoderPoint {
  GeocoderPoint({
    required this.pos,
  });

  String pos;

  factory GeocoderPoint.fromJson(Map<String, dynamic> json) => GeocoderPoint(
        pos: json["pos"],
      );

  Map<String, dynamic> toJson() => {
        "pos": pos,
      };
}

class GeoObjectCollectionMetaDataProperty {
  GeoObjectCollectionMetaDataProperty({
    required this.geocoderResponseMetaData,
  });

  GeocoderResponseMetaData geocoderResponseMetaData;

  factory GeoObjectCollectionMetaDataProperty.fromJson(
          Map<String, dynamic> json) =>
      GeoObjectCollectionMetaDataProperty(
        geocoderResponseMetaData:
            GeocoderResponseMetaData.fromJson(json["GeocoderResponseMetaData"]),
      );

  Map<String, dynamic> toJson() => {
        "GeocoderResponseMetaData": geocoderResponseMetaData.toJson(),
      };
}

class GeocoderResponseMetaData {
  GeocoderResponseMetaData({
    required this.request,
    required this.results,
    required this.found,
  });

  String request;
  String results;
  String found;

  factory GeocoderResponseMetaData.fromJson(Map<String, dynamic> json) =>
      GeocoderResponseMetaData(
        request: json["request"],
        results: json["results"],
        found: json["found"],
      );

  Map<String, dynamic> toJson() => {
        "request": request,
        "results": results,
        "found": found,
      };
}
