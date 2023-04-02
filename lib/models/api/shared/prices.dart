class Prices {
  Prices({
    required this.min,
    required this.max,
  });

  int min;
  int max;

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        min: json["min"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
      };
}
