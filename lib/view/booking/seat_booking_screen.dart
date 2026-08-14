import 'package:flutter/material.dart';
import 'package:ridesharepro/view/booking/booking_review_screen.dart';
import '../../models/ride_search_result.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/back_title_bar.dart';
import '../../widgets/trip/map_placeholder_card.dart';
import '../../widgets/trip/driver_contact_card.dart';
import '../../widgets/trip/seat_legend.dart';
import '../../widgets/trip/seat_tile.dart';

class SeatBookingScreen extends StatefulWidget {
  final RideSearchResult ride;

  const SeatBookingScreen({super.key, required this.ride});

  @override
  State<SeatBookingScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<SeatBookingScreen> {
  late List<int> seatStates;
  int get selectedCount => seatStates.where((s) => s == 2).length;
  double get seatPrice => widget.ride.price.toDouble();
  double get totalAmount => selectedCount * seatPrice;

  @override
  void initState() {
    super.initState();

    final total = widget.ride.totalSeats > 0 ? widget.ride.totalSeats : 4;
    final bookedCount = (total - widget.ride.seatsLeft).clamp(0, total);

    seatStates = List.generate(total, (i) => i < bookedCount ? 0 : 1);
  }

  void _toggleSeat(int index) {
    if (seatStates[index] == 0) return;

    setState(() {
      seatStates[index] = seatStates[index] == 1 ? 2 : 1;
    });
  }

  String get _estimatedDrive {
    if (widget.ride.distanceKm <= 0) return '—';
    final minutes = (widget.ride.distanceKm / 50 * 60).round();
    if (minutes < 60) return '$minutes mins';
    final hours = minutes ~/ 60;
    final rem = minutes % 60;
    return rem == 0 ? '${hours}h' : '${hours}h ${rem}m';
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            BackTitleBar(accentWord: 'Book', restOfTitle: ' Your Space'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MapPlaceholderCard(
                      distanceLabel: ride.distanceKm > 0
                          ? '${ride.distanceKm.toStringAsFixed(1)} km'
                          : '—',
                      estimatedDriveLabel: _estimatedDrive,
                      trafficLabel: 'Light',
                    ),
                    SizedBox(height: 16),
                    DriverContactCard(
                      avatarText: ride.avatar,
                      verified: ride.verified,
                      driverName: ride.driver,
                      rating: ride.rating,
                      onMessage: () {},
                      onCall: () {},
                    ),
                    SizedBox(height: 16),
                    _buildDepartureAndPriceRow(ride),
                    SizedBox(height: 20),
                    _buildSeatSelectionSection(ride),
                    SizedBox(height: 20),
                    _buildVehicleDetailsSection(ride),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(ride),
    );
  }

  Widget _buildDepartureAndPriceRow(RideSearchResult ride) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightInputBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEPARTURE',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  ride.departTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  ride.departureDate,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightInputBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRICE',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '₹${ride.price}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                Text(
                  'per seat',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatSelectionSection(RideSearchResult ride) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Seats',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${ride.seatsLeft} seats left',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.infoBannerBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SeatLegend(),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [
                    DriverSeatTile(),
                    ...List.generate(
                      seatStates.length,
                      (i) => SeatTile(
                        state: seatStates[i],
                        onTap: () => _toggleSeat(i),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Tap available seats to select',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleDetailsSection(RideSearchResult ride) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Details',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lightInputBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: AppColors.primaryNavy,
                  size: 22,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  ride.vehicleInfo.isNotEmpty
                      ? ride.vehicleInfo
                      : 'Vehicle details not provided',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(RideSearchResult ride) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL AMOUNT',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '₹${totalAmount.toInt()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$selectedCount seats selected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Incl. platform fee',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: selectedCount > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingReviewScreen(
                              ride: ride,
                              selectedSeatsCount: selectedCount,
                              seatPrice: seatPrice,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCount > 0
                      ? AppColors.primaryNavy
                      : Color(0xffE3E5EB),
                  disabledBackgroundColor: Color(0xffE3E5EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirm Seat Selection',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18, color: AppColors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
