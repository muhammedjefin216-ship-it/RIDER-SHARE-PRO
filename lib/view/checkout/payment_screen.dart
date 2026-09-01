import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../providers/trips_provider.dart';
import '../../providers/payment_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/back_title_bar.dart';
import '../../widgets/trip/step_indicator_bar.dart';
import '../../widgets/trip/inline_notice.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final int selectedSeatsCount;
  final double seatPrice;
  final String? tripId;
  final int? fromOrder;
  final int? toOrder;
  final List<int> selectedSeatNumbers;

  const PaymentScreen({
    Key? key,
    this.selectedSeatsCount = 1,
    this.seatPrice = 100.0,
    this.tripId,
    this.fromOrder,
    this.toOrder,
    this.selectedSeatNumbers = const [],
  }) : super(key: key);

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _saveInfo = false;

  double get seatTotal => widget.selectedSeatsCount * widget.seatPrice;
  double get platformFee => seatTotal * 0.05; 
  double get totalAmount => seatTotal + platformFee;

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.successGreen,
        ),
      );
  }

  Future<String?> _createStripePaymentIntent() async {
    if (widget.tripId == null ||
        widget.fromOrder == null ||
        widget.toOrder == null) {
      return null;
    }

    final intentData = await ref
        .read(paymentProvider.notifier)
        .createPaymentIntent(
          tripId: widget.tripId!,
          fromOrder: widget.fromOrder!,
          toOrder: widget.toOrder!,
          seatNumbers: widget.selectedSeatNumbers,
        );

    if (intentData == null) {
      final error = ref.read(paymentProvider).errorMessage;
      _showMessage(error ?? 'Unable to set up payment');
      return null;
    }

    final clientSecret = intentData['clientSecret'] as String?;
    if (clientSecret == null) {
      _showMessage('Payment setup response was missing a clientSecret.');
      return null;
    }

    return _confirmPaymentWithStripe(clientSecret);
  }

  Future<String?> _confirmPaymentWithStripe(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'RideSharePro',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return clientSecret.split('_secret_').first;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        _showMessage('Payment cancelled');
      } else {
        _showMessage(e.error.localizedMessage ?? 'Payment failed');
      }
      return null;
    } catch (e) {
      _showMessage('Payment failed: $e');
      return null;
    }
  }

  Future<void> _payAndBook() async {
    if (widget.tripId == null ||
        widget.fromOrder == null ||
        widget.toOrder == null) {
      _showMessage('Missing trip/segment info — cannot book.');
      return;
    }
    if (widget.selectedSeatNumbers.isEmpty) {
      _showMessage('No seats selected.');
      return;
    }

    final paymentIntentId = await _createStripePaymentIntent();
    if (paymentIntentId == null)
      return; 

    final result = await ref
        .read(tripsProvider.notifier)
        .bookTrip(
          tripId: widget.tripId!,
          fromOrder: widget.fromOrder!,
          toOrder: widget.toOrder!,
          seatNumbers: widget.selectedSeatNumbers,
          paymentIntentId: paymentIntentId,
        );

    if (!mounted) return;

    if (result['success'] == true) {
      _showMessage(result['message'] ?? 'Booking confirmed!', isError: false);
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      final unavailable = result['unavailableSeats'];
      final suffix = unavailable != null ? ' (seats: $unavailable)' : '';
      _showMessage('${result['message'] ?? 'Unable to book this trip'}$suffix');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackTitleBar(accentWord: 'Pay', restOfTitle: ' securely'),
              const SizedBox(height: 8),
              const StepIndicatorBar(
                steps: [StepItem('Review'), StepItem('Payment')],
                currentIndex: 1,
              ),
              const SizedBox(height: 16),
              _buildBannerCard(),
              const SizedBox(height: 16),
              _buildLinkPayCard(),
              const SizedBox(height: 20),
              _buildPaymentMethodSection(),
              const SizedBox(height: 16),
              _buildSaveInfoCard(),
              const SizedBox(height: 20),
              _buildPriceDetailsCard(),
              const SizedBox(height: 16),
              const InlineNotice(
                icon: Icons.info_outline,
                title: 'Cancellation Policy',
                message:
                    'Full refund if cancelled at least 24 hours before the ride starts. Platform fee is non-refundable.',
                backgroundColor: AppColors.lightInputBg,
                borderColor: AppColors.lightInputBg,
                iconColor: AppColors.primaryNavy,
                textColor: AppColors.textPrimary,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }


  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, AppColors.heroNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Finalize your journey to Mumbai',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLinkPayCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightInputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.flash_on,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Link',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Text(
                '1-CLICK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Pay 3× faster with your saved details.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF101828),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Pay with Link',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.infoBannerBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: AppColors.primaryNavy,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "You'll enter your card details securely in the next step, powered by Stripe.",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Save my information',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'For faster checkout next time',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          Switch(
            value: _saveInfo,
            onChanged: (val) {
              setState(() {
                _saveInfo = val;
              });
            },
            activeColor: AppColors.primaryNavy,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.selectedSeatsCount} seat price',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '₹${seatTotal.toInt()}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Platform fee',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                '₹${platformFee.toInt()}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total amount',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹${totalAmount.toInt()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppColors.white),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: ref.watch(tripsProvider).isBooking
                    ? null
                    : _payAndBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: ref.watch(tripsProvider).isBooking
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock,
                            color: AppColors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Pay ',
                                  style: TextStyle(
                                    color: AppColors.oliveGold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: '₹${totalAmount.toInt()}',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.shield_outlined,
                  color: AppColors.textSecondary,
                  size: 12,
                ),
                SizedBox(width: 4),
                Text(
                  'Your payment data is encrypted and secure',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
