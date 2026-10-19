import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharepro/view/messeges/messages_screen.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/dashboard/dashboard_top_bar.dart';
import '../auth/login_screen.dart';
import '../notification/notification_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _isUploadingPhoto = false;

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }



  void _showPhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primaryNavy,
                ),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primaryNavy,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
      );
      if (picked == null) return;

      setState(() => _pickedImage = File(picked.path));

      // TODO: Upload wiring is intentionally left as a stub — there's no
      // confirmed backend endpoint yet for uploading a profile photo file
      // (multer + cloudinary were mentioned but no route was confirmed).
      // Once that endpoint exists, replace this block with a real
      // multipart upload, then call:
      //   ref.read(authProvider.notifier).updateProfile(..., profilePhoto: uploadedUrl)
      // (updateProfile / AuthService.updateProfile / updateUser on the
      // backend all already accept a profilePhoto field — only the file
      // upload step itself is missing.)
      await _uploadPhotoStub(_pickedImage!);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not pick image: $e')));
    }
  }

  Future<void> _uploadPhotoStub(File file) async {
    setState(() => _isUploadingPhoto = true);

    // Simulated delay so the loading state is visible — remove once a
    // real upload call replaces this.
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isUploadingPhoto = false);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Photo selected. Upload isn\'t wired up yet — this is a local preview only.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isLoadingUser && authState.userId == null) {
      return const Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = authState.userName ?? 'Your Name';
    final email = authState.userEmail ?? '';
    final phone = authState.userPhone ?? '';
    final gender = (authState.userGender ?? '').isEmpty
        ? 'Not set'
        : authState.userGender!;
    final location = (authState.userLocation ?? '').isEmpty
        ? 'Not set'
        : authState.userLocation!;
    final emergencyContact = authState.userEmergencyContact ?? '';
    final rating = authState.userRating ?? 0.0;
    final totalRatings = authState.userTotalRatings ?? 0;
    final isEmailVerified = authState.userIsEmailVerified ?? false;
    final isVerified = authState.userIsVerified ?? false;
    final initials = name.trim().isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).map((e) => e[0]).take(2).join()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            DashboardTopBar(
              onNotificationTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              avatarMenu: _buildTopBarAvatar(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(authProvider.notifier).fetchCurrentUser(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderCard(
                        name: name,
                        email: email,
                        initials: initials,
                        photoUrl: authState.userPhoto,
                      ),
                      const SizedBox(height: 16),
                      _buildStatsRow(
                        rating: rating,
                        totalRatings: totalRatings,
                      ),
                      const SizedBox(height: 24),
                      _sectionTitle('Verification Status'),
                      const SizedBox(height: 10),
                      _buildVerificationCard(
                        isEmailVerified: isEmailVerified,
                        isVerified: isVerified,
                      ),
                      const SizedBox(height: 24),
                      _sectionTitle('Personal Information'),
                      const SizedBox(height: 10),
                      _buildPersonalInfoCard(
                        name: name,
                        gender: gender,
                        email: email,
                        phone: phone,
                        location: location,
                      ),
                      const SizedBox(height: 24),
                      _sectionTitle('Emergency Contact'),
                      const SizedBox(height: 10),
                      _buildEmergencyContactCard(emergencyContact),
                      const SizedBox(height: 24),
                      _sectionTitle('Account Settings'),
                      const SizedBox(height: 10),
                      _buildAccountSettingsCard(),
                      const SizedBox(height: 24),
                      _buildLogoutButton(),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Version 1.0.0',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.hintText,
                          ),
                        ),
                      ),
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

  // ---------- Header ----------

  Widget _buildHeaderCard({
    required String name,
    required String email,
    required String initials,
    String? photoUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Decorative dashed ring around the avatar.
                CustomPaint(
                  size: const Size(92, 92),
                  painter: _DashedCirclePainter(
                    color: AppColors.decorativeBlob,
                  ),
                ),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primaryNavy,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!) as ImageProvider
                      : (photoUrl != null && photoUrl.isNotEmpty)
                      ? NetworkImage(photoUrl)
                      : null,
                  child:
                      (_pickedImage == null &&
                          (photoUrl == null || photoUrl.isEmpty))
                      ? Text(
                          initials.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
                if (_isUploadingPhoto)
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.black38,
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: GestureDetector(
                    onTap: _isUploadingPhoto ? null : _showPhotoSourceSheet,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 13,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(name, style: AppTextStyles.pageTitle.copyWith(fontSize: 19)),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(email, style: AppTextStyles.subtitle),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: wire up share-profile action.
                  },
                  icon: const Icon(Icons.ios_share_rounded, size: 16),
                  label: const Text(
                    'Share',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryNavy,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Stats ----------

  Widget _buildStatsRow({required double rating, required int totalRatings}) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.star_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: AppColors.starGold,
            value: rating.toStringAsFixed(1),
            label: 'RATING',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.reviews_outlined,
            iconBg: AppColors.verifiedPillBg,
            iconColor: AppColors.accentBlue,
            value: '$totalRatings',
            label: 'REVIEWS',
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
      padding: const EdgeInsets.symmetric(vertical: 16),
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
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Verification ----------

  Widget _buildVerificationCard({
    required bool isEmailVerified,
    required bool isVerified,
  }) {
    return _card(
      child: Column(
        children: [
          _verificationRow(
            icon: Icons.email_outlined,
            iconBg: AppColors.verifiedPillBg,
            label: 'Email Address',
            verified: isEmailVerified,
          ),
          const Divider(height: 22, color: AppColors.border),
          _verificationRow(
            icon: Icons.verified_user_outlined,
            iconBg: AppColors.hostingTagBg,
            label: 'Account Verified',
            verified: isVerified,
          ),
        ],
      ),
    );
  }

  Widget _verificationRow({
    required IconData icon,
    required Color iconBg,
    required String label,
    required bool verified,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryNavy),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyles.fieldLabel)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: verified
                ? AppColors.verifiedPillBg
                : AppColors.featureCardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            verified ? 'VERIFIED' : 'PENDING',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: verified ? AppColors.accentBlue : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Personal Info ----------

  Widget _buildPersonalInfoCard({
    required String name,
    required String gender,
    required String email,
    required String phone,
    required String location,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _infoField('Full Name', name.isEmpty ? 'Not set' : name),
              ),
              const SizedBox(width: 16),
              Expanded(child: _infoField('Gender', gender)),
            ],
          ),
          const SizedBox(height: 18),
          _infoField('Email', email.isEmpty ? 'Not set' : email),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _infoField('Phone', phone.isEmpty ? 'Not set' : phone),
              ),
              const SizedBox(width: 16),
              Expanded(child: _infoField('Location', location)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ---------- Emergency Contact ----------

  Widget _buildEmergencyContactCard(String emergencyContact) {
    final isSet = emergencyContact.isNotEmpty;
    final accentColor = isSet ? AppColors.successGreen : AppColors.error;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSet ? AppColors.hostingTagBg : const Color(0xFFFDECEC),
          border: Border(left: BorderSide(color: accentColor, width: 4)),
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSet ? Icons.check_rounded : Icons.priority_high_rounded,
                color: AppColors.white,
                size: 15,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSet ? 'Emergency Contact' : 'Not set',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSet
                        ? emergencyContact
                        : 'Add an emergency contact for safety during your trips',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              color: AppColors.primaryNavy,
              onPressed: () {
                // TODO: open emergency-contact edit dialog.
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Account Settings ----------

  Widget _buildAccountSettingsCard() {
    final items = [
      (
        Icons.chat_bubble_outline_rounded,
        const Color(0xFFE8EDFC),
        AppColors.accentBlue,
        'Messages',
        'Chat with hosts & passengers',
      ),
      (
        Icons.notifications_none_rounded,
        const Color(0xFFE8EDFC),
        AppColors.accentBlue,
        'Notifications',
        'Push, email & SMS alerts',
      ),
      (
        Icons.credit_card_outlined,
        const Color(0xFFE8F7EE),
        AppColors.successGreen,
        'Payment Methods',
        'UPI, cards, wallet',
      ),
      (
        Icons.shield_outlined,
        const Color(0xFFF3E8FD),
        const Color(0xFF9333EA),
        'Privacy & Security',
        'App permissions',
      ),
      (
        Icons.tune_outlined,
        const Color(0xFFFFF1E0),
        const Color(0xFFD97706),
        'Preference',
        'Customize your experience',
      ),
      (
        Icons.support_agent_outlined,
        const Color(0xFFE0F7F5),
        const Color(0xFF0D9488),
        'Support Center',
        'Help, FAQs, contact us',
      ),
    ];

    return _card(
      child: Column(
        children: List.generate(items.length, (i) {
          final (icon, iconBg, iconColor, title, subtitle) = items[i];
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 17, color: iconColor),
                ),
                title: Text(title, style: AppTextStyles.fieldLabel),
                subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.hintText,
                ),
                onTap: () {
                  if (title == 'Messages') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MessagesScreen()),
                    );
                  } else if (title == 'Notifications') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  }
                },
              ),
              if (i != items.length - 1)
                const Divider(height: 1, color: AppColors.border),
            ],
          );
        }),
      ),
    );
  }

  // ---------- Logout ----------

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
      label: const Text(
        'Log Out',
        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.error),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }

  // ---------- Shared helpers ----------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}

/// Paints a light dashed ring — the decorative circle behind the avatar.
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  const _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    const dashCount = 28;
    const dashSweep = 6.0; // degrees drawn
    const gapSweep = 360 / dashCount - dashSweep;

    double angle = 0;
    for (int i = 0; i < dashCount; i++) {
      final startAngle = angle * 3.1415926535 / 180;
      final sweepAngle = dashSweep * 3.1415926535 / 180;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      angle += dashSweep + gapSweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
