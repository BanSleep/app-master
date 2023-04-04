import 'package:collection/collection.dart';
import 'package:cvetovik/core/services/providers/delivery_info_provider.dart';
import 'package:cvetovik/core/services/providers/region_info_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/widgets/region/region_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'provider/current_region_provider.dart';

class RegionSheet extends ConsumerStatefulWidget {
  const RegionSheet({
    Key? key,
    required this.items,
    this.isWhiteFont = false,
  }) : super(key: key);

  final List<Region> items;
  final bool isWhiteFont;

  @override
  ConsumerState createState() => _RegionSheetState();
}

class _RegionSheetState extends ConsumerState<RegionSheet> {
  late Region selectedRegion;
  bool isOpen = false;

  @override
  void initState() {
    var currentRegion = ref.read(currentRegionProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      currentRegion.init();
      if (currentRegion.currState == 0) {
        selectedRegion = widget.items.first;
        currentRegion.saveRegion(selectedRegion.id, selectedRegion.title);
      } else {
        initSelectedRegion(currentRegion.currState);
      }
    });
    super.initState();
  }

  void initSelectedRegion(int state) {
    var curr = widget.items.firstWhere(
      (el) => el.id == state,
      orElse: () => widget.items.first,
    );
    selectedRegion = curr;
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(currentRegionProvider);
    initSelectedRegion(state);
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpen = true;
        });
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return RegionPopup(
              items: widget.items,
              onSelected: _onSelected,
              selected: selectedRegion.title,
            );
          },
        ).then((value) {
          closed();
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Text(
                selectedRegion.title,
                textAlign: TextAlign.start,
                style:
                    AppTextStyles.textMediumBold.copyWith(color: _getColor()),
              ),
              SizedBox(
                width: 5.w,
              ),
              Icon(
                _getIcon(),
                color: _getColor(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColor() => (widget.isWhiteFont
      ? AppAllColors.commonColorsWhite
      : AppAllColors.lightAccent);

  IconData? _getIcon() {
    if (!isOpen) {
      return Icons.keyboard_arrow_down;
    } else {
      return Icons.keyboard_arrow_up;
    }
  }

  Future<void> _onSelected(String title) async {
    var item =
        widget.items.firstWhereOrNull((element) => element.title == title);
    if (item != null && item.title != selectedRegion.title) {
      setState(() {
        selectedRegion = item;
      });
      ref.read(deliveryInfoProvider.notifier).init();
      ref.read(repositoryInfoProvider).init();

      await ref
          .read(currentRegionProvider.notifier)
          .saveRegion(selectedRegion.id, selectedRegion.title);
    }
  }

  void closed() {
    isOpen = false;
  }
}
