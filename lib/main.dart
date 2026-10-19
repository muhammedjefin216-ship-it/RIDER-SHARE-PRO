import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ridesharepro/core/constants/stripe_constants.dart';
import 'package:ridesharepro/view/home/home_screen.dart';
import 'providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeConstants.publishableKey;
  await Stripe.instance.applySettings();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SessionGate());
  }
}

class SessionGate extends ConsumerStatefulWidget {
  const SessionGate({super.key});

  @override
  ConsumerState<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends ConsumerState<SessionGate> {
  bool _checked = false;
  bool _hasSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    final hasSession = await ref.read(authProvider.notifier).checkSession();

    if (!mounted) return;

    setState(() {
      _hasSession = hasSession;
      _checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return Scaffold(
        backgroundColor: Color(0xffF7F8FC),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xff16A34A)),
        ),
      );
    }

  //  return _hasSession ? HomeScreen() : LoginScreen();
   return HomeScreen();
  }
}