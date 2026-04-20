/// In-app notification provider with randomized event triggers.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../storage/hive_storage.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'emergency', 'fraud', 'reward', 'tip'
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'tip',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  final _storage = HiveStorage();
  final _random = Random();
  Timer? _timer;

  List<AppNotification> _notifications = [];
  DateTime? _lastTriggerTime;

  static const int _maxActiveNotifications = 3;
  static const Duration _cooldownDuration = Duration(minutes: 5);
  static const Duration _tickInterval = Duration(seconds: 60);
  static const double _triggerChance = 0.15;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Pool of notification templates (no emojis).
  static const List<Map<String, String>> _notificationPool = [
    {
      'title': 'Emergency Alert',
      'body': 'An unexpected expense has come up! Check the Emergency module to prepare.',
      'type': 'emergency',
    },
    {
      'title': 'Scam Warning',
      'body': 'A suspicious message was reported in your area. Test your fraud detection skills.',
      'type': 'fraud',
    },
    {
      'title': 'Savings Milestone',
      'body': 'You are making progress! Keep saving consistently to build financial security.',
      'type': 'reward',
    },
    {
      'title': 'Budgeting Tip',
      'body': 'Follow the 50-30-20 rule: 50% needs, 30% wants, 20% savings.',
      'type': 'tip',
    },
    {
      'title': 'Financial Health Check',
      'body': 'Review your spending patterns. Are you staying within budget this month?',
      'type': 'tip',
    },
    {
      'title': 'Emergency Fund Reminder',
      'body': 'Building an emergency fund protects against unexpected expenses. Contribute today.',
      'type': 'emergency',
    },
    {
      'title': 'Fraud Prevention',
      'body': 'Never share OTP or banking details over phone. Practice identifying scams.',
      'type': 'fraud',
    },
    {
      'title': 'Smart Money Habit',
      'body': 'Track every expense for a week. Small leaks sink big ships.',
      'type': 'tip',
    },
    {
      'title': 'Investment Insight',
      'body': 'Starting early with small amounts can grow significantly with compound interest.',
      'type': 'tip',
    },
    {
      'title': 'Debt Awareness',
      'body': 'High-interest loans can double your debt. Always compare interest rates before borrowing.',
      'type': 'tip',
    },
  ];

  /// Initialize and load persisted notifications.
  void initialize() {
    final stored = _storage.getNotifications();
    _notifications = stored.map((e) => AppNotification.fromJson(e)).toList();
    _lastTriggerTime = _storage.getLastNotificationTime();
    _startTimer();
    notifyListeners();
  }

  /// Start the periodic random event timer.
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_tickInterval, (_) => _onTick());
  }

  void _onTick() {
    // Check cooldown
    if (_lastTriggerTime != null) {
      final elapsed = DateTime.now().difference(_lastTriggerTime!);
      if (elapsed < _cooldownDuration) return;
    }

    // Check max notifications
    final unread = _notifications.where((n) => !n.isRead).length;
    if (unread >= _maxActiveNotifications) return;

    // Random chance
    if (_random.nextDouble() > _triggerChance) return;

    _triggerRandomNotification();
  }

  void _triggerRandomNotification() {
    final template = _notificationPool[_random.nextInt(_notificationPool.length)];
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: template['title']!,
      body: template['body']!,
      type: template['type']!,
      createdAt: DateTime.now(),
    );

    _notifications.insert(0, notification);

    // Keep only last 20 notifications
    if (_notifications.length > 20) {
      _notifications = _notifications.sublist(0, 20);
    }

    _lastTriggerTime = DateTime.now();
    _persist();
    notifyListeners();
  }

  /// Mark a notification as read.
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _persist();
      notifyListeners();
    }
  }

  /// Mark all notifications as read.
  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    _persist();
    notifyListeners();
  }

  /// Clear all notifications.
  void clearAll() {
    _notifications.clear();
    _persist();
    notifyListeners();
  }

  void _persist() {
    _storage.saveNotifications(_notifications.map((n) => n.toJson()).toList());
    if (_lastTriggerTime != null) {
      _storage.saveLastNotificationTime(_lastTriggerTime!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
