class CartPriceData {
  final int summa;
  final int sumWithDiscount;
  final int promoCodeDiscount;
  final int deliveryPrice;
  CartPriceData(
      {required this.summa,
      required this.sumWithDiscount,
      required this.promoCodeDiscount,
      this.deliveryPrice = 0});

  int get total => sumWithDiscount - promoCodeDiscount + deliveryPrice;

  factory CartPriceData.init() {
    return CartPriceData(
        promoCodeDiscount: 0, summa: 0, sumWithDiscount: 0, deliveryPrice: 0);
  }

  CartPriceData copyWith(
      {int? summa,
      int? sumWithDiscount,
      int? promoCodeDiscount,
      int? deliveryPrice}) {
    return CartPriceData(
      summa: (summa != null) ? summa : this.summa,
      promoCodeDiscount: (promoCodeDiscount != null)
          ? promoCodeDiscount
          : this.promoCodeDiscount,
      deliveryPrice:
          (deliveryPrice != null) ? deliveryPrice : this.deliveryPrice,
      sumWithDiscount:
          (sumWithDiscount != null) ? sumWithDiscount : this.sumWithDiscount,
    );
  }
}
