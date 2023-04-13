import 'dart:async';

import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/const/app_typedef.dart';
import 'package:cvetovik/core/api/dadata_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/order/dadata_response.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddressSuggestionWidget extends ConsumerStatefulWidget {
  const AddressSuggestionWidget(
      {Key? key, this.address, this.onSelected, this.position})
      : super(key: key);
  final String? address;
  final MapPosition? position;
  final OnSelectedAddressAsync? onSelected;
  @override
  _AddressSuggestionWidgetState createState() =>
      _AddressSuggestionWidgetState();
}

class _AddressSuggestionWidgetState
    extends ConsumerState<AddressSuggestionWidget>
    with GetAddressMixin, SetAddressMixin {
  late TextEditingController _controller;
  final String hint = 'Санкт-Петербург, Дворцовая площадь';
  bool isError = false;
  final String errorText = AppRes.pleaseInputAddress;

  MapPosition? _position;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onListener);
    _position = widget.position;
    if (widget.address != null && widget.address!.isNotEmpty) {
      _controller.text = widget.address!;
    } else {
      var set = ref.read(settingsProvider);
      String regionTitle = set.getCurrentRegionTitle();
      _controller.text = regionTitle;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  AddressFullData? value() {
    var text = _controller.text;
    if (text.isEmpty || text.length < 5) {
      setState(() {
        isError = true;
      });
      return null;
    } else
      return AddressFullData(
          _position ?? MapPosition(latitude: 0, longitude: 0),
          _controller.text,
          "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppRes.address,
          textAlign: TextAlign.start,
          style: AppTextStyles.textField,
        ),
        SizedBox(
          height: 8.h,
        ),
        TypeAheadField(
          noItemsFoundBuilder: (context) =>
              ListTile(title: Text(AppRes.noItemsFound)),
          textFieldConfiguration: TextFieldConfiguration(
            minLines: 1,
            maxLines: 2,
            style: AppTextStyles.textField,
            decoration: InputDecoration(
              errorText: (isError) ? errorText : null,
              hintText: hint,
              hintStyle: AppTextStyles.textLarge.copyWith(fontSize: 12.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(10.w),
              fillColor: AppColors.fillColor,
            ),
            controller: _controller,
          ),
          debounceDuration: Duration(milliseconds: 600),
          suggestionsCallback: _startSuggesting,
          itemBuilder: (context, suggestion) {
            final s = suggestion as Suggestion;
            return Container(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(s.value),
              ),
            );
          },
          onSuggestionSelected: (value) async {
            if (value != null && value is Suggestion) {
              _controller.text = value.value;
              if (widget.onSelected != null &&
                  value.data.geoLat != null &&
                  value.data.geoLat != null) {
                double? lat = double.tryParse(value.data.geoLat!);
                double? lon = double.tryParse(value.data.geoLon!);
                _position = MapPosition(latitude: lat!, longitude: lon!);
                await widget.onSelected!(
                    AddressFullData(_position!, _controller.text, ""));
              }
            } else {
              _controller.text = '';
            }
          },
        ),
      ],
    );
  }

  FutureOr<Iterable<Object?>> _startSuggesting(String pattern) async {
    var prov = ref.read(dadataApiProvider);
    var res = await prov.getSuggestion(pattern);
    if (res != null) {
      return res.suggestions;
    } else {
      return [];
    }
  }

  void _onListener() {
    if (isError && _controller.text.isNotEmpty) {
      setState(() {
        isError = false;
      });
    }
  }

  @override
  void initAddressValue(AddressFullData data) {
    _position = data.pos;
  }
}
