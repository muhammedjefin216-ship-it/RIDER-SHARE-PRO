import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharepro/view/booking/seat_booking_screen.dart';
import '../../providers/ride_search_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/back_title_bar.dart';
import '../../widgets/trip/search_summary_banner.dart';
import '../../widgets/trip/info_pill_chip.dart';
import '../../widgets/trip/filter_chips_bar.dart';
import '../../widgets/trip/ride_result_card.dart';
import '../../widgets/trip/no_rides_found_banner.dart';
import '../../widgets/trip/ride_alert_card.dart';

// NOTE: original import pointed at 'trip_booking%20screen.dart' (a
// filename containing a literal space) — assumed to be a typo and
// corrected to 'trip_booking_screen.dart' here. Update this path if
// your actual booking screen file lives elsewhere.

class FindRideBookingScreen extends ConsumerStatefulWidget {
  final String initialFrom;
  final String initialTo;

  const FindRideBookingScreen({
    super.key,
    this.initialFrom = 'Malappuram',
    this.initialTo = 'Kozhikode',
  });

  @override
  ConsumerState<FindRideBookingScreen> createState() =>
      _FindRideBookingScreenState();
}

class _FindRideBookingScreenState extends ConsumerState<FindRideBookingScreen> {
  late String from;
  late String to;
  DateTime selectedDate = DateTime.now();
  int passengers = 1;

  @override
  void initState() {
    super.initState();
    from = widget.initialFrom;
    to = widget.initialTo;
    WidgetsBinding.instance.addPostFrameCallback((_) => _runSearch());
  }

  // ==========================================================
  // SEARCH (LOGIC UNTOUCHED)
  // ==========================================================
  void _runSearch() {
    ref.read(rideSearchProvider.notifier).search(
          from: from,
          to: to,
          date:
              '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
          passengers: passengers,
        );
  }

  // ==========================================================
  // EDIT SEARCH SHEET (LOGIC UNTOUCHED)
  // ==========================================================
  Future<void> _openEditSheet() async {
    final fromController = TextEditingController(text: from);
    final toController = TextEditingController(text: to);
    DateTime tempDate = selectedDate;
    int tempPassengers = passengers;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Search',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: fromController,
                    decoration: InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: toController,
                    decoration: InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setSheetState(() => tempDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
                          Text('${tempDate.day}/${tempDate.month}/${tempDate.year}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Passengers',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        onPressed: tempPassengers > 1
                            ? () => setSheetState(() => tempPassengers--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primaryNavy,
                      ),
                      Text('$tempPassengers',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      IconButton(
                        onPressed: tempPassengers < 6
                            ? () => setSheetState(() => tempPassengers++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primaryNavy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          from = fromController.text.trim().isEmpty
                              ? from
                              : fromController.text.trim();
                          to = toController.text.trim().isEmpty
                              ? to
                              : toController.text.trim();
                          selectedDate = tempDate;
                          passengers = tempPassengers;
                        });
                        Navigator.pop(context);
                        _runSearch();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Search',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(rideSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async => _runSearch(),
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  children: [
                    BackTitleBar(
                      accentWord: 'Find',
                      restOfTitle: ' your Trip',
                    ),
                    SearchSummaryBanner(
                      from: from,
                      to: to,
                      onEdit: _openEditSheet,
                      pills: [
                        InfoPillChip(
                          icon: Icons.calendar_today_rounded,
                          label: _formatDate(selectedDate),
                        ),
                        const SizedBox(width: 8),
                        InfoPillChip(
                          icon: Icons.person_rounded,
                          label: '$passengers Passenger${passengers > 1 ? 's' : ''}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const FilterChipsBar(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          if (searchState.isSearching)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 60),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (searchState.errorMessage != null)
                            Text(searchState.errorMessage!,
                                style: const TextStyle(color: AppColors.error))
                          else if (searchState.results.isEmpty) ...[
                            const NoRidesFoundBanner(),
                            const SizedBox(height: 16),
                            const RideAlertCard(),
                          ] else ...[
                            Column(
                              children: searchState.results
                                  .map<Widget>(
                                    (ride) => Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: RideResultCard(
                                        departureDate: ride.departureDate,
                                        departTime: ride.departTime,
                                        avatarText: ride.avatar,
                                        driver: ride.driver,
                                        verified: ride.verified,
                                        rating: ride.rating,
                                        price: ride.price,
                                        vehicleInfo: ride.vehicleInfo,
                                        seatsLeft: ride.seatsLeft,
                                        onViewRide: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SeatBookingScreen(ride: ride),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 4),
                            const RideAlertCard(),
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _runSearch,
        backgroundColor: AppColors.primaryNavy,
        elevation: 4,
        child: const Icon(Icons.search, color: AppColors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}