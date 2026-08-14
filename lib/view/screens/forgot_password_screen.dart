// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ridesharepro/screens/verify_forgot_password_screen.dart';
// import '../providers/auth_provider.dart';

// class ForgotPasswordScreen extends ConsumerStatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   ConsumerState<ForgotPasswordScreen> createState() =>
//       _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
//   final emailController = TextEditingController();

//   @override
//   void dispose() {
//     emailController.dispose();
//     super.dispose();
//   }

//   Future<void> sendOtp() async {
//     final email = emailController.text.trim();

//     if (email.isEmpty) {
//       showMessage('Please enter your email');
//       return;
//     }

//     final result =
//         await ref.read(authProvider.notifier).forgotPassword(email: email);

//     if (!mounted) return;

//     if (result['success'] == true) {
//       showMessage(result['message'] ?? 'OTP sent', isError: false);

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => VerifyForgotOtpScreen(email: email),
//         ),
//       );
//     } else {
//       showMessage(result['message'] ?? 'Unable to send OTP');
//     }
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
//           'Forgot Password',
//           style: TextStyle(color: Color(0xff111827)),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 12),

//             Container(
//               height: 72,
//               width: 72,
//               decoration: const BoxDecoration(
//                 color: Color(0xffE8F5E9),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.lock_reset_outlined,
//                 size: 36,
//                 color: Color(0xff16A34A),
//               ),
//             ),

//             const SizedBox(height: 24),

//             const Text(
//               'Reset your password',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xff111827),
//               ),
//             ),

//             const SizedBox(height: 8),

//             const Text(
//               "Enter your account's email and we'll send you an OTP to reset your password.",
//               style: TextStyle(color: Color(0xff6B7280), fontSize: 14),
//             ),

//             const SizedBox(height: 28),

//             const Text(
//               'EMAIL',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff6B7280),
//                 letterSpacing: 0.8,
//               ),
//             ),

//             const SizedBox(height: 8),

//             TextField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 hintText: 'you@example.com',
//                 prefixIcon: const Icon(
//                   Icons.email_outlined,
//                   size: 21,
//                   color: Color(0xff9CA3AF),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: Color(0xffE5E7EB)),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 28),

//             SizedBox(
//               width: double.infinity,
//               height: 54,
//               child: ElevatedButton(
//                 onPressed: authState.isSendingForgotOtp ? null : sendOtp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff16A34A),
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: authState.isSendingForgotOtp
//                     ? const SizedBox(
//                         height: 22,
//                         width: 22,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         'Send OTP',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }