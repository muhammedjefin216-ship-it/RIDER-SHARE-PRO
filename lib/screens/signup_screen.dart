import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'otp_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends ConsumerState<SignupScreen> {

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

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

  // ==========================================================
  // REGISTER
  // ==========================================================

  Future<void> register() async {
    final name =
        nameController.text.trim();

    final phone =
        phoneController.text.trim();

    final email =
        emailController.text.trim();

    final password =
        passwordController.text.trim();

    final confirmPassword =
        confirmPasswordController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage(
        'Please fill all fields',
      );

      return;
    }

    if (password != confirmPassword) {
      showMessage(
        'Passwords do not match',
      );

      return;
    }

    final success =
        await ref
            .read(authProvider.notifier)
            .register(
              name: name,
              phone: phone,
              email: email,
              gender: selectedGender,
              password: password,
            );

    if (!mounted) return;

    final authState =
        ref.read(authProvider);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpScreen(
            email: email,
          ),
        ),
      );
    } else {
      showMessage(
        authState.errorMessage ??
            'Registration failed',
      );
    }
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final authState =
        ref.watch(authProvider);

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Color(0xff111827),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Join RideSharePro',
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Create your account to start your journey.',
              style: TextStyle(
                color:
                    Color(0xff6B7280),
              ),
            ),

            const SizedBox(height: 32),

            // NAME

            const Text(
              'NAME',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller:
                  nameController,
              decoration:
                  inputDecoration(
                'Enter your name',
                Icons.person_outline,
              ),
            ),

            const SizedBox(height: 20),

            // PHONE

            const Text(
              'PHONE',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller:
                  phoneController,
              keyboardType:
                  TextInputType.phone,
              decoration:
                  inputDecoration(
                'Enter your phone',
                Icons.phone_outlined,
              ),
            ),

            const SizedBox(height: 20),

            // EMAIL

            const Text(
              'EMAIL',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller:
                  emailController,
              keyboardType:
                  TextInputType.emailAddress,
              decoration:
                  inputDecoration(
                'Enter your email',
                Icons.email_outlined,
              ),
            ),

            const SizedBox(height: 20),

            // GENDER

            const Text(
              'GENDER',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedGender,

              decoration:
                  inputDecoration(
                'Select gender',
                Icons.person_outline,
              ),

              items: const [
                DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                ),
                DropdownMenuItem(
                  value: 'Other',
                  child: Text('Other'),
                ),
              ],

              onChanged:
                  (value) {
                if (value != null) {
                  setState(() {
                    selectedGender =
                        value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // PASSWORD

            const Text(
              'PASSWORD',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller:
                  passwordController,
              obscureText:
                  obscurePassword,

              decoration:
                  inputDecoration(
                'Enter your password',
                Icons.lock_outline,
              ).copyWith(
                suffixIcon:
                    IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons
                            .visibility_outlined
                        : Icons
                            .visibility_off_outlined,
                  ),

                  onPressed: () {
                    setState(() {
                      obscurePassword =
                          !obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CONFIRM PASSWORD

            const Text(
              'CONFIRM PASSWORD',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller:
                  confirmPasswordController,
              obscureText:
                  obscureConfirmPassword,

              decoration:
                  inputDecoration(
                'Re-enter your password',
                Icons.lock_outline,
              ).copyWith(
                suffixIcon:
                    IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons
                            .visibility_outlined
                        : Icons
                            .visibility_off_outlined,
                  ),

                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword =
                          !obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // REGISTER BUTTON

            SizedBox(
              width:
                  double.infinity,
              height: 54,

              child:
                  ElevatedButton(
                onPressed:
                    authState.isRegistering
                        ? null
                        : register,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                          0xff16A34A),
                  foregroundColor:
                      Colors.white,
                ),

                child:
                    authState.isRegistering
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child:
                                CircularProgressIndicator(
                              color:
                                  Colors.white,
                              strokeWidth:
                                  2,
                            ),
                          )
                        : const Text(
                            'Create Account',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,

      prefixIcon:
          Icon(icon),

      filled: true,

      fillColor:
          Colors.white,

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide:
            const BorderSide(
          color:
              Color(0xffE5E7EB),
        ),
      ),
    );
  }
}