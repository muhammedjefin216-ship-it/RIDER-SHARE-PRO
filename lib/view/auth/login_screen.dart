import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ridesharepro/view/home/home_screen.dart';
import 'package:ridesharepro/view/auth/otp_screen.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/brand_logo.dart';
import '../../widgets/common/two_tone_title.dart';
import '../../widgets/common/trust_badge_card.dart';
import '../../widgets/common/or_divider.dart';
import '../../widgets/common/decorative_blob_background.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/text_link_button.dart';
import '../../widgets/buttons/social_login_button.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter email and password');
      return;
    }

    final result = await ref
        .read(authProvider.notifier)
        .login(email: email, password: password, rememberMe: rememberMe);

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else if (result['requiresVerification'] == true) {
      showMessage(result['message'] ?? 'Please verify your email first');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(email: result['email'] ?? email),
        ),
      );
    } else {
      showMessage(result['message'] ?? 'Login failed');
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      print('STEP 1: Google Sign-In started');

      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId:
            '192079311703-f80kvg0i1qo80bidnl3o4g2vidug6tlh.apps.googleusercontent.com',
      );

      print('STEP 2: Google Sign-In initialized');

      final GoogleSignInAccount account = await googleSignIn.authenticate();

      print('STEP 3: Google account received: ${account.email}');

      final GoogleSignInAuthentication auth = account.authentication;
      final idToken = auth.idToken;

      print('STEP 4: ID Token obtained');

      if (idToken == null) {
        showMessage('Could not get Google ID token');
        return;
      }

      print('STEP 5: Calling MERN backend');

      final result = await ref
          .read(authProvider.notifier)
          .googleAuth(idToken: idToken);

      print('STEP 6: Backend response: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
          (route) => false,
        );
      } else {
        showMessage(result['message'] ?? 'Google sign-in failed');
      }
    } catch (e, stackTrace) {
      print('GOOGLE SIGN-IN ERROR: $e');
      print('STACK TRACE: $stackTrace');

      if (!mounted) return;

      showMessage('Google sign-in error: $e');
    }
  }

  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.primaryNavy,
        ),
      );
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(child: DecorativeBlobBackground()),

          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingH,
                vertical: AppSpacing.screenPaddingV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandLogo(),
                  SizedBox(height: AppSpacing.xxl),
                  TwoToneTitle(
                    accentWord: 'Sign',
                    restOfTitle: ' in to your\naccount',
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Access your trips, messages, and earnings —\nall in one place.',
                    style: AppTextStyles.subtitle,
                  ),

                  SizedBox(height: AppSpacing.xl),

                  TrustBadgeCard(),

                  SizedBox(height: 28),

                  AppTextField(
                    label: 'Email Address',
                    hint: 'name@example.com',
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 18),

                  AppTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: passwordController,
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (!authState.isLoggingIn) login();
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: rememberMe,
                          activeColor: AppColors.primaryNavy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(color: AppColors.checkboxBorder),
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text('Remember me', style: AppTextStyles.bodySmall),
                      Spacer(),
                      TextLinkButton(
                        label: 'Forgot password?',
                        onPressed: () {},
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.xl),

                  PrimaryButton(
                    label: 'Sign In',
                    isLoading: authState.isLoggingIn,
                    onPressed: login,
                  ),

                  SizedBox(height: AppSpacing.xl),

                  OrDivider(),

                  SizedBox(height: 20),

                  SocialLoginButton(
                    label: 'Continue with Google',
                    icon: GoogleIcon(),
                    onPressed: handleGoogleSignIn,
                  ),

                  SizedBox(height: 28),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.bodySmall,
                        ),
                        TextLinkButton(
                          label: 'Create account',
                          onPressed: _goToSignup,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
