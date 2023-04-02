import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'address_item_widget.dart';

class AddressListWidget extends ConsumerStatefulWidget {
  const AddressListWidget(
      {Key? key,
      required this.items,
      this.disabledScroll = false,
      this.onUpdatedPos,
      this.refresh = false})
      : super(key: key);
  final Function(MapPosition pos)? onUpdatedPos;
  final List<AddressData> items;
  final bool disabledScroll;
  final bool refresh;
  @override
  _AddressListWidgetState createState() => _AddressListWidgetState();
}

class _AddressListWidgetState extends ConsumerState<AddressListWidget>
    with GetAddressMixin {
  late int selectedIndex;

  @override
  initState() {
    selectedIndex = 0;
    super.initState();
  }

  AddressFullData? value() {
    if (widget.items.length == 0) return null;
    var curr = widget.items[selectedIndex];
    return AddressFullData(
      MapPosition(latitude: curr.lat, longitude: curr.long),
      curr.address,
      "под ${curr.entrance} кв ${curr.apartment} эт ${curr.intercom}",
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePos());
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: _itemBuilder,
      shrinkWrap: true,
      physics: _getScroll(),
    );
  }

  ScrollPhysics? _getScroll() {
    if (widget.disabledScroll) return NeverScrollableScrollPhysics();
    return null;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var curr = widget.items[index];
    return AddressItemWidget(
      selected: selectedIndex == index,
      data: curr,
      onTab: () async {
        if (widget.refresh) {
          var dao = ref.read(addressDaoProvider);
          await dao.updateUsed(a: curr);
          //ref.refresh(addressLastProvider);
        }
        setState(() {
          selectedIndex = index;
          _updatePos();
        });
      },
    );
  }

  void _updatePos() {
    if (widget.onUpdatedPos != null && widget.items.isNotEmpty) {
      MapPosition pos = _getCurrPos();
      widget.onUpdatedPos!(pos);
    }
  }

  MapPosition _getCurrPos() {
    var curr = widget.items[selectedIndex];
    var pos = MapPosition(latitude: curr.lat, longitude: curr.long);
    return pos;
  }
}
