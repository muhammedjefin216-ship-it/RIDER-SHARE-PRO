import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/payment_service.dart';

class PaymentState {
  final bool isCreatingIntent;
  final String? errorMessage;

  const PaymentState({this.isCreatingIntent = false, this.errorMessage});

  PaymentState copyWith({
    bool? isCreatingIntent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PaymentState(
      isCreatingIntent: isCreatingIntent ?? this.isCreatingIntent,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  PaymentNotifier.new,
);

class PaymentNotifier extends Notifier<PaymentState> {
  final PaymentService _paymentService = PaymentService();

  @override
  PaymentState build() => const PaymentState();

  Future<Map<String, dynamic>?> createPaymentIntent({
    required String tripId,
    required int fromOrder,
    required int toOrder,
    required List<int> seatNumbers,
  }) async {
    state = state.copyWith(isCreatingIntent: true, clearError: true);

    try {
      final response = await _paymentService.createPaymentIntent(
        tripId: tripId,
        fromOrder: fromOrder,
        toOrder: toOrder,
        seatNumbers: seatNumbers,
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      state = state.copyWith(isCreatingIntent: false, clearError: true);

      return data;
    } on DioException catch (e) {
      String message = 'Unable to set up payment';
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      state = state.copyWith(isCreatingIntent: false, errorMessage: message);
      return null;
    } catch (e) {
      state = state.copyWith(isCreatingIntent: false, errorMessage: e.toString());
      return null;
    }
  }
}