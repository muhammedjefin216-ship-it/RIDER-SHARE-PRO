import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header_bar.dart';
import '../../widgets/common/page_intro_row.dart';
import '../../widgets/trip/section_card.dart';
import '../../widgets/trip/route_pin_fields.dart';
import '../../widgets/trip/plain_text_field.dart';
import '../../widgets/trip/date_time_picker_field.dart';
import '../../widgets/trip/inline_notice.dart';
import '../../widgets/trip/stepper_counter.dart';
import '../../widgets/trip/ai_suggestion_banner.dart';
import '../../widgets/trip/demand_gradient_bar.dart';
import '../../widgets/trip/pro_tips_card.dart';
import '../../widgets/buttons/primary_button.dart';

class PostTripScreen extends ConsumerStatefulWidget {
  const PostTripScreen({super.key});

  @override
  ConsumerState<PostTripScreen> createState() => _PostTripScreenState();
}

class _PostTripScreenState extends ConsumerState<PostTripScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final priceController = TextEditingController();
  final vehicleController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  int seats = 3;
  double maxDetourKm = 5;
  bool womenOnly = false;

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    priceController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  // ==========================================================
  // DATE / TIME PICKERS (LOGIC UNTOUCHED)
  // ==========================================================
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  // ==========================================================
  // POST TRIP (LOGIC UNTOUCHED)
  // ==========================================================
  Future<void> postTrip() async {
    final from = fromController.text.trim();
    final to = toController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (from.isEmpty ||
        to.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        price == null) {
      showMessage('Please fill all required fields');
      return;
    }

    final dateStr =
        '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

    final result = await ref.read(tripsProvider.notifier).createTrip(
          from: from,
          to: to,
          // Placeholder coordinates — location search/autocomplete
          // isn't built yet (needs a map/geocoding integration).
          // Using a tiny non-zero value instead of 0.0, since the
          // backend's validation treats 0 as "not provided"
          // (falsy check in JS) and rejects the request otherwise.
          fromLat: 0.0001,
          fromLon: 0.0001,
          toLat: 0.0001,
          toLon: 0.0001,
          departureDate: dateStr,
          departureTime: timeStr,
          totalSeats: seats,
          pricePerSeat: price,
          maxDetourKm: maxDetourKm,
          womenOnly: womenOnly,
          vehicleInfo: vehicleController.text.trim(),
        );

    if (!mounted) return;

    if (result['success'] == true) {
      showMessage(result['message'] ?? 'Trip posted!', isError: false);
      Navigator.pop(context);
    } else {
      showMessage(result['message'] ?? 'Unable to post trip');
    }
  }

  // ==========================================================
  // MESSAGE (LOGIC UNTOUCHED)
  // ==========================================================
  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.successGreen,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(tripsProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            PageHeaderBar(
              accentWord: 'Post',
              restOfTitle: ' your journey',
              onNotificationTap: () {},
              avatarMenu: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primaryNavy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline_rounded,
                    color: AppColors.white, size: 18),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageIntroRow(
                      title: 'Host a Ride',
                      onLinkTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fill in your trip details and post for passengers to book.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),

                    const SizedBox(height: 16),

                    // ROUTE DETAILS
                    SectionCard(
                      icon: Icons.route_outlined,
                      title: 'Route Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RoutePinFields(
                            fromController: fromController,
                            toController: toController,
                            middleContent: TextButton.icon(
                              onPressed: () {
                                showMessage(
                                  'Intermediate stops need location search — coming with map integration.',
                                  isError: false,
                                );
                              },
                              icon: const Icon(Icons.add_circle_outline,
                                  size: 16, color: AppColors.primaryNavy),
                              label: const Text(
                                'Add intermediate stop',
                                style: TextStyle(
                                  color: AppColors.primaryNavy,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DateTimePickerField(
                                  icon: Icons.calendar_today_outlined,
                                  label: selectedDate == null
                                      ? 'mm/dd/yyyy'
                                      : '${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.year}',
                                  onTap: pickDate,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DateTimePickerField(
                                  icon: Icons.access_time,
                                  label: selectedTime == null
                                      ? '--:--'
                                      : selectedTime!.format(context),
                                  onTap: pickTime,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const InlineNotice(
                            message:
                                'Please select locations from the suggestions list to get accurate coordinates.',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // SEATS & PRICING
                    SectionCard(
                      icon: Icons.event_seat_outlined,
                      title: 'Seats & Pricing',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AVAILABLE SEATS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.hintText,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          StepperCounter(
                            value: seats,
                            onDecrement: seats > 1 ? () => setState(() => seats--) : null,
                            onIncrement: seats < 6 ? () => setState(() => seats++) : null,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Maximum 6 seats',
                            style: TextStyle(fontSize: 10, color: AppColors.hintText),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'PRICE PER SEAT (₹)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.hintText,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          PlainTextField(
                            controller: priceController,
                            hint: '0',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.currency_rupee, size: 16, color: AppColors.hintText),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const AiSuggestionBanner(
                            title: 'AI Suggested: ₹0 per seat',
                            subtitle: 'Based on 0.0 km on route at ₹3.5/km',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ANALYSIS & PREFERENCES
                    SectionCard(
                      icon: Icons.analytics_outlined,
                      title: 'Analysis & Preferences',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DemandGradientBar(),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Max Detour for Pickups',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textLabel,
                                ),
                              ),
                              Text(
                                '${maxDetourKm.toStringAsFixed(0)} km',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.primaryNavy,
                              thumbColor: AppColors.primaryNavy,
                              overlayColor: AppColors.primaryNavy.withOpacity(0.1),
                            ),
                            child: Slider(
                              value: maxDetourKm,
                              min: 0,
                              max: 20,
                              divisions: 20,
                              onChanged: (value) => setState(() => maxDetourKm = value),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Women Only',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textLabel,
                                      ),
                                    ),
                                    Text(
                                      'Only visible to female passengers',
                                      style: TextStyle(fontSize: 10, color: AppColors.hintText),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: womenOnly,
                                activeColor: AppColors.primaryNavy,
                                onChanged: (value) => setState(() => womenOnly = value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // VEHICLE DETAILS
                    SectionCard(
                      icon: Icons.directions_car_outlined,
                      title: 'Vehicle Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Vehicle (for this trip)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          PlainTextField(
                            controller: vehicleController,
                            hint: 'e.g. Toyota Innova - White - KA-01-AB-1234',
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'This will be shown to passengers when they book your ride',
                            style: TextStyle(fontSize: 10, color: AppColors.hintText),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // PRO TIPS
                    ProTipsCard(
                      tips: const [
                        'Setting a competitive price increases your chance of booking by 40%',
                        'Allow a small pickup/dropoff detour to increase your bookings per ride',
                        'Adding intermediate stops helps more passengers book your ride',
                      ],
                    ),

                    const SizedBox(height: 20),

                    PrimaryButton(
                      label: 'Post Trip',
                      trailingIcon: Icons.arrow_forward_rounded,
                      height: 52,
                      isLoading: tripsState.isPosting,
                      onPressed: postTrip,
                    ),

                    const SizedBox(height: 16),
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