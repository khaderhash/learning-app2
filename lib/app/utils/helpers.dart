import 'dart:ui';
import 'package:timeago/timeago.dart' as timeago;

String formatRelativeTime(String dateString) {
  final dateTime = DateTime.parse(dateString);
  return timeago.format(dateTime);
}

final Color primaryColor = Color(0xFF008080);
final Color secondColor = Color(0xFF20B2AA);
final String baseUrl = 'http://10.0.2.2:8000/api';
