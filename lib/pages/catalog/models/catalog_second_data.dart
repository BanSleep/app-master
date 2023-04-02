class CatalogSecondData {
  final String title;
  final String? count;
  final int id;
  final bool isFirst;
  final String? image;
  CatalogSecondData(
      {required this.title,
      required this.id,
      this.count,
      this.image,
      this.isFirst = false});
}
