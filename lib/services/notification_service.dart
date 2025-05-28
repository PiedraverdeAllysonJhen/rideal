import 'package:flutter/material.dart';

enum NotificationType {
  success,
  info,
  warning,
  error,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  Color get color {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.info:
        return Icons.info;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
    }
  }
}

class RidealNotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    final notification = AppNotification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );

    _notifications.insert(0, notification);
    notifyListeners();
  }

  void removeNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}