import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_addresses_dialog.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_address_list_response.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_address_editor_page.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_addresses_model.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_svg/svg.dart';

class FavoriteAddressesSelectorWidget extends ConsumerWidget {
  FavoriteAddressesSelectorWidget({
    this.selectedFavoriteAddress,
    required this.onSelected,
  });

  final FavoriteAddress? selectedFavoriteAddress;
  final void Function(FavoriteAddress?) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthorized = ref.read(settingsProvider).isAuthorized();
    final state = ref.watch(favoriteAddressesModelProvider);
    return state.maybeWhen(
      loaded: (data) {
        if ((selectedFavoriteAddress == null && data.isNotEmpty) ||
            (data.isNotEmpty &&
                !data.contains(selectedFavoriteAddress) &&
                data.indexWhere((element) =>
                        element.id == selectedFavoriteAddress!.id) !=
                    -1)) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => onSelected(data[0]));
        }

        return _FavoriteAddressesSelectorWidgetBody(
          data,
          selectedFavoriteAddress: selectedFavoriteAddress,
          onSelected: onSelected,
        );
      },
      initializing: () => LoadingWidget(),
      error: (errorText) => !isAuthorized
          ? _FavoriteAddressesSelectorWidgetBody(
              [],
              selectedFavoriteAddress: selectedFavoriteAddress,
              onSelected: onSelected,
              isNotAuthenticated: true,
            )
          : AppErrorWidget(
              text: errorText,
              tryAgain: () async {
                await ref.read(favoriteAddressesModelProvider.notifier).load();
              },
            ),
      orElse: () => _FavoriteAddressesSelectorWidgetBody(
        [],
        selectedFavoriteAddress: selectedFavoriteAddress,
        onSelected: onSelected,
      ),
    );
  }
}

class _FavoriteAddressesSelectorWidgetBody extends ConsumerWidget {
  const _FavoriteAddressesSelectorWidgetBody(
    this.favoriteAddresses, {
    Key? key,
    this.selectedFavoriteAddress,
    required this.onSelected,
    this.isNotAuthenticated = false,
  }) : super(key: key);

  final List<FavoriteAddress> favoriteAddresses;
  final FavoriteAddress? selectedFavoriteAddress;
  final void Function(FavoriteAddress?) onSelected;
  final bool isNotAuthenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteAddressList = favoriteAddresses.toList();

    if (selectedFavoriteAddress != null &&
        (favoriteAddressList.indexOf(selectedFavoriteAddress!) > 2 ||
            favoriteAddressList.indexOf(selectedFavoriteAddress!) == -1)) {
      if (favoriteAddressList.length < 3) {
        favoriteAddressList.insert(0, selectedFavoriteAddress!);
      } else {
        favoriteAddressList[0] = selectedFavoriteAddress!;
      }
    }

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        if (!isNotAuthenticated)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              final response = await showFavoriteAddressesDialog(context);
              if (response != null) onSelected(response);
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    "Все адреса",
                    style: AppTextStyles.textMediumBold,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppAllColors.lightAccent,
                  size: 25.r,
                ),
              ],
            ).paddingLTRB(20, 0, 15, 10),
          ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount:
              favoriteAddressList.length > 3 ? 3 : favoriteAddressList.length,
          itemBuilder: (_, index) {
            return _FavoriteAddressWidget(
              favoriteAddressList[index],
              selected:
                  selectedFavoriteAddress?.id == favoriteAddressList[index].id,
              onSelected: onSelected,
            );
          },
          separatorBuilder: (_, __) => 8.h.heightBox,
        ),
        GestureDetector(
          onTap: () async {
            final result = await favoriteAddressEditorWithResult(
              context,
              onlyNotSave: isNotAuthenticated,
            );

            if (result != null) {
              if (result.id == -2) {
                ref.read(favoriteAddressesModelProvider.notifier).load();
              }

              onSelected(result);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppAllColors.lightAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    isNotAuthenticated
                        ? (selectedFavoriteAddress != null
                            ? "Изменить адрес доставки"
                            : "Указать адрес доставки")
                        : "Новый адрес",
                    style: AppTextStyles.textMediumBold,
                  ).textColor(Colors.white),
                ),
                Icon(
                  isNotAuthenticated ? Icons.edit_location_alt : Icons.add,
                  color: Colors.white,
                  size: 25.r,
                ),
              ],
            ),
          ),
        ).paddingOnly(top: 8),
      ],
    );
  }
}

class _FavoriteAddressWidget extends ConsumerWidget {
  const _FavoriteAddressWidget(
    this.favoriteAddress, {
    Key? key,
    this.selected = false,
    required this.onSelected,
  }) : super(key: key);

  final FavoriteAddress favoriteAddress;
  final bool selected;
  final void Function(FavoriteAddress?) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onSelected(favoriteAddress),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppAllColors.lightAccent : Colors.transparent,
            width: 1,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: Offset(0, 4),
              blurRadius: 15,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15).copyWith(left: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(favoriteAddress.name)
                        .textStyle(AppTextStyles.textMediumBold),
                    Text(favoriteAddress.title)
                        .textStyle(AppTextStyles.textMedium9)
                        .textColor(AppAllColors.lightDarkGrey),
                  ],
                ),
              ),
              SizedBox(
                width: 45.w,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (favoriteAddress.id == -1) {
                      final result = await favoriteAddressEditorWithResult(
                        context,
                        editingFavoriteAddress: favoriteAddress,
                      );

                      if (result != null) {
                        if (result.id == -2) {
                          onSelected(null);
                        }

                        onSelected(result);
                      }
                    } else {
                      await showFavoriteAddressEditor(
                        context,
                        editingFavoriteAddress: favoriteAddress,
                      );
                      ref.read(favoriteAddressesModelProvider.notifier).load();
                    }
                  },
                  child: SvgPicture.asset(
                    AppIcons.edit,
                    height: 18.r,
                    width: 18.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
