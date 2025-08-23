import 'package:timeago/timeago.dart' as timeago;

String formatRelativeTime(String dateString) {
  final dateTime = DateTime.parse(dateString);
  return timeago.format(dateTime);
}
