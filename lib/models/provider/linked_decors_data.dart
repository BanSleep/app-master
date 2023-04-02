import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';

class LinkedDecorsData {
  final String regionId;
  final int catalogId;
  final Map<String, LinkedDecor> decors;

  LinkedDecorsData(
      {required this.regionId, required this.catalogId, required this.decors});
}
