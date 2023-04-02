class DadataRequest {
  final String query;
  final String lang;
  final String count;
  List<DadataLocation>? locations;

  DadataRequest(
      {required this.query,
      this.lang = 'ru',
      this.count = '15',
      this.locations});

  Map<String, dynamic> toJson() => {
        "query": query,
        "lang": lang,
        "count": count,
        "locations": (locations != null)
            ? List<dynamic>.from(locations!.map((x) => x.toJson()))
            : null,
      };
}

class DadataLocation {
  DadataLocation({
    required this.kladrId,
  });

  final String kladrId;

  factory DadataLocation.fromJson(Map<String, dynamic> json) => DadataLocation(
        kladrId: json["kladr_id"],
      );

  Map<String, dynamic> toJson() => {
        "kladr_id": kladrId,
      };
}
