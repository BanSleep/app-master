import 'package:cvetovik/widgets/navigation_history_observer.dart';
import 'package:flutter/material.dart';

class NavData {
  final GlobalKey<NavigatorState> navKey;
  final NavigationHistoryObserver _observer = NavigationHistoryObserver();
  NavigationHistoryObserver get observer => _observer;
  NavData({required this.navKey});
}
