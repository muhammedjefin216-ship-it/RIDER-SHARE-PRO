import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'otp_screen.dart';


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

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter email and password');
      return;
    }

    final result = await ref.read(authProvider.notifier).login(
          email: email,
          password: password,
        );

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else if (result['requiresVerification'] == true) {
      showMessage(
        result['message'] ?? 'Please verify your email first',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpScreen(email: result['email'] ?? email),
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

    print('STEP 2: GoogleSignIn instance created');

    await googleSignIn.initialize(
      serverClientId:
          '192079311703-f80kvg0i1qo80bidnl3o4g2vidug6tlh.apps.googleusercontent.com', 
    );

    print('STEP 3: Google Sign-In initialized');

    final account = await googleSignIn.authenticate();

    print('STEP 4: Google account received');

    final auth = account.authentication;

    print('STEP 5: Authentication received');

    final idToken = auth.idToken;

    print('STEP 6: ID Token: $idToken');

    if (idToken == null) {
      showMessage('Could not get Google ID token');
      return;
    }

    print('STEP 7: Calling MERN backend');

    final result = await ref
        .read(authProvider.notifier)
        .googleAuth(
          idToken: idToken,
        );

    print('STEP 8: Backend response: $result');

    if (!mounted) return;

    if (result['success'] == true) {
      print('STEP 9: Login successful');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      showMessage(
        result['message'] ?? 'Google sign-in failed',
      );
    }
  } catch (e, stackTrace) {
    print('GOOGLE SIGN-IN ERROR: $e');
    print('STACK TRACE: $stackTrace');

    if (!mounted) return;

    showMessage(
      'Google sign-in error: $e',
    );
  }
}
  // ==========================================================
  // MESSAGE
  // ==========================================================

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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xffE8F5E9),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.directions_car_rounded,
                              color: Color(0xff16A34A),
                              size: 24,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            'RideSharePro',
                            style: TextStyle(
                              color: Color(0xff111827),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 52),

                      const Text(
                        'Welcome back 👋',
                        style: TextStyle(
                          color: Color(0xff111827),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Sign in to continue your journey',
                        style: TextStyle(
                          color: Color(0xff6B7280),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 36),

                      const Text(
                        'EMAIL ADDRESS',
                        style: TextStyle(
                          color: Color(0xff6B7280),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,

                        decoration: InputDecoration(
                          hintText: 'you@example.com',

                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 21,
                            color: Color(0xff9CA3AF),
                          ),

                          hintStyle: const TextStyle(
                            color: Color(0xff9CA3AF),
                            fontSize: 14,
                          ),

                          filled: true,

                          fillColor: const Color(0xffF9FAFB),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xff16A34A),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'PASSWORD',
                        style: TextStyle(
                          color: Color(0xff6B7280),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (!authState.isLoggingIn) login();
                        },

                        decoration: InputDecoration(
                          hintText: 'Enter your password',

                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            size: 21,
                            color: Color(0xff9CA3AF),
                          ),

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

                              color: const Color(0xff9CA3AF),
                            ),
                          ),

                          hintStyle: const TextStyle(
                            color: Color(0xff9CA3AF),
                            fontSize: 14,
                          ),

                          filled: true,

                          fillColor: const Color(0xffF9FAFB),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xff16A34A),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: rememberMe,

                              activeColor: const Color(0xff16A34A),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),

                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 8),

                          const Text(
                            'Remember me',
                            style: TextStyle(
                              color: Color(0xff6B7280),
                              fontSize: 13,
                            ),
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () {},

                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),

                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Color(0xff16A34A),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 54,

                        child: ElevatedButton(
                          onPressed: authState.isLoggingIn ? null : login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff16A34A),

                            foregroundColor: Colors.white,

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: authState.isLoggingIn
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: Color(0xffE5E7EB)),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),

                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const Expanded(
                            child: Divider(color: Color(0xffE5E7EB)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: OutlinedButton(
                          onPressed: () {
                             handleGoogleSignIn();
                          },

                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,

                            side: const BorderSide(color: Color(0xffE5E7EB)),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              const Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xff4285F4),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(width: 10),

                              const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Color(0xff111827),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,

                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Color(0xff9CA3AF),
                                fontSize: 13,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },

                              child: const Text(
                                'Create account',
                                style: TextStyle(
                                  color: Color(0xff16A34A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

