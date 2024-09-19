import 'package:dominant_player/service/holiday_info.dart';

/// 是否正在日盤
/// [dateTime] 指定的時間，預設台灣現在時間
/// [isFuture] true指期貨，false指現貨
bool inDayTrade({DateTime? dateTime, bool isFuture = false}) {
  dateTime ??= DateTime.now().toUtc().add(const Duration(hours: 8));
  if (isHoliday(dateTime)) return false;

  final now = DateTime.now().toUtc().add(const Duration(hours: 8)).add(const Duration(hours: 8));
  final nowYMD = DateTime(now.year, now.month, now.day).toUtc().add(const Duration(hours: 8));
  DateTime dayStartTime = isFuture
      ? nowYMD.add(const Duration(hours: 8, minutes: 44,seconds: 59)) // 8:45
      : nowYMD.add(const Duration(hours: 8, minutes: 59, seconds: 59)); // 9:00
  DateTime dayEndTime = isFuture
      ? nowYMD.add(const Duration(hours: 13, minutes: 45, seconds: 1)) // 13:45
      : nowYMD.add(const Duration(hours: 13, minutes: 30, seconds: 1)); // 13:00
  return dateTime.isAfter(dayStartTime) && dateTime.isBefore(dayEndTime);
}

/// 是否正在夜盤，只有期貨
/// [dateTime] 指定的時間，預設台灣現在時間
bool inNightTrade({DateTime? dateTime}) {
  dateTime ??= DateTime.now().toUtc().add(const Duration(hours: 8));
  if (isHoliday(dateTime)) return false;
  final now = DateTime.now().toUtc().add(const Duration(hours: 8));

  final nowYMD = DateTime(now.year, now.month, now.day).toUtc().add(const Duration(hours: 8));
  DateTime nightStartTime = nowYMD.add(const Duration(hours: 14, minutes: 59, seconds: 59)); // 15:00
  DateTime nightEndTime = nowYMD.add(const Duration(days: 1, hours: 5, seconds: 1)); // 隔天凌晨五點
  return dateTime.isAfter(nightStartTime) && dateTime.isBefore(nightEndTime);
}

bool inTrade(DateTime? dateTime, {bool isFuture = false}) {
  dateTime ??= DateTime.now().toUtc().add(const Duration(hours: 8));
  return inDayTrade(dateTime: dateTime, isFuture: isFuture) || inDayTrade(dateTime: dateTime);
}
