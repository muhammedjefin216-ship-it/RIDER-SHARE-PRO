// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../providers/auth_provider.dart';
// import 'reset_password_screen.dart';

// class VerifyForgotOtpScreen extends ConsumerStatefulWidget {
//   final String email;

//   const VerifyForgotOtpScreen({super.key, required this.email});

//   @override
//   ConsumerState<VerifyForgotOtpScreen> createState() =>
//       _VerifyForgotOtpScreenState();
// }

// class _VerifyForgotOtpScreenState
//     extends ConsumerState<VerifyForgotOtpScreen> {
//   final otpController = TextEditingController();

//   @override
//   void dispose() {
//     otpController.dispose();
//     super.dispose();
//   }

//   Future<void> verifyOtp() async {
//     final otp = otpController.text.trim();

//     if (otp.length != 6) {
//       showMessage('Please enter a valid 6-digit OTP');
//       return;
//     }

//     final result = await ref
//         .read(authProvider.notifier)
//         .verifyForgotOtp(email: widget.email, otp: otp);

//     if (!mounted) return;

//     if (result['success'] == true) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResetPasswordScreen(email: widget.email),
//         ),
//       );
//     } else {
//       showMessage(result['message'] ?? 'Invalid OTP');
//     }
//   }

//   Future<void> resendOtp() async {
//     final result =
//         await ref.read(authProvider.notifier).forgotPassword(email: widget.email);

//     if (!mounted) return;

//     showMessage(
//       result['success'] == true
//           ? 'New OTP sent to your email'
//           : result['message'] ?? 'Unable to resend OTP',
//       isError: result['success'] != true,
//     );
//   }

//   void showMessage(String message, {bool isError = true}) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: isError ? Colors.red : const Color(0xff16A34A),
//         ),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);

//     return Scaffold(
//       backgroundColor: const Color(0xffF7F8FC),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Verify OTP',
//           style: TextStyle(color: Color(0xff111827)),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             const SizedBox(height: 24),

//             Container(
//               height: 80,
//               width: 80,
//               decoration: const BoxDecoration(
//                 color: Color(0xffE8F5E9),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.mark_email_read_outlined,
//                 size: 40,
//                 color: Color(0xff16A34A),
//               ),
//             ),

//             const SizedBox(height: 24),

//             const Text(
//               'Enter OTP',
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
//             ),

//             const SizedBox(height: 10),

//             const Text(
//               'Enter the 6-digit code sent to',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Color(0xff6B7280)),
//             ),

//             const SizedBox(height: 6),

//             Text(
//               widget.email,
//               style: const TextStyle(
//                 color: Color(0xff16A34A),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const SizedBox(height: 35),

//             TextField(
//               controller: otpController,
//               keyboardType: TextInputType.number,
//               maxLength: 6,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 8,
//               ),
//               decoration: InputDecoration(
//                 hintText: '••••••',
//                 counterText: '',
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed:
//                     authState.isVerifyingForgotOtp ? null : verifyOtp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff16A34A),
//                   foregroundColor: Colors.white,
//                 ),
//                 child: authState.isVerifyingForgotOtp
//                     ? const SizedBox(
//                         height: 22,
//                         width: 22,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text('Verify OTP'),
//               ),
//             ),

//             const SizedBox(height: 20),

//             TextButton(
//               onPressed: resendOtp,
//               child: const Text(
//                 'Resend OTP',
//                 style: TextStyle(
//                   color: Color(0xff16A34A),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }