import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Material;
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/common/datetime_formatter.dart';
import 'package:stibu/common/is_large_screen.dart';
import 'package:stibu/common/models_extensions.dart';
import 'package:stibu/common/show_result_info.dart';
import 'package:stibu/feature/app_state/realtime_subscriptions.dart';
import 'package:stibu/feature/calendar/event_input.dart';
import 'package:stibu/main.dart';
import 'package:table_calendar/table_calendar.dart';


@RoutePage()
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final _events = <DateTime, List<CalendarEvents>>{};

  StreamSubscription? _subscription;

  List<CalendarEvents> _getEventsForMonth(
    DateTime? month, {
    bool force = false,
  }) {
    if (month == null) return [];

    final events = _events[month];

    if (events == null || force) {
      // load events for month
      final appwrite = getIt<AppwriteClient>();

      final start = DateTime(
        month.year,
        month.month,
        1,
      );

      final end = DateTime(
        month.year,
        month.month + 1,
        1,
      );

      // TODO: refactor to not use a hardcoded limit
      // instead use pagination
      unawaited(
        appwrite.databases.listDocuments(
          databaseId: CalendarEvents.collectionInfo.databaseId,
          collectionId: CalendarEvents.collectionInfo.$id,
          queries: [
            Query.between(
              'start',
              start.toIso8601String(),
              end.toIso8601String(),
            ),
            Query.limit(100),
          ],
        ).then((response) {
          final List<CalendarEvents> events = response.documents
              .map<CalendarEvents>(CalendarEvents.fromAppwrite)
              .toList();

          final Map<DateTime, List<CalendarEvents>> eventsMap = {};
          for (final event in events) {
            final day = event.start.stripTime();
            if (eventsMap[day] == null) {
              eventsMap[day] = [];
            }
            eventsMap[day]!.add(event);
          }

          if (mounted) {
            setState(() {
              _events.addAll(eventsMap);
            });
          }
        }),
      );
    }
    return events ?? [];
  }

  List<CalendarEvents> _getEventsForDay(DateTime? day, {bool force = false}) {
    if (day == null) return [];

    final events = _events[day];

    // if (events == null || force) {
    //   // load events for day
    //   final appwrite = getIt<AppwriteClient>();

    //   unawaited(
    //     appwrite.databases.listDocuments(
    //       databaseId: CalendarEvents.collectionInfo.databaseId,
    //       collectionId: CalendarEvents.collectionInfo.$id,
    //       queries: [
    //         Query.between(
    //           'start',
    //           day.toIso8601String(),
    //           day
    //               .add(
    //                 const Duration(
    //                   hours: 23,
    //                   minutes: 59,
    //                   seconds: 59,
    //                   milliseconds: 999,
    //                 ),
    //               )
    //               .toIso8601String(),
    //         ),
    //       ],
    //     ).then((response) {
    //       final List<CalendarEvents> events = response.documents
    //           .map<CalendarEvents>(CalendarEvents.fromAppwrite)
    //           .toList();

    //       if (mounted) {
    //         setState(() {
    //           _events[day] = events;
    //         });
    //       }
    //     }),
    //   );
    // }
    return events ?? [];
  }

  Widget cellBuilder(context, day, focusedDay) => CalendarCell(
        day: day,
        focusedDay: focusedDay,
        selectedDay: _selectedDay,
      );

  @override
  void initState() {
    super.initState();
    _getEventsForMonth(_focusedDay, force: true);
    _subscription =
        getIt<RealtimeSubscriptions>().calendarEventsUpdates.listen((event) {
      final day = event.item.start.stripTime();
      _getEventsForDay(day, force: true);
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = isLargeScreen(context);

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Calendar'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New Event'),
              onPressed: () async => displayNewEventDialog(context),
            ),
          ],
        ),
      ),
      content: Row(
        children: [
          Expanded(
            child: Material(
              child: TableCalendar(
                locale: 'de_DE',
                rowHeight: 80,
                daysOfWeekHeight: 20,
                pageAnimationCurve: Curves.ease,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    // _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (DateTime focusedDay) {
                  _focusedDay = focusedDay;
                  _getEventsForMonth(focusedDay, force: true);
                },
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: _getEventsForDay,
                pageJumpingEnabled: false,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, List<CalendarEvents> events) {
                    if (events.isNotEmpty) {
                      if (events.length > 3) {
                        return Positioned(
                          bottom: 8,
                          child: Row(
                            children: [
                              for (final event in events)
                                // dots for multiple events
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        event.type == CalendarEventsType.plain
                                            ? Colors.blue
                                            : Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  width: 4,
                                  height: 4,
                                ),
                            ],
                          ),
                        );
                      }

                      return Positioned(
                        bottom: 1,
                        child: Column(
                          children: [
                            for (final event in events)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  event.title,
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  defaultBuilder: cellBuilder,
                  outsideBuilder: cellBuilder,
                  disabledBuilder: cellBuilder,
                  holidayBuilder: cellBuilder,
                  selectedBuilder: cellBuilder,
                  todayBuilder: cellBuilder,
                ),
              ),
            ),
          ),
          if (isLarge)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ListView(
                children: _getEventsForDay(_selectedDay)
                    .map((event) => EventListEntry(event: event))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class EventListEntry extends StatelessWidget {
  final CalendarEvents event;
  const EventListEntry({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final participants = <Widget>[];
    for (final participant
        in event.participants ?? <CalendarEventsParticipants>[]) {
      participants.add(
        ListTile(
          title: Text(participant.customer?.name ?? ''),
          subtitle: Text(participant.status.name),
        ),
      );
    }

    return Expander(
      initiallyExpanded: true,
      header: Row(
        children: [
          Text(event.start.formatTime()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(event.title),
          ),
          const Spacer(),
        ],
      ),
      trailing: event.invoice == null
          ? DropDownButton(
              leading: const Icon(FluentIcons.more),
              items: [
                if (event.type == CalendarEventsType.withParticipants &&
                    event.invoice == null)
                  MenuFlyoutItem(
                    text: const Text('Create Invoice'),
                    onPressed: () async => event.createInvoice().then(
                          (value) => context.mounted
                              ? showResultInfo(context, value)
                              : null,
                        ),
                  ),
                if (event.invoice == null) ...[
                  MenuFlyoutItem(
                    text: const Text('Edit'),
                    onPressed: () async =>
                        displayEditEventDialog(context, event),
                  ),
                  MenuFlyoutItem(
                    text: const Text('Delete'),
                    onPressed: () async => event.delete().then(
                          (value) => context.mounted
                              ? showResultInfo(context, value)
                              : null,
                        ),
                  ),
                ],
              ],
            )
          : null,
      contentPadding: const EdgeInsets.all(8),
      content: Column(
        children: [
          Text('Start: ${event.start.formatDateTime()}'),
          Text('End: ${event.end.formatDateTime()}'),
          if (event.description != null || event.amount != null)
            const Divider(),
          if (event.description != null) Text(event.description!),
          if (event.amount != null)
            Text('Price: ${event.amount!.currency.format()}'),
          if (event.participants != null && event.participants!.isNotEmpty) ...[
            const Divider(),
            ...participants,
          ],
        ],
      ),
    );
  }
}

class CalendarCell extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final DateTime? selectedDay;

  const CalendarCell({
    super.key,
    required this.day,
    required this.focusedDay,
    required this.selectedDay,
  });

  bool get isToday => isSameDay(day, DateTime.now());
  bool get isFocusedDay => isSameDay(day, focusedDay);
  bool get isOusideCurrentMonth => day.month != focusedDay.month;
  bool get selected => isSameDay(day, selectedDay);

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
        borderColor: selected ? Colors.blue : null,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            day.day.toString(),
            style: TextStyle(
              color: isToday ? Colors.blue : Colors.black,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
}
