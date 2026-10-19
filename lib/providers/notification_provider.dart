import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationsState {
  final bool isLoading;
  final List<NotificationItem> items;
  final int unreadCount;
  final String? errorMessage;

  const NotificationsState({
    this.isLoading = false,
    this.items = const [],
    this.unreadCount = 0,
    this.errorMessage,
  });

  NotificationsState copyWith({
    bool? isLoading,
    List<NotificationItem>? items,
    int? unreadCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, NotificationsState>(
  NotificationsNotifier.new,
);

class NotificationsNotifier extends Notifier<NotificationsState> {
  final NotificationService _service = NotificationService();

  @override
  NotificationsState build() {
    return const NotificationsState();
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _service.getNotifications();
      final data = response.data as Map<String, dynamic>;

      final rawList = (data['data'] as List?) ?? [];
      final items = rawList
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList();

      final unreadCount = (data['unreadCount'] as num?)?.toInt() ??
          items.where((n) => !n.read).length;

      state = state.copyWith(
        isLoading: false,
        items: items,
        unreadCount: unreadCount,
        clearError: true,
      );
    } on DioException catch (e) {
      print('FETCH NOTIFICATIONS ERROR: ${e.response?.data}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load notifications',
      );
    } catch (e) {
      print('FETCH NOTIFICATIONS UNKNOWN ERROR: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Optimistic: flips the item locally first so tapping feels instant,
  // then confirms with the server. Not reverted on failure — a stale
  // "read" state is a harmless inconsistency; a silent revert would be
  // more confusing than leaving it marked read locally.
  Future<void> markAsRead(String notificationId) async {
    final target = state.items.where((n) => n.id == notificationId);
    if (target.isEmpty || target.first.read) return; // already read, no-op

    final updated = state.items
        .map((n) => n.id == notificationId ? n.copyWith(read: true) : n)
        .toList();
    final newUnread = updated.where((n) => !n.read).length;

    state = state.copyWith(items: updated, unreadCount: newUnread);

    try {
      await _service.markAsRead(notificationId);
    } on DioException catch (e) {
      print('MARK AS READ ERROR: ${e.response?.data}');
    } catch (e) {
      print('MARK AS READ UNKNOWN ERROR: $e');
    }
  }

  Future<void> markAllAsRead() async {
    if (state.unreadCount == 0) return;

    final updated = state.items.map((n) => n.copyWith(read: true)).toList();
    state = state.copyWith(items: updated, unreadCount: 0);

    try {
      await _service.markAllAsRead();
    } on DioException catch (e) {
      print('MARK ALL AS READ ERROR: ${e.response?.data}');
    } catch (e) {
      print('MARK ALL AS READ UNKNOWN ERROR: $e');
    }
  }
}