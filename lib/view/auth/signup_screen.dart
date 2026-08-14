import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharepro/view/auth/otp_screen.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/top_nav_bar.dart';
import '../../widgets/common/hero_banner.dart';
import '../../widgets/common/feature_strip.dart';
import '../../widgets/common/info_highlight_card.dart';
import '../../widgets/common/community_banner.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/inputs/gender_selector.dart';
import '../../widgets/inputs/country_code_prefix.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/text_link_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String selectedGender = 'Male';

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .register(
          name: name,
          phone: phone,
          email: email,
          gender: selectedGender,
          password: password,
        );

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(email: email)),
      );
    } else {
      showMessage(authState.errorMessage ?? 'Registration failed');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: TopNavBar(
                  actionLabel: 'Sign in',
                  actionTrailingIcon: Icons.arrow_forward_rounded,
                  onActionPressed: () => Navigator.pop(context),
                ),
              ),

              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  HeroBanner(
                    icon: Icons.person_add_alt_1_rounded,
                    accentWord: 'Start',
                    restOfTitle: ' your carpooling\njourney today',
                    subtitle:
                        'Join thousands of smart commuters saving\nmoney and reducing carbon emissions\nevery day.',
                  ),
                  Positioned(
                    bottom: -32,
                    left: 20,
                    right: 20,
                    child: FeatureStrip(
                      items: [
                        FeatureStripItem(
                          icon: Icons.psychology_outlined,
                          label: 'Smart AI',
                        ),
                        FeatureStripItem(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Escrow',
                        ),
                        FeatureStripItem(
                          icon: Icons.emergency_outlined,
                          label: '24/7 SOS',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 52),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoHighlightCard(
                      icon: Icons.attach_money_rounded,
                      title: 'Earn While You Drive',
                      subtitle:
                          'Got an empty seat? Turn it into cash by sharing your route.',
                    ),

                    SizedBox(height: 20),

                    AppTextField(
                      label: 'Full Name',
                      hint: 'John Doe',
                      controller: nameController,
                      prefixIcon: Icons.person_outline,
                    ),

                    SizedBox(height: 16),

                    AppTextField(
                      label: 'Phone Number',
                      hint: '98765 43210',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      customPrefix: CountryCodePrefix(),
                    ),

                    SizedBox(height: 16),

                    AppTextField(
                      label: 'Email Address',
                      hint: 'john@example.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),

                    SizedBox(height: 16),

                    Text(
                      'Gender',
                      style: TextStyle(
                        color: AppColors.textLabel,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    GenderSelector(
                      selectedValue: selectedGender,
                      onChanged: (gender) {
                        setState(() {
                          selectedGender = gender;
                        });
                      },
                    ),

                    SizedBox(height: 16),

                    AppTextField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: passwordController,
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    AppTextField(
                      label: 'Confirm Password',
                      hint: '••••••••',
                      controller: confirmPasswordController,
                      prefixIcon: Icons.rotate_left_rounded,
                      obscureText: obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 28),

                    PrimaryButton(
                      label: 'Create account',
                      trailingIcon: Icons.arrow_forward_rounded,
                      isLoading: authState.isRegistering,
                      onPressed: register,
                    ),

                    SizedBox(height: 20),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Existing account? ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          TextLinkButton(
                            label: 'Sign in',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28),

                    CommunityBanner(),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
