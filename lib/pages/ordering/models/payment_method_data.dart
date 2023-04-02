enum PaymentMethod { applePay, card, cash, youMoney, payPal, googlePay }

class PaymentMethodData {
  final PaymentMethod method;
  final String title;
  final String value;

  PaymentMethodData({required this.method, required this.title,required this.value});
}
