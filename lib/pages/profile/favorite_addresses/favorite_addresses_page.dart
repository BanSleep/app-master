import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_address_list_response.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_address_editor_page.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_addresses_model.dart';
import 'package:cvetovik/widgets/scaffold.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_extensions/awesome_extensions.dart';

class FavoriteAddressesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteAddressesModelProvider);
    return AppScaffold(
      title: Text("Любимые адреса"),
      body: state.when(
        loaded: (data) => _FavoriteAddressesPageBody(data),
        emptyData: () => _FavoriteAddressesPageBody([]),
        error: (errorText) => AppErrorWidget(
          text: errorText,
          tryAgain: () async {
            await ref.read(favoriteAddressesModelProvider.notifier).load();
          },
        ),
        initializing: () => LoadingWidget(),
      ),
    );
  }
}

class _FavoriteAddressesPageBody extends ConsumerWidget {
  const _FavoriteAddressesPageBody(
    this.favoriteAddresses, {
    Key? key,
  }) : super(key: key);

  final List<FavoriteAddress> favoriteAddresses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: AppAllColors.commonColorsWhite,
          elevation: 2.0,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: favoriteAddresses.length,
            itemBuilder: (_, index) {
              return _FavoriteAddressWidget(favoriteAddresses[index]);
            },
            separatorBuilder: (_, __) => Divider(
              color: AppAllColors.lightGrey,
              thickness: 1,
            ).paddingSymmetric(horizontal: 50.w),
          ),
        ).paddingSymmetric(horizontal: 10.w),
        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: AppAllColors.commonColorsWhite,
          elevation: 2.0,
          child: InkWell(
            onTap: () async {
              await showFavoriteAddressEditor(context);
              ref.read(favoriteAddressesModelProvider.notifier).load();
            },
            child: Row(
              children: [
                Expanded(child: Text("Добавить адрес")),
                Icon(
                  Icons.add,
                  size: 22.r,
                  color: AppAllColors.lightAccent,
                ),
              ],
            ).paddingAll(20.r),
          ),
        ).paddingSymmetric(horizontal: 10.w)
      ],
    );
  }
}

class _FavoriteAddressWidget extends ConsumerWidget {
  const _FavoriteAddressWidget(
    this.favoriteAddress, {
    Key? key,
  }) : super(key: key);

  final FavoriteAddress favoriteAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await showFavoriteAddressEditor(
          context,
          editingFavoriteAddress: favoriteAddress,
        );
        ref.read(favoriteAddressesModelProvider.notifier).load();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            Icon(
              Icons.arrow_forward_ios,
              size: 18.r,
              color: AppAllColors.lightAccent,
            ),
          ],
        ),
      ),
    );
  }
}
