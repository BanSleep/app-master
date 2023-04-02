import 'dart:io';

import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/pages/ordering/models/payment_method_data.dart';

mixin PaymentMixinData {
  PaymentMethodData platformPayment() {
    if (Platform.isIOS) {
      return PaymentMethodData(
          method: PaymentMethod.applePay, title: AppRes.applePay, value: '');
    } else {
      return PaymentMethodData(
          method: PaymentMethod.googlePay, title: AppRes.googlePay, value: '');
    }
  }
}
