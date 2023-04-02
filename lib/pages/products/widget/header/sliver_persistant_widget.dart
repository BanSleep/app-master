import 'package:flutter/cupertino.dart';

class SliverPersitantWidget extends SliverPersistentHeaderDelegate {
  final Widget child;

  const SliverPersitantWidget({required this.child, Key? key});

  @override
  // TODO: implement maxExtent
  double get maxExtent => 150;

  @override
  // TODO: implement minExtent
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
  return false;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }
}
