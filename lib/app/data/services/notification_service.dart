import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    // Initialize timezone
    // Note: You'll need to call tz.initializeTimeZones() in main.dart

    // Android initialization settings
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _requestPermissions();

    return this;
  }

  Future<void> _requestPermissions() async {
    final platform = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    await platform?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to specific screens based on payload
    if (response.payload != null) {
      // Handle navigation based on payload
      print('Notification tapped: ${response.payload}');
    }
  }

  // Schedule period reminder
  Future<void> schedulePeriodReminder(DateTime periodDate) async {
    // Remind 2 days before expected period
    final reminderDate = periodDate.subtract(const Duration(days: 2));

    if (reminderDate.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        0, // notification id
        'Period Coming Soon',
        'Your period is expected in 2 days. Prepare accordingly!',
        tz.TZDateTime.from(reminderDate, tz.local).add(const Duration(hours: 9)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'period_reminders',
            'Period Reminders',
            channelDescription: 'Notifications for upcoming period',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'period_reminder',
      );
    }
  }

  // Schedule ovulation reminder
  Future<void> scheduleOvulationReminder(DateTime ovulationDate) async {
    // Remind 1 day before ovulation
    final reminderDate = ovulationDate.subtract(const Duration(days: 1));

    if (reminderDate.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        1, // notification id
        'Ovulation Expected',
        'Your ovulation is expected tomorrow!',
        tz.TZDateTime.from(reminderDate, tz.local).add(const Duration(hours: 9)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'ovulation_reminders',
            'Ovulation Reminders',
            channelDescription: 'Notifications for ovulation',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'ovulation_reminder',
      );
    }
  }

  // Schedule fertile window reminder
  Future<void> scheduleFertileWindowReminder(DateTime fertileStartDate) async {
    if (fertileStartDate.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        2, // notification id
        'Fertile Window Starting',
        'Your fertile window is starting today!',
        tz.TZDateTime.from(fertileStartDate, tz.local)
            .add(const Duration(hours: 9)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fertile_window_reminders',
            'Fertile Window Reminders',
            channelDescription: 'Notifications for fertile window',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'fertile_window_reminder',
      );
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'general_notifications',
          'General Notifications',
          channelDescription: 'General app notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
