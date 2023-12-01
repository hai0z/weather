import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> getTimesAfterCurrentTime(List<String> timeList) {
  final currentTime = TimeOfDay.now();
  List<String> result = [];

  for (var time in timeList) {
    final timeComponents = time.split(":");
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    if (hour > currentTime.hour ||
        (hour == currentTime.hour && minute > currentTime.minute)) {
      result.add(time);
    }
  }

  return result;
}

String convertDateToDay(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  DateTime currentDate = DateTime.now();

  if (dateTime.year == currentDate.year &&
      dateTime.month == currentDate.month &&
      dateTime.day == currentDate.day) {
    return 'Hôm nay';
  }

  String formattedDay = DateFormat('EEEE', 'vi_VN').format(dateTime);
  return formattedDay;
}
