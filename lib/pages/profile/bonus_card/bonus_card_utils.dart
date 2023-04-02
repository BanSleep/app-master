import 'package:quiver/iterables.dart';

String formattedNumberCard(String numberCard) {
  var raw = numberCard.split('').toList();
  var items = partition(raw, 4).toList();
  String result = '';
  items.forEach((el) {
    String separator = '';
    String item = '';
    el.forEach((i) {
      item = item + i;
    });
    if (result.isNotEmpty) {
      separator = ' ';
    }

    result = result + separator + item.toString();
  });
  return result;
}
