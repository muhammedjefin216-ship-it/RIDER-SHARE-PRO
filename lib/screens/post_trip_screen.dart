import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/trips_provider.dart';

class PostTripScreen extends ConsumerStatefulWidget {
  const PostTripScreen({super.key});

  @override
  ConsumerState<PostTripScreen> createState() => _PostTripScreenState();
}

class _PostTripScreenState extends ConsumerState<PostTripScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final fromLatController = TextEditingController();
  final fromLonController = TextEditingController();
  final toLatController = TextEditingController();
  final toLonController = TextEditingController();
  final seatsController = TextEditingController();
  final priceController = TextEditingController();
  final vehicleController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool womenOnly = false;

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    fromLatController.dispose();
    fromLonController.dispose();
    toLatController.dispose();
    toLonController.dispose();
    seatsController.dispose();
    priceController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> postTrip() async {
    final from = fromController.text.trim();
    final to = toController.text.trim();
    final fromLat = double.tryParse(fromLatController.text.trim());
    final fromLon = double.tryParse(fromLonController.text.trim());
    final toLat = double.tryParse(toLatController.text.trim());
    final toLon = double.tryParse(toLonController.text.trim());
    final seats = int.tryParse(seatsController.text.trim());
    final price = double.tryParse(priceController.text.trim());

    if (from.isEmpty ||
        to.isEmpty ||
        fromLat == null ||
        fromLon == null ||
        toLat == null ||
        toLon == null ||
        selectedDate == null ||
        selectedTime == null ||
        seats == null ||
        price == null) {
      showMessage('Please fill all required fields correctly');
      return;
    }

    final dateStr =
        '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

    final result = await ref.read(tripsProvider.notifier).createTrip(
          from: from,
          to: to,
          fromLat: fromLat,
          fromLon: fromLon,
          toLat: toLat,
          toLon: toLon,
          departureDate: dateStr,
          departureTime: timeStr,
          totalSeats: seats,
          pricePerSeat: price,
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

  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : const Color(0xff16A34A),
        ),
      );
  }

  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: const Color(0xff9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff6B7280),
            letterSpacing: 0.6,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(tripsProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Host a Ride',
          style: TextStyle(color: Color(0xff111827)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Post a Trip',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Share your journey and earn on the way.',
              style: TextStyle(color: Color(0xff6B7280), fontSize: 14),
            ),
            const SizedBox(height: 24),

            _label('FROM'),
            TextField(
              controller: fromController,
              decoration: _decoration('e.g. Kochi', Icons.trip_origin),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fromLatController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: _decoration('From latitude', Icons.explore_outlined),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: fromLonController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: _decoration('From longitude', Icons.explore_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Temporary — will be replaced by a map picker once location integration is added.',
              style: TextStyle(fontSize: 11, color: Color(0xff9CA3AF)),
            ),

            const SizedBox(height: 20),

            _label('TO'),
            TextField(
              controller: toController,
              decoration: _decoration('e.g. Bangalore', Icons.place_outlined),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: toLatController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: _decoration('To latitude', Icons.explore_outlined),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: toLonController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: _decoration('To longitude', Icons.explore_outlined),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _label('DEPARTURE DATE & TIME'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 18, color: Color(0xff9CA3AF)),
                          const SizedBox(width: 8),
                          Text(
                            selectedDate == null
                                ? 'Select date'
                                : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 18, color: Color(0xff9CA3AF)),
                          const SizedBox(width: 8),
                          Text(
                            selectedTime == null
                                ? 'Select time'
                                : selectedTime!.format(context),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('TOTAL SEATS'),
                      TextField(
                        controller: seatsController,
                        keyboardType: TextInputType.number,
                        decoration: _decoration('e.g. 3', Icons.event_seat_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('PRICE PER SEAT'),
                      TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: _decoration('e.g. 500', Icons.currency_rupee),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _label('VEHICLE INFO (OPTIONAL)'),
            TextField(
              controller: vehicleController,
              decoration: _decoration('e.g. Swift Dzire, White', Icons.directions_car_outlined),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Switch(
                  value: womenOnly,
                  activeColor: const Color(0xff16A34A),
                  onChanged: (value) => setState(() => womenOnly = value),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Women only ride',
                  style: TextStyle(fontSize: 13, color: Color(0xff374151)),
                ),
              ],
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: tripsState.isPosting ? null : postTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff16A34A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: tripsState.isPosting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Post Trip',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}