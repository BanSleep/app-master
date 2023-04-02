import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_date_list_response.dart';
import 'package:cvetovik/pages/profile/favorite_dates/calendar_widget.dart';
import 'package:cvetovik/pages/profile/favorite_dates/favorite_dates_model.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/dialog/dialog.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<Exception?> showFavoriteDatesDialog(
  BuildContext context, {
  FavoriteDate? editingFavoriteDate,
}) async {
  final response = await AppUi.showAppBottomSheet<Exception?>(
    context: context,
    child: FavoriteDateDialog(editingFavoriteDate: editingFavoriteDate),
  );

  if (response != null) {
    AppUi.showToast(context, "Произошла ошибка");
  }

  return response;
}

class FavoriteDateDialog extends ConsumerStatefulWidget {
  const FavoriteDateDialog({
    Key? key,
    this.editingFavoriteDate,
  }) : super(key: key);

  final FavoriteDate? editingFavoriteDate;

  @override
  ConsumerState<FavoriteDateDialog> createState() => _FavoriteDateDialogState();
}

class _FavoriteDateDialogState extends ConsumerState<FavoriteDateDialog> {
  final titleKey = GlobalKey();
  final subtitleKey = GlobalKey();

  var day = 1;
  var month = 1;

  @override
  void initState() {
    super.initState();
    final calendarState = ref.read(eventCalendarModelProvider);

    day = calendarState.focusedDay.day;
    month = calendarState.focusedDay.month;

    if (widget.editingFavoriteDate != null) {
      day = widget.editingFavoriteDate!.day;
      month = widget.editingFavoriteDate!.month;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title: Text(
        widget.editingFavoriteDate != null ? "Изменить дату" : "Добавить дату",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            key: titleKey,
            hint: "Например, День рождения",
            title: "Тип события",
            minLength: 2,
            errorText: "Введите тип события",
            text: widget.editingFavoriteDate?.title,
          ),
          10.h.heightBox,
          AppTextField(
            key: subtitleKey,
            hint: "Например, Марина Иванова",
            title: "Краткое описание",
            minLength: 1,
            errorText: "Введите краткое описание",
            text: widget.editingFavoriteDate?.subtitle,
          ),
          10.h.heightBox,
          Text(
            "Дата",
            style: AppTextStyles.textField
                .copyWith(color: AppAllColors.lightBlack),
          ),
          6.h.heightBox,
          SizedBox(
            height: 200.h,
            child: Row(
              children: [
                Expanded(
                  child: _Picker(
                    initialIndex: day - 1,
                    values: [for (int i = 1; i <= 31; i++) i],
                    onSelected: (index) => setState(() => day = index + 1),
                  ),
                ),
                Expanded(
                  child: _Picker(
                    initialIndex: month - 1,
                    values: [for (int i = 1; i <= 12; i++) getMonth(i)],
                    onSelected: (index) => setState(() => month = index + 1),
                  ),
                ),
              ],
            ),
          ),
          10.h.heightBox,
          AppButton(
            title: "Сохранить",
            white: false,
            tap: () async {
              final title = (titleKey.currentState! as GetStrMixin).value();
              final subtitle =
                  (subtitleKey.currentState! as GetStrMixin).value();
              if (title.isEmpty || subtitle.isEmpty) return;

              Exception? response;
              if (widget.editingFavoriteDate == null) {
                response =
                    await ref.read(favoriteDatesModelProvider.notifier).addDate(
                          AddFavoriteDateRequest(
                            title: title,
                            subtitle: subtitle,
                            day: day,
                            month: month,
                          ),
                        );
              } else {
                response = await ref
                    .read(favoriteDatesModelProvider.notifier)
                    .editDate(
                      widget.editingFavoriteDate!.id,
                      EditFavoriteDateRequest(
                        title: title,
                        subtitle: subtitle,
                        day: day,
                        month: month,
                      ),
                    );
              }

              Navigator.pop(context, response);
            },
          ),
          if (widget.editingFavoriteDate != null)
            AppButton(
              title: "Удалить",
              tap: () async {
                final response = await ref
                    .read(favoriteDatesModelProvider.notifier)
                    .deleteDate(widget.editingFavoriteDate!.id);

                Navigator.pop(context, response);
              },
            ),
        ],
      ),
    );
  }

  String getMonth(int value) => [
        'января',
        'февраля',
        'марта',
        'апреля',
        'мая',
        'июня',
        'июля',
        'августа',
        'сентября',
        'октября',
        'ноября',
        'декабря',
      ][value - 1];
}

class _Picker<T> extends StatelessWidget {
  const _Picker({
    Key? key,
    this.initialIndex = 0,
    required this.values,
    required this.onSelected,
  }) : super(key: key);

  final int initialIndex;
  final List<T> values;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      scrollController: FixedExtentScrollController(initialItem: initialIndex),
      childCount: values.length,
      itemBuilder: (_, index) => Text(values[index].toString()),
      onSelectedItemChanged: (value) => onSelected(value),
      itemExtent: 32,
      magnification: 1.22,
      squeeze: 1.2,
    );
  }
}
