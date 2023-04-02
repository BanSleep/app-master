import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_date_list_response.dart';
import 'package:cvetovik/pages/profile/favorite_dates/favorite_dates_model.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarState {
  const EventCalendarState(
    this.focusedDay,
    this.pageController,
  );

  final DateTime focusedDay;
  final PageController pageController;
}

final eventCalendarModelProvider =
    StateNotifierProvider<EventCalendarModel, EventCalendarState>(
  (ref) => EventCalendarModel(),
);

class EventCalendarModel extends StateNotifier<EventCalendarState> {
  EventCalendarModel()
      : super(
          EventCalendarState(
            (DateTime.now().day == 1)
                ? DateTime.now().add(Duration(days: 1))
                : DateTime.now().subtract(Duration(days: 1)),
            PageController(),
          ),
        );

  void setFocusedDay(DateTime dateTime) {
    state = EventCalendarState(
      dateTime,
      state.pageController,
    );
  }

  void setController(PageController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = EventCalendarState(
        state.focusedDay,
        controller,
      );
    });
  }
}

class EventCalendar extends ConsumerWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventCalendarModelProvider);
    final favoriteDatesState = ref.watch(favoriteDatesModelProvider);

    return favoriteDatesState.maybeWhen(
      loaded: (dates) {
        return _Calendar(dates, state);
      },
      emptyData: () {
        return _Calendar([], state);
      },
      orElse: () => LoadingWidget(),
    );
  }
}

class _Calendar extends ConsumerWidget {
  const _Calendar(
    this.dates,
    this.state, {
    Key? key,
  }) : super(key: key);

  final List<FavoriteDate> dates;
  final EventCalendarState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _CalendarHeader(
          focusedDay: state.focusedDay,
          onLeftArrowTap: () {
            state.pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          onRightArrowTap: () {
            state.pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
        IgnorePointer(
          child: TableCalendar(
            eventLoader: (day) => dates
                .where(
                  (element) =>
                      element.day == day.day && element.month == day.month,
                )
                .toList(),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppAllColors.lightAccent,
                shape: BoxShape.circle,
              ),
              rangeStartDecoration: BoxDecoration(),
              rangeStartTextStyle: TextStyle(),
              markerDecoration: BoxDecoration(
                color: AppAllColors.lightAccent,
                shape: BoxShape.circle,
              ),
              markerSize: 7,
              markerMargin: EdgeInsets.symmetric(horizontal: 1),
            ),
            locale: "ru",
            startingDayOfWeek: StartingDayOfWeek.monday,
            firstDay: DateTime.now().subtract(Duration(days: 1000)),
            lastDay: DateTime.now().add(Duration(days: 1000)),
            focusedDay: state.focusedDay,
            rangeStartDay: state.focusedDay,
            headerVisible: false,
            onDaySelected: (_, value) => ref
                .read(eventCalendarModelProvider.notifier)
                .setFocusedDay(value),
            onCalendarCreated: (controller) => ref
                .read(eventCalendarModelProvider.notifier)
                .setController(controller),
            onPageChanged: (focusedDay) => ref
                .read(eventCalendarModelProvider.notifier)
                .setFocusedDay(focusedDay),
          ),
        ),
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  }) : super(key: key);

  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM("ru").format(focusedDay);

    return Row(
      children: [
        Expanded(
          child: Text(headerText).textStyle(AppTextStyles.titleLarge),
        ),
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: onLeftArrowTap,
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: onRightArrowTap,
        ),
      ],
    ).paddingSymmetric(horizontal: 10).paddingOnly(bottom: 30);
  }
}
