import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/trips_provider.dart';
import '../../models/trip_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';

/// Earning screen.
///
/// IMPORTANT — data-accuracy notes for whoever reads this later:
/// * All figures here are APPROXIMATED client-side from `tripsState.hosted`
///   (the same data the Trips tab uses). There is no dedicated earnings/
///   payout backend endpoint yet, so:
///     - "Net Earnings" = sum of COMPLETED hosted trips' fare, minus a
///       flat 5% platform fee (the same rate used in the real checkout
///       flow — see platformFee = seatTotal * 0.05 in the booking screen).
///     - This does NOT reflect real Stripe escrow/payout status per
///       booking (that data isn't returned by getMyTrips).
/// * "Recent Payouts" (bank transactions) and a "Refunds" tab were in the
///   reference design but are intentionally left out — there's no bank-
///   linking or payout-record data anywhere in the schema, so showing
///   them would mean fabricating financial records.
/// * The "Withdraw" button has no backend to call — it shows a
///   "not available yet" message rather than a fake success state.
class EarningScreen extends ConsumerStatefulWidget {
  const EarningScreen({super.key});

  @override
  ConsumerState<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends ConsumerState<EarningScreen> {
  bool _showHosting = true; // History toggle: Hosting vs Travelling
  bool _showAllHistory = false;

  double _parseAmount(String amount) {
    final digits = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(digits) ?? 0.0;
  }

  // Parses the same "24 Jul 2026" style date string the backend sends
  // (see getMyTrips -> toLocaleDateString("en-IN", {day, month: "short", year})).
  DateTime? _parseTripDate(String raw) {
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;

    const monthAliases = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'sept': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };

    final match = RegExp(r'(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})').firstMatch(raw);
    if (match == null) return null;

    final day = int.tryParse(match.group(1)!);
    final monthKey = match.group(2)!.toLowerCase().substring(
          0,
          match.group(2)!.length >= 4 ? 4 : match.group(2)!.length,
        );
    final month = monthAliases[monthKey] ??
        monthAliases[match.group(2)!.toLowerCase().substring(0, 3)];
    final year = int.tryParse(match.group(3)!);

    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(tripsProvider);
    final hosted = tripsState.hosted;
    final guest = tripsState.guest;

    final completed = hosted
        .where((t) => t.status.toUpperCase() == 'COMPLETED')
        .toList();

    final grossEarnings = completed.fold<double>(
      0,
      (sum, t) => sum + _parseAmount(t.amount),
    );
    final platformFee = grossEarnings * 0.05;
    final netEarnings = grossEarnings - platformFee;
    final avgPerTrip = completed.isEmpty ? 0.0 : netEarnings / completed.length;
    final tripsHosted = hosted.length;

    // Group completed trips' net earnings by month, most recent 6 months.
    final Map<String, double> monthlyNet = {};
    final Map<String, DateTime> monthKeyToDate = {};
    for (final t in completed) {
      final d = _parseTripDate(t.date);
      if (d == null) continue;
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
      final net = _parseAmount(t.amount) * 0.95;
      monthlyNet[key] = (monthlyNet[key] ?? 0) + net;
      monthKeyToDate[key] = DateTime(d.year, d.month);
    }
    final sortedKeys = monthlyNet.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    final recentKeys = sortedKeys.length > 6
        ? sortedKeys.sublist(sortedKeys.length - 6)
        : sortedKeys;

    String? highestMonthLabel;
    double highestMonthValue = 0;
    for (final key in monthlyNet.keys) {
      if (monthlyNet[key]! > highestMonthValue) {
        highestMonthValue = monthlyNet[key]!;
        final d = monthKeyToDate[key]!;
        highestMonthLabel = _monthYearLabel(d);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            DashboardTopBar(
              onNotificationTap: () {},
              avatarMenu: _buildTopBarAvatar(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(tripsProvider.notifier).fetchMyTrips(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTotalEarningsCard(
                        netEarnings: netEarnings,
                        platformFee: platformFee,
                      ),
                      const SizedBox(height: 16),
                      _buildStatsRow(
                        avgPerTrip: avgPerTrip,
                        tripsHosted: tripsHosted,
                      ),
                      const SizedBox(height: 16),
                      if (highestMonthLabel != null)
                        _buildHighestMonthCard(
                          label: highestMonthLabel,
                          value: highestMonthValue,
                        ),
                      const SizedBox(height: 24),
                      _sectionTitle('Monthly Earnings'),
                      const SizedBox(height: 10),
                      _buildMonthlyChart(recentKeys, monthlyNet, monthKeyToDate),
                      const SizedBox(height: 24),
                      _buildHistoryHeader(),
                      const SizedBox(height: 10),
                      _buildHistoryList(_showHosting ? hosted : guest),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.white,
        size: 19,
      ),
    );
  }

  String _monthYearLabel(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  String _fmt(num v) => '₹${v.toStringAsFixed(2)}';

  // ---------- Total Earnings ----------

  Widget _buildTotalEarningsCard({
    required double netEarnings,
    required double platformFee,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.heroNavy, AppColors.primaryNavy],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL NET EARNINGS',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _fmt(netEarnings),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Platform Fees (5.0%): -${_fmt(platformFee)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Withdrawals aren\'t available yet.'),
                    ),
                  );
              },
              icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
              label: const Text('Withdraw'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryNavy,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Stats ----------

  Widget _buildStatsRow({
    required double avgPerTrip,
    required int tripsHosted,
  }) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.trending_up_rounded,
            iconBg: AppColors.hostingTagBg,
            iconColor: AppColors.successGreen,
            value: _fmt(avgPerTrip),
            label: 'AVG / TRIP',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.directions_car_filled_rounded,
            iconBg: AppColors.verifiedPillBg,
            iconColor: AppColors.accentBlue,
            value: '$tripsHosted',
            label: 'TRIPS HOSTED',
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ---------- Highest Month ----------

  Widget _buildHighestMonthCard({required String label, required double value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.hostingTagBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              size: 18,
              color: AppColors.successGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Highest Earning Month', style: AppTextStyles.bodySmall),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            _fmt(value),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // ---------- Monthly Chart ----------

  Widget _buildMonthlyChart(
    List<String> keys,
    Map<String, double> monthlyNet,
    Map<String, DateTime> monthKeyToDate,
  ) {
    if (keys.isEmpty) {
      return _emptyStateCard(
        icon: Icons.bar_chart_rounded,
        message: 'No completed trips yet to chart.',
      );
    }

    final maxVal = keys.map((k) => monthlyNet[k]!).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: keys.map((key) {
            final value = monthlyNet[key]!;
            final heightFraction = maxVal == 0 ? 0.05 : (value / maxVal).clamp(0.05, 1.0);
            final d = monthKeyToDate[key]!;
            const monthsShort = [
              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
            ];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: heightFraction,
                          child: Container(
                            decoration: BoxDecoration(
                              color: value == maxVal
                                  ? AppColors.primaryNavy
                                  : AppColors.lightInputBg,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      monthsShort[d.month - 1],
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---------- History ----------

  Widget _buildHistoryHeader() {
    return Row(
      children: [
        Expanded(child: _sectionTitle('History')),
        _historyToggleChip('Hosting', _showHosting, () {
          setState(() {
            _showHosting = true;
            _showAllHistory = false;
          });
        }),
        const SizedBox(width: 8),
        _historyToggleChip('Travelling', !_showHosting, () {
          setState(() {
            _showHosting = false;
            _showAllHistory = false;
          });
        }),
      ],
    );
  }

  Widget _historyToggleChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryNavy : AppColors.featureCardBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<Trip> trips) {
    if (trips.isEmpty) {
      return _emptyStateCard(
        icon: Icons.receipt_long_outlined,
        message: _showHosting
            ? 'No hosted trips yet.'
            : 'No trips booked yet.',
      );
    }

    final sorted = [...trips]..sort((a, b) {
        final da = _parseTripDate(a.date);
        final db = _parseTripDate(b.date);
        if (da == null || db == null) return 0;
        return db.compareTo(da);
      });

    final visible = _showAllHistory ? sorted : sorted.take(5).toList();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: List.generate(visible.length, (i) {
              final trip = visible[i];
              return Column(
                children: [
                  _historyTile(trip),
                  if (i != visible.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              );
            }),
          ),
        ),
        if (!_showAllHistory && sorted.length > 5) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => setState(() => _showAllHistory = true),
            child: const Text(
              'View All Transactions',
              style: TextStyle(
                color: AppColors.primaryNavy,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _historyTile(Trip trip) {
    final statusUpper = trip.status.toUpperCase();
    late IconData icon;
    late Color iconColor;
    late Color iconBg;

    switch (statusUpper) {
      case 'COMPLETED':
        icon = Icons.check_circle_outline_rounded;
        iconColor = AppColors.successGreen;
        iconBg = AppColors.hostingTagBg;
        break;
      case 'CANCELLED':
        icon = Icons.cancel_outlined;
        iconColor = const Color(0xFFDC2626);
        iconBg = const Color(0xFFFEE2E2);
        break;
      case 'ONGOING':
        icon = Icons.directions_car_filled_rounded;
        iconColor = const Color(0xFFB45309);
        iconBg = const Color(0xFFFEF3C7);
        break;
      default: // UPCOMING
        icon = Icons.schedule_rounded;
        iconColor = AppColors.textSecondary;
        iconBg = AppColors.featureCardBg;
    }

    final isEarning = _showHosting;
    final amountColor = statusUpper == 'CANCELLED'
        ? AppColors.textSecondary
        : (isEarning ? AppColors.successGreen : AppColors.textPrimary);
    final sign = statusUpper == 'CANCELLED' ? '' : (isEarning ? '+' : '-');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: iconColor),
      ),
      title: Text(
        trip.route,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${trip.date} • ${_titleCase(statusUpper)}',
        style: AppTextStyles.bodySmall,
      ),
      trailing: Text(
        '$sign${trip.amount.replaceAll('₹', '₹')}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: amountColor,
        ),
      ),
    );
  }

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  // ---------- Shared helpers ----------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  Widget _emptyStateCard({required IconData icon, required String message}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.hintText),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}