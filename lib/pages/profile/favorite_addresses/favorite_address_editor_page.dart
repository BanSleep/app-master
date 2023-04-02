import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/yandex_geocoder_api.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_address_list_response.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/widgets/address/address_suggestion_widget.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_addresses_model.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/check_box_widget.dart';
import 'package:cvetovik/widgets/scaffold.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

Future<Exception?> showFavoriteAddressEditor(
  BuildContext context, {
  FavoriteAddress? editingFavoriteAddress,
  bool resizeToAvoidBottomInset = false,
}) async {
  final response = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FavoriteAddressEditorPage(
        editingFavoriteAddress: editingFavoriteAddress,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    ),
  );

  if (response != null) {
    AppUi.showToast(context, "Произошла ошибка");
  }

  return response;
}

Future<FavoriteAddress?> favoriteAddressEditorWithResult(
  BuildContext context, {
  FavoriteAddress? editingFavoriteAddress,
  bool resizeToAvoidBottomInset = false,
  bool onlyNotSave = false,
}) async {
  final response = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FavoriteAddressEditorPage(
        editingFavoriteAddress: editingFavoriteAddress,
        returnResult: true,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        onlyNotSave: onlyNotSave,
      ),
    ),
  );

  return response;
}

class FavoriteAddressEditorPage extends ConsumerStatefulWidget {
  const FavoriteAddressEditorPage({
    Key? key,
    this.editingFavoriteAddress,
    this.returnResult = false,
    this.resizeToAvoidBottomInset = false,
    this.onlyNotSave = false,
  }) : super(key: key);

  final FavoriteAddress? editingFavoriteAddress;
  final bool returnResult;
  final bool resizeToAvoidBottomInset;
  final bool onlyNotSave;

  @override
  ConsumerState<FavoriteAddressEditorPage> createState() =>
      _FavoriteAddressEditorPageState();
}

class _FavoriteAddressEditorPageState
    extends ConsumerState<FavoriteAddressEditorPage> {
  Future<bool> get locationPermissionGranted async =>
      await Permission.locationWhenInUse.request().isGranted;
  late YandexMapController _controller;

  final List<MapObject> mapObjects = [];
  PlacemarkMapObject? _userPlaceMark;

  final keyAddress = GlobalKey();
  final keyName = GlobalKey();
  final keyTitle = GlobalKey();
  final keyPhone = GlobalKey();

  var _isLoading = false;
  bool isSaving = true;

  @override
  Widget build(BuildContext context) {
    if (widget.editingFavoriteAddress?.id == -1 || widget.onlyNotSave) {
      isSaving = false;
    }

    return AppScaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      title: Text(
        widget.editingFavoriteAddress != null || widget.onlyNotSave
            ? "Редактировать адрес"
            : "Добавить адрес",
      ),
      extendBodyBehindAppBar: true,
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: AppUi.opacity,
        child: Stack(
          children: [
            Positioned.fill(
              child: YandexMap(
                mapObjects: mapObjects,
                onMapCreated: (yandexMapController) async {
                  _controller = yandexMapController;

                  await _controller.toggleUserLayer(visible: true);
                  await _controller.toggleUserLayer(visible: false);
                  await _controller.toggleUserLayer(visible: true);
                },
                onMapTap: _onMapTap,
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (!(await locationPermissionGranted)) {
                        AppUi.showToast(context, "Не выдано разрешение");
                        return;
                      }

                      setState(() => _isLoading = true);

                      final _userPosition =
                          await _controller.getUserCameraPosition();

                      setState(() => _isLoading = false);

                      if (_userPosition != null) {
                        await _controller.moveCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _userPosition.target,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset(
                        AppIcons.map,
                        color: AppAllColors.lightAccent,
                        width: 22.r,
                        height: 22.r,
                      ),
                    ),
                  ),
                  10.h.heightBox,
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      children: [
                        AddressSuggestionWidget(
                          key: keyAddress,
                          address: widget.editingFavoriteAddress?.address,
                          onSelected: (data) async {
                            final point = Point(
                              latitude: data.pos.latitude,
                              longitude: data.pos.longitude,
                            );

                            await _controller.moveCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(target: point),
                              ),
                            );

                            await _appUserPoint(point);
                          },
                        ),
                        if ((widget.returnResult &&
                                widget.editingFavoriteAddress == null) &&
                            !widget.onlyNotSave) ...[
                          20.h.heightBox,
                          CheckBoxWidget(
                            selected: isSaving,
                            title: AppRes.saveAddress,
                            onChanged: (value) => setState(() {
                              isSaving = value;
                            }),
                          ),
                          10.h.heightBox,
                        ],
                        10.h.heightBox,
                        if (isSaving) ...[
                          AppTextField(
                            key: keyName,
                            hint: "Например, Марина Иванова",
                            title: "Имя",
                            minLength: 1,
                            errorText: "Введите имя",
                            text: widget.editingFavoriteAddress?.name,
                          ),
                          10.h.heightBox,
                          AppTextField(
                            key: keyTitle,
                            hint: "Например, Жена",
                            title: "Краткое описание",
                            minLength: 2,
                            errorText: "Введите краткое описание",
                            text: widget.editingFavoriteAddress?.title,
                          ),
                          10.h.heightBox,
                          AppTextField(
                            key: keyPhone,
                            hint: '+7',
                            textFieldType: TextFieldType.phone,
                            minLength: 10,
                            errorText: AppRes.pleaseInputPhone,
                            title: "Телефон",
                            text: widget.editingFavoriteAddress?.phone,
                          ),
                        ],
                        20.h.heightBox,
                        AppButton(
                          leftPad: 0,
                          rightPad: 0,
                          title: "Сохранить",
                          white: false,
                          tap: () async {
                            final address =
                                (keyAddress.currentState! as GetAddressMixin)
                                    .value();

                            late String name, title, phone;

                            try {
                              name = (keyName.currentState! as GetStrMixin)
                                  .value();
                              title = (keyTitle.currentState! as GetStrMixin)
                                  .value();
                              phone = (keyPhone.currentState! as GetStrMixin)
                                  .value();
                            } catch (_) {}

                            if (!isSaving) {
                              if (address == null || address.address.isEmpty)
                                return;
                            } else {
                              if (address == null ||
                                  address.address.isEmpty ||
                                  name.isEmpty ||
                                  title.isEmpty ||
                                  phone.isEmpty) return;
                            }

                            Exception? response;

                            if ((widget.returnResult && !isSaving) ||
                                (widget.returnResult &&
                                    widget.editingFavoriteAddress != null)) {
                              return Navigator.of(context).pop(
                                FavoriteAddress(
                                  id: -1,
                                  regionId: 1,
                                  address: address.address,
                                  addressAdditional: address.addressAdditional,
                                  name: "Несохраненный адрес",
                                  title: address.address,
                                  phone: "",
                                ),
                              );
                            }

                            if (widget.editingFavoriteAddress == null) {
                              response = await ref
                                  .read(favoriteAddressesModelProvider.notifier)
                                  .addAddress(
                                    AddFavoriteAddressRequest(
                                      regionId: 1,
                                      address: address.address,
                                      addressAdditional:
                                          address.addressAdditional,
                                      name: name,
                                      title: title,
                                      phone: phone,
                                    ),
                                  );
                            } else {
                              response = await ref
                                  .read(favoriteAddressesModelProvider.notifier)
                                  .editAddress(
                                    widget.editingFavoriteAddress!.id,
                                    EditFavoriteAddressRequest(
                                      address: address.address,
                                      addressAdditional:
                                          address.addressAdditional,
                                      name: name,
                                      title: title,
                                      phone: phone,
                                    ),
                                  );
                            }

                            Navigator.pop(context, response);
                          },
                        ),
                        if (widget.editingFavoriteAddress != null)
                          AppButton(
                            title: "Удалить",
                            tap: () async {
                              if (widget.returnResult) {
                                return Navigator.of(context).pop(
                                  FavoriteAddress(
                                    id: -2,
                                    regionId: 1,
                                    address: "",
                                    addressAdditional: "",
                                    name: "",
                                    title: "",
                                    phone: "",
                                  ),
                                );
                              }

                              var response = await ref
                                  .read(favoriteAddressesModelProvider.notifier)
                                  .deleteAddress(
                                      widget.editingFavoriteAddress!.id);

                              Navigator.pop(context, response);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _appUserPoint(Point point) async {
    setState(() {
      if (_userPlaceMark != null) {
        mapObjects.remove(_userPlaceMark!);
      }
      _userPlaceMark = PlacemarkMapObject(
          opacity: 1.0,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(AppIcons.userPoint),
            scale: AppUi.placeMarkScale,
          )),
          point: point,
          mapId: MapObjectId(point.latitude.toString()));
      mapObjects.add(_userPlaceMark!);
    });
  }

  void _onMapTap(Point point) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var pStr = '${point.longitude},${point.latitude}';

      var address =
          await ref.read(yandexGeocoderApiProvider).getAddressFromPoint(pStr);

      await _appUserPoint(point);

      if (keyAddress.currentState is SetAddressMixin && address != null) {
        var data = AddressFullData(
          MapPosition(latitude: point.latitude, longitude: point.longitude),
          address,
          "",
        );
        (keyAddress.currentState as SetAddressMixin).initAddressValue(data);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
