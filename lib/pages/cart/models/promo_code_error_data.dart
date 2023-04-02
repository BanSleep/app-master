import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_res.dart';

enum _PromoCodeError {
  wasAlreadyUsed,
  outdated,
  notYetAvailable,
  notFound,
  notSet
}

class _PromoCodeErrorData {
  final _PromoCodeError error;
  final String value;
  final String locale;

  _PromoCodeErrorData(
      {required this.error, required this.value, required this.locale});
}

class PromoCodeErrorList {
  static final _errorList = [
    _PromoCodeErrorData(
        error: _PromoCodeError.notFound,
        value: 'promo code not found',
        locale: AppRes.promoCodeNotFound),
    _PromoCodeErrorData(
        error: _PromoCodeError.notSet,
        value: 'promo code not set',
        locale: AppRes.promoCodeNotSet),
    _PromoCodeErrorData(
        error: _PromoCodeError.notYetAvailable,
        value: 'promo code not yet available',
        locale: AppRes.promoCodeNotYet),
    _PromoCodeErrorData(
        error: _PromoCodeError.outdated,
        value: 'promo code outdated',
        locale: AppRes.promoCodeOutdated),
    _PromoCodeErrorData(
        error: _PromoCodeError.wasAlreadyUsed,
        value: 'promo code not yet available',
        locale: AppRes.promoCodeAlreadyUse),
  ];

  static String getLocaleByError(String value) {
    var curr = _errorList.firstWhereOrNull((element) => element.value == value);
    if (curr != null) {
      return curr.locale;
    } else {
      return value;
    }
  }
}
