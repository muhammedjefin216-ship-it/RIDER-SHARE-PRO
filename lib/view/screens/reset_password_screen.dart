// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../providers/auth_provider.dart';
// import 'login_screen.dart';

// class ResetPasswordScreen extends ConsumerStatefulWidget {
//   final String email;

//   const ResetPasswordScreen({super.key, required this.email});

//   @override
//   ConsumerState<ResetPasswordScreen> createState() =>
//       _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
//   final passwordController = TextEditingController();
//   final confirmController = TextEditingController();

//   bool obscure1 = true;
//   bool obscure2 = true;

//   @override
//   void dispose() {
//     passwordController.dispose();
//     confirmController.dispose();
//     super.dispose();
//   }

//   Future<void> resetPassword() async {
//     final password = passwordController.text.trim();
//     final confirm = confirmController.text.trim();

//     if (password.isEmpty || confirm.isEmpty) {
//       showMessage('Please fill both fields');
//       return;
//     }

//     if (password.length < 6) {
//       showMessage('Password must be at least 6 characters');
//       return;
//     }

//     if (password != confirm) {
//       showMessage('Passwords do not match');
//       return;
//     }

//     final result = await ref.read(authProvider.notifier).resetPassword(
//           email: widget.email,
//           newPassword: password,
//         );

//     if (!mounted) return;

//     if (result['success'] == true) {
//       showMessage(
//         result['message'] ?? 'Password reset successfully',
//         isError: false,
//       );

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//         (route) => false,
//       );
//     } else {
//       showMessage(result['message'] ?? 'Unable to reset password');
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
//           'Reset Password',
//           style: TextStyle(color: Color(0xff111827)),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 12),

//             const Text(
//               'Set a new password',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
//             ),

//             const SizedBox(height: 8),

//             const Text(
//               'Your new password must be different from previous passwords.',
//               style: TextStyle(color: Color(0xff6B7280), fontSize: 14),
//             ),

//             const SizedBox(height: 28),

//             const Text(
//               'NEW PASSWORD',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff6B7280),
//                 letterSpacing: 0.8,
//               ),
//             ),

//             const SizedBox(height: 8),

//             TextField(
//               controller: passwordController,
//               obscureText: obscure1,
//               decoration: InputDecoration(
//                 hintText: 'Enter new password',
//                 prefixIcon: const Icon(Icons.lock_outline_rounded,
//                     size: 21, color: Color(0xff9CA3AF)),
//                 suffixIcon: IconButton(
//                   onPressed: () => setState(() => obscure1 = !obscure1),
//                   icon: Icon(
//                     obscure1
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     color: const Color(0xff9CA3AF),
//                   ),
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

//             const SizedBox(height: 20),

//             const Text(
//               'CONFIRM PASSWORD',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff6B7280),
//                 letterSpacing: 0.8,
//               ),
//             ),

//             const SizedBox(height: 8),

//             TextField(
//               controller: confirmController,
//               obscureText: obscure2,
//               decoration: InputDecoration(
//                 hintText: 'Re-enter new password',
//                 prefixIcon: const Icon(Icons.lock_outline_rounded,
//                     size: 21, color: Color(0xff9CA3AF)),
//                 suffixIcon: IconButton(
//                   onPressed: () => setState(() => obscure2 = !obscure2),
//                   icon: Icon(
//                     obscure2
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     color: const Color(0xff9CA3AF),
//                   ),
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
//                 onPressed:
//                     authState.isResettingPassword ? null : resetPassword,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff16A34A),
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: authState.isResettingPassword
//                     ? const SizedBox(
//                         height: 22,
//                         width: 22,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         'Reset Password',
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