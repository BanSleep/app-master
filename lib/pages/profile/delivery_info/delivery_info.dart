import 'dart:developer';

import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';

class DeliveryInfoParse {

  List<String> parseZonesDeliveryInformation(List<TimeRangeData> timeRanges) {
    List<String> resultStrings = [];

    /// Создаем Map для хранения уникальных значений price
    final List<Map<String, List<int>>> priceMap = [];

    /// Заполняем Map
    int oldPrice = timeRanges.first.price;
    int kmOldPrice = timeRanges.first.kmPrice;
    int startHour = timeRanges.first.startHour;
    int stopHour = timeRanges.first.stopHour;
    List<int> freeFromIndex = [];

    for (int i = 0; i < timeRanges.length; i++) {
      final price = timeRanges[i].price;
      final kmPrice = timeRanges[i].kmPrice;
      if (price != oldPrice || kmPrice != kmOldPrice) {
        stopHour = timeRanges[i - 1].stopHour;
        priceMap.add({
          '$oldPriceруб.${kmOldPrice > 0 ? ' + $kmOldPriceруб. за каждый километр от зоны доставки №1' : ''}': [startHour, stopHour]
        });
        freeFromIndex.add(timeRanges[i - 1].freeFrom);
        startHour = timeRanges[i].startHour;
      }
      if (i == timeRanges.length - 1) {
        priceMap.add({
          '$priceруб.${kmPrice > 0 ? ' + ${kmPrice}руб. за каждый километр от зоны доставки №1' : ''}': [startHour, timeRanges[i].stopHour]
        });
        freeFromIndex.add(timeRanges[i].freeFrom);
      }
      oldPrice = price;
      kmOldPrice = kmPrice;
    }

    if (priceMap.first.keys.first == priceMap.last.keys.first && priceMap.length > 2){
      //priceMap.first[priceMap.first.keys.first]
      priceMap.first[priceMap.first.keys.first]!.first = priceMap.last[priceMap.first.keys.first]!.first;
      priceMap.removeLast();
    }

    log(priceMap.toString());

    for (int i = 0; i < priceMap.length; i++) {
      final key = priceMap[i].keys.toList().first;
      String startHour = '';
      String stopHour = '';
      String price = '';

      ///Парсинг startHour в строку
      if (priceMap[i][key]!.first.toString().length == 1) {
        startHour = '0${priceMap[i][key]!.first.toString()}:00';
      } else {
        startHour = '${priceMap[i][key]!.first.toString()}:00';
      }

      ///Парсинг stopHour в строку
      if (priceMap[i][key]!.last.toString().length == 1) {
        stopHour = '0${priceMap[i][key]!.last.toString()}:00';
      } else {
        stopHour = '${priceMap[i][key]!.last.toString()}:00';
      }

      ///парсинг времени суток
      List<String> timesOfDay = [];
      timesOfDay.add(getTimeOfDay(priceMap[i][key]!.first));
      timesOfDay.add(getTimeOfDay(priceMap[i][key]!.last));
      if (timesOfDay[0] == 'ночное' && timesOfDay[1] == 'вечернее') {
        timesOfDay.last = 'утреннее';
        timesOfDay.add('дневное');
        timesOfDay.add('вечернее');
      }
      if (timesOfDay[0] == 'ночное' && timesOfDay[1] == 'дневное') {
        timesOfDay.last = 'утреннее';
        timesOfDay.add('дневное');
      }
      if (timesOfDay[0] == 'утреннее' && timesOfDay[1] == 'вечернее') {
        timesOfDay.last = 'дневное';
        timesOfDay.add('вечернее');
      }
      if (timesOfDay[0] == 'вечернее' && timesOfDay[1] == 'утреннее') {
        timesOfDay.last = 'ночное';
        timesOfDay.add('утреннее');
      }
      if (timesOfDay[0] == timesOfDay[1]) {
        timesOfDay.removeLast();
      }
      if (priceMap[i][key]!.last == priceMap[i][key]!.first){
        timesOfDay = ['любое'];
      }
      if (timesOfDay.last == 'ночное' && priceMap[i][key]!.last == 0){
        timesOfDay.removeLast();
      }

      ///Парсинг price в строку
      price = priceMap[i]
          .keys
          .toString()
          .substring(1, priceMap[i].keys.toString().length - 1);

      ///Парсинг итоговой строки
      String str = 'В ';
      for (int idx = 0; idx < timesOfDay.length; idx++) {
        if (idx == timesOfDay.length - 1) {
          str += timesOfDay[idx];
        } else {
          str += timesOfDay[idx] + ', ';
        }
      }
      if (startHour == stopHour){
        str = str + ' время суток - $price';
      }
      else{
        str = str + ' время суток с $startHour до $stopHour - $price';
      }

      ///добавление к итоговой строке бесплатную доставку
      if (freeFromIndex[i] > 0) {
        str += ', а при заказе от ${freeFromIndex[i]}руб. - бесплатно';
      }

      resultStrings.add(str);
    }

    return resultStrings;
  }

  String getTimeOfDay(int hour) {
    if (hour >= 6 && hour < 12) {
      return 'утреннее';
    } else if (hour >= 12 && hour < 18) {
      return 'дневное';
    } else if (hour >= 18 && hour < 24) {
      return 'вечернее';
    } else if (hour >= 0 && hour < 6) {
      return 'ночное';
    } else{
      log(hour.toString());
      return '';
    }
  }
}
