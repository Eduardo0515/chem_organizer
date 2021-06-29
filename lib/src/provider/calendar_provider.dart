import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

class CalendarProvider {
  List<String> getEventsForDay(DateTime day) {
    final kEvents = LinkedHashMap<DateTime, List<String>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll({
        DateTime.now(): ['Evento 1', 'Evento 2', 'Evento 3'],
        DateTime(2021, 06, 26): ['Evento 1'],
        DateTime(2021, 06, 27): ['Evento 1', 'Evento 2', 'Evento 3', 'Evento 4']
      });

    return kEvents[day] ?? [];
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}
