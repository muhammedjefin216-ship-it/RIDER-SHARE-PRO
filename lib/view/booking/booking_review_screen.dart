import 'package:flutter/material.dart';
import 'package:ridesharepro/view/checkout/payment_screen.dart';
import '../../models/ride_search_result.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/trip/step_indicator_bar.dart';
import '../../widgets/trip/plain_card.dart';
import '../../widgets/trip/inline_notice.dart';
import '../../widgets/trip/trust_badge_chip.dart';
import '../../widgets/buttons/primary_button.dart';

class BookingReviewScreen extends StatefulWidget {
  final RideSearchResult ride;
  final int selectedSeatsCount;
  final double seatPrice;
  final List<int> selectedSeatNumbers;

  const BookingReviewScreen({
    super.key,
    required this.ride,
    this.selectedSeatsCount = 1,
    this.seatPrice = 100.0,
    this.selectedSeatNumbers = const [],
  });

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  final TextEditingController _promoController = TextEditingController();

  double get seatTotal => widget.selectedSeatsCount * widget.seatPrice;
  double get platformFee => seatTotal * 0.05;
  double get totalAmount => seatTotal + platformFee;

  String get _estimatedDrive {
    final km = widget.ride.distanceKm;
    if (km <= 0) return '—';
    final minutes = (km / 50 * 60).round();
    return '~$minutes min drive';
  }

  String get _expectedArrival {
    final parts = widget.ride.departTime.split(':');
    if (parts.length != 2) return '—';

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null || widget.ride.distanceKm <= 0) {
      return widget.ride.departTime;
    }

    final driveMinutes = (widget.ride.distanceKm / 50 * 60).round();
    final depart = DateTime(2000, 1, 1, hour, minute);
    final arrival = depart.add(Duration(minutes: driveMinutes));
    return '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
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
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, size: 20, color: AppColors.primaryNavy),
                      const SizedBox(width: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'go back',
                              style: TextStyle(
                                color: AppColors.oliveGold,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' to seat selection',
                              style: TextStyle(
                                color: AppColors.primaryNavy,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const StepIndicatorBar(
              steps: [StepItem('Review'), StepItem('Payment')],
              currentIndex: 0,
            ),
            const SizedBox(height: 16),
            _buildTripSummaryCard(),
            const SizedBox(height: 16),
            _buildPriceDetailsCard(),
            const SizedBox(height: 16),
            _buildPromoCodeCard(),
            const SizedBox(height: 16),
            const InlineNotice(
              icon: Icons.info_outline,
              title: 'Cancellation Policy',
              message:
                  'Free cancellation up to 24 hours before departure. After that, a 50% cancellation fee applies.',
            ),
            const SizedBox(height: 12),
            _buildTrustBadgesRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildTripSummaryCard() {
    final ride = widget.ride;

    return PlainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Trip Summary',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightInputBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Seat ${widget.selectedSeatsCount} Selected',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightInputBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Boarding',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(ride.from,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(
                        ride.distanceKm > 0 ? '${ride.distanceKm.toStringAsFixed(1)} km' : '—',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: AppColors.primaryNavy, size: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Alighting',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(ride.to,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(_estimatedDrive,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(Icons.circle, color: AppColors.successGreen, size: 12),
                  Container(width: 2, height: 36, color: AppColors.border),
                  const Icon(Icons.circle, color: AppColors.primaryNavy, size: 12),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('FROM',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold)),
                        Text(ride.departureDate,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ride.from,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text(ride.departTime,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('TO',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold)),
                    Text(ride.to,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Expected arrival $_expectedArrival',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryNavy,
                child: Text(ride.avatar,
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride.driver,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.starGold, size: 14),
                        const SizedBox(width: 2),
                        Text(ride.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              if (ride.vehicleInfo.isNotEmpty)
                Column(
                  children: [
                    const Icon(Icons.directions_car_outlined, color: AppColors.textPrimary, size: 20),
                    SizedBox(
                      width: 70,
                      child: Text(
                        ride.vehicleInfo,
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsCard() {
    return PlainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.selectedSeatsCount} seat × ₹${widget.seatPrice.toInt()}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text('₹${seatTotal.toInt()}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Platform fee (5%)',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text('₹${platformFee.toInt()}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('₹${totalAmount.toInt()}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeCard() {
    return PlainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PROMO CODE',
              style: TextStyle(
                  fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.lightInputBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sell_outlined, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          decoration: const InputDecoration(
                            hintText: 'Enter promo code',
                            hintStyle: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightInputBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply',
                      style: TextStyle(
                          color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadgesRow() {
    return Row(
      children: [
        const Expanded(
          child: TrustBadgeChip(
            icon: Icons.shield_outlined,
            label: 'Secured by Stripe Escrow',
            backgroundColor: Color(0xffE8F5E9),
            contentColor: Color(0xff2E7D32),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: TrustBadgeChip(
            icon: Icons.event_available,
            label: 'Free Cancellation until 24h',
            backgroundColor: AppColors.lightInputBg,
            contentColor: AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppColors.white),
      child: SafeArea(
        child: PrimaryButton(
          label: 'Continue to Payment',
          trailingIcon: Icons.chevron_right,
          height: 48,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentScreen(
                  selectedSeatsCount: widget.selectedSeatsCount,
                  seatPrice: widget.seatPrice,
                  tripId: widget.ride.id,
                  fromOrder: widget.ride.fromOrder,
                  toOrder: widget.ride.toOrder,
                  selectedSeatNumbers: widget.selectedSeatNumbers,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}