import 'package:cvetovik/pages/ordering/models/map_position.dart';

mixin AddressMixin {
  MapPosition? _getPosition(List<String> positions, bool invert) {
    var lat = double.tryParse(positions[0].trim());
    var long = double.tryParse(positions[1].trim());
    if (lat != null && long != null) {
      if (invert)
        return MapPosition(latitude: long, longitude: lat);
      else
        return MapPosition(latitude: lat, longitude: long);
    }
    return null;
  }

  MapPosition? getPositionFromStr(
      {required String value, bool invert = false}) {
    List<String> positions = value.split(',');
    if (positions.isNotEmpty && positions.length == 2) {
      return _getPosition(positions, invert);
    } else {
      positions = value.split(' ');
      if (positions.isNotEmpty && positions.length == 2) {
        return _getPosition(positions, invert);
      }
    }
    return null;
  }
}
