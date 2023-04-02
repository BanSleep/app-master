import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_date_list_response.dart';
import 'package:cvetovik/pages/profile/favorite_dates/calendar_widget.dart';
import 'package:cvetovik/pages/profile/favorite_dates/favorite_dates_dialog.dart';
import 'package:cvetovik/pages/profile/favorite_dates/favorite_dates_model.dart';
import 'package:cvetovik/widgets/scaffold.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_extensions/awesome_extensions.dart';

class FavoriteDatesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteDatesModelProvider);
    return AppScaffold(
      title: Text("Значимые даты"),
      body: state.map(
        loaded: (state) => _FavoriteDatesPageBody(state.data),
        emptyData: (_) => _FavoriteDatesPageBody([]),
        error: (state) => AppErrorWidget(
          text: state.text,
          tryAgain: () async {
            await ref.read(favoriteDatesModelProvider.notifier).load();
          },
        ),
        initializing: (_) => LoadingWidget(),
      ),
    );
  }
}

class _FavoriteDatesPageBody extends ConsumerWidget {
  const _FavoriteDatesPageBody(
    this.favoriteDates, {
    Key? key,
  }) : super(key: key);

  final List<FavoriteDate> favoriteDates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Text(
          "Заполните важные даты, а мы напомним Вам о них в push за 3 дня и пришлём выгодное предложение.",
          textAlign: TextAlign.center,
        )
            .textStyle(AppTextStyles.textField)
            .paddingSymmetric(horizontal: 30)
            .paddingOnly(bottom: 25),
        EventCalendar(),
        30.h.heightBox,
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
            itemCount: favoriteDates.length,
            itemBuilder: (_, index) {
              return _FavoriteDateWidget(favoriteDates[index]);
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
              await showFavoriteDatesDialog(context);
              ref.read(favoriteDatesModelProvider.notifier).load();
            },
            child: Row(
              children: [
                Expanded(child: Text("Добавить дату")),
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

class _FavoriteDateWidget extends ConsumerWidget {
  const _FavoriteDateWidget(
    this.favoriteDate, {
    Key? key,
  }) : super(key: key);

  final FavoriteDate favoriteDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await showFavoriteDatesDialog(
          context,
          editingFavoriteDate: favoriteDate,
        );
        ref.read(favoriteDatesModelProvider.notifier).load();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 45.r,
              width: 45.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppAllColors.lightAccent,
              ),
              child: Text(
                "${favoriteDate.day}\n${getMonth(favoriteDate.month)}",
                textAlign: TextAlign.center,
              ).textStyle(
                AppTextStyles.textSmallBold.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
            15.w.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(favoriteDate.title)
                      .textStyle(AppTextStyles.textMediumBold),
                  Text(favoriteDate.subtitle)
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

  String getMonth(int value) => [
        'янв',
        'фев',
        'мар',
        'апр',
        'май',
        'июн',
        'июл',
        'авг',
        'сен',
        'окт',
        'ноя',
        'дек',
      ][value - 1];
}
