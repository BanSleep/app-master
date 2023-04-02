import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/const/app_typedef.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/widgets/address/address_suggestion_widget.dart';
import 'package:cvetovik/widgets/check_box_widget.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SelectAddressWidget extends ConsumerStatefulWidget {
  const SelectAddressWidget({
    Key? key,
    this.data,
    this.selectedAddress,
    this.isEdit,
  }) : super(key: key);
  final AddressData? data;
  final OnSelectedAddressAsync? selectedAddress;
  final bool? isEdit;

  @override
  _SelectAddressWidgetState createState() => _SelectAddressWidgetState();
}

class _SelectAddressWidgetState extends ConsumerState<SelectAddressWidget>
    with SetAddressMixin {
  final keyAddress = GlobalKey();
  final keyTitle = GlobalKey();
  final keyEntrance = GlobalKey();
  final keyApartment = GlobalKey();
  final keyIntercom = GlobalKey();
  late bool _edit;

  late bool _save;
  MapPosition? _position;

  _SelectAddressWidgetState();

  @override
  void initState() {
    _edit = widget.data != null;
    if (widget.isEdit != null) {
      _edit = widget.isEdit!;
    }
    if (_edit) {
      _save = !widget.data!.tmp;
    } else {
      _save = false;
    }
    _address = (_edit) ? widget.data!.address : '';
    if (_edit) {
      _position =
          MapPosition(latitude: widget.data!.lat, longitude: widget.data!.long);
    }
    super.initState();
  }

  late String _address;

  @override
  Widget build(BuildContext context) {
    final double step = 10.h;
    return SizedBox(
      width: 300.w,
      //height: 325.h,
      child: Container(
        decoration: AppUi.roundedContainerDecoration,
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: step,
              ),
              AddressSuggestionWidget(
                key: keyAddress,
                address: _address,
                position: _position,
                onSelected: widget.selectedAddress,
              ),
              SizedBox(
                height: step,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90.w,
                    child: AppTextField(
                      text: (_edit) ? widget.data!.entrance : '',
                      key: keyEntrance,
                      hint: '1',
                      title: AppRes.entrance,
                      minLength: 0,
                      textFieldType: TextFieldType.number,
                      //errorText: AppRes.entrance,
                    ),
                  ),
                  SizedBox(
                    width: 90.w,
                    child: AppTextField(
                      text: (_edit) ? widget.data!.apartment : '',
                      key: keyApartment,
                      hint: '123',
                      textFieldType: TextFieldType.number,
                      title: AppRes.apartment,
                      minLength: 0,
                      //errorText: AppRes.apartment,
                    ),
                  ),
                  SizedBox(
                    width: 90.w,
                    child: AppTextField(
                      text: (_edit) ? widget.data!.intercom : '',
                      key: keyIntercom,
                      hint: '123',
                      textFieldType: TextFieldType.number,
                      title: AppRes.intercom,
                      minLength: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: step,
              ),
              CheckBoxWidget(
                selected: (_edit) ? !widget.data!.tmp : false,
                title: AppRes.saveAddress,
                onChanged: _onChangedSave,
              ),
              Visibility(
                visible: _save,
                child: Column(
                  children: [
                    SizedBox(
                      height: step,
                    ),
                    AppTextField(
                      text: (_edit) ? widget.data!.title : '',
                      key: keyTitle,
                      hint: AppRes.hintTitle,
                      title: AppRes.title,
                      minLength: 1,
                      errorText: AppRes.pleaseInputTitle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: step,
              ),
              SizedBox(
                height: 44.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      String title = '';
                      if (_save) {
                        title = (keyTitle.currentState! as GetStrMixin).value();
                      }
                      var addressData =
                          (keyAddress.currentState! as GetAddressMixin).value();
                      var entrance =
                          (keyEntrance.currentState! as GetStrMixin).value();
                      var apartment =
                          (keyApartment.currentState! as GetStrMixin).value();
                      var intercom =
                          (keyIntercom.currentState! as GetStrMixin).value();

                      if (addressData != null) {
                        var dao = ref.read(addressDaoProvider);
                        if (_edit) {
                          var item = AddressData(
                              id: widget.data!.id,
                              address: addressData.address,
                              title: title,
                              intercom: intercom,
                              entrance: entrance,
                              apartment: apartment,
                              tmp: !_save,
                              lat: addressData.pos.latitude,
                              long: addressData.pos.longitude,
                              used: DateTime.now());
                          var res = await dao.updateAddress(item: item);
                          if (res) {
                            Navigator.pop(context);
                          }
                        } else {
                          var id = await dao.insertAddress(
                            address: addressData.address,
                            title: title,
                            intercom: intercom,
                            entrance: entrance,
                            apartment: apartment,
                            tmp: !_save,
                            lat: addressData.pos.latitude,
                            long: addressData.pos.longitude,
                          );
                          if (id > 0) {
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        AppUi.showToast(context, 'addressData is null');
                      }
                    } catch (ex, st) {
                      await Sentry.captureException(ex, stackTrace: st);
                      AppUi.showToast(context, ex.toString());
                    }
                  },
                  style: AppUi.buttonActionStyle,
                  child: Text(
                    _getTitle(),
                    style: AppTextStyles.titleVerySmall
                        .copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    return (_edit) ? AppRes.save : AppRes.select;
  }

  void _onChangedSave(bool value) {
    setState(() {
      _save = value;
    });
  }

  //late AddressFullData _addressFullData;
  @override
  void initAddressValue(AddressFullData value) {
    //_addressFullData = value;
    _address = value.address;
    (keyAddress.currentState as SetAddressMixin).initAddressValue(value);
  }
}
