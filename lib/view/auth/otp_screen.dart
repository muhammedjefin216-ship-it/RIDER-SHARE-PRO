import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharepro/view/home/home_screen.dart';

import '../../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      showMessage('Please enter a valid 6-digit OTP');

      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .verifyEmail(email: widget.email, otp: otp);

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      showMessage(authState.errorMessage ?? 'Invalid OTP');
    }
  }

  Future<void> resendOtp() async {
    final success = await ref
        .read(authProvider.notifier)
        .resendOtp(email: widget.email);

    if (!mounted) return;

    final authState = ref.read(authProvider);

    showMessage(
      success
          ? 'New OTP sent to your email'
          : authState.errorMessage ?? 'Unable to resend OTP',
      isError: !success,
    );
  }

  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Color(0xff16A34A),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text('Verify Email', style: TextStyle(color: Color(0xff111827))),
      ),

      body: Padding(
        padding: EdgeInsets.all(24),

        child: Column(
          children: [
            SizedBox(height: 40),

            Container(
              height: 80,
              width: 80,

              decoration: BoxDecoration(
                color: Color(0xffE8F5E9),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.mark_email_read_outlined,
                size: 40,
                color: Color(0xff16A34A),
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Verify your email',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 10),

            Text(
              'Enter the 6-digit OTP sent to',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff6B7280)),
            ),

            SizedBox(height: 6),

            Text(
              widget.email,
              style: TextStyle(
                color: Color(0xff16A34A),
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 35),

            TextField(
              controller: otpController,

              keyboardType: TextInputType.number,

              maxLength: 6,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 8,
              ),

              decoration: InputDecoration(
                hintText: '••••••',

                counterText: '',

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: authState.isVerifying ? null : verifyOtp,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff16A34A),
                  foregroundColor: Colors.white,
                ),

                child: authState.isVerifying
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('Verify Email'),
              ),
            ),

            SizedBox(height: 20),

            TextButton(
              onPressed: authState.isResending ? null : resendOtp,

              child: authState.isResending
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Color(0xff16A34A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
