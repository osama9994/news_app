// 'import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
// import 'package:news_app/core/utils/route/app_routes.dart';

// class VerifyEmailPage extends StatefulWidget {
//   const VerifyEmailPage({super.key});

//   @override
//   State<VerifyEmailPage> createState() => _VerifyEmailPageState();
// }

// class _VerifyEmailPageState extends State<VerifyEmailPage> {
//   Timer? _cooldownTimer;
//   int _secondsLeft = 0;

//   String get _email => FirebaseAuth.instance.currentUser?.email ?? '';

//   void _startCooldown() {
//     setState(() => _secondsLeft = 30);
//     _cooldownTimer?.cancel();
//     _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_secondsLeft <= 1) {
//         timer.cancel();
//         setState(() => _secondsLeft = 0);
//       } else {
//         setState(() => _secondsLeft--);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _cooldownTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthCubit, AuthState>(
//       listenWhen: (_, c) => c is AuthDone || c is AuthError,
//       listener: (context, state) {
//         if (state is AuthDone) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             AppRoutes.onboarding,
//             (route) => false,
//           );
//         } else if (state is AuthError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       builder: (context, state) {
//         final isLoading = state is AuthLoading;

//         return Scaffold(
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.mark_email_unread_outlined,
//                     size: 90,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Check your inbox (in Spam)',
//                     style: Theme.of(context).textTheme.headlineSmall
//                         ?.copyWith(fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     'We sent a verification link to\n$_email\nPlease click it to activate your account.',
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 40),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: isLoading
//                           ? null
//                           : () => context.read<AuthCubit>().checkEmailVerified(),
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Text("I've verified — continue"),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton(
//                     onPressed: (_secondsLeft > 0 || isLoading)
//                         ? null
//                         : () {
//                             context.read<AuthCubit>().resendVerificationEmail();
//                             _startCooldown();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Verification email sent.')),
//                             );
//                           },
//                     child: Text(
//                       _secondsLeft > 0 ? 'Resend email ($_secondsLeft s)' : 'Resend email',
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   TextButton(
//                     onPressed: isLoading
//                         ? null
//                         : () async {
//                             await FirebaseAuth.instance.signOut();
//                             Navigator.pushNamedAndRemoveUntil(
//                               // ignore: use_build_context_synchronously
//                               context,
//                               AppRoutes.loginRoute,
//                               (route) => false,
//                             );
//                           },
//                     child: const Text('Use a different account'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/route/app_routes.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, this.successRoute = AppRoutes.home});
final String successRoute;
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _cooldownTimer;
  int _secondsLeft = 0;

  String get _email => FirebaseAuth.instance.currentUser?.email ?? '';

  void _startCooldown() {
    setState(() => _secondsLeft = 30);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, c) => c is AuthDone || c is AuthError,
      listener: (context, state) {
       if (state is AuthDone) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    widget.successRoute,
    (route) => false,
  );
} else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 90,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    tr.text('checkYourInboxTitle'),
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr.text('verificationEmailSentTo').replaceFirst('{email}', _email),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => context.read<AuthCubit>().checkEmailVerified(),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(tr.text('verifiedContinue')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: (_secondsLeft > 0 || isLoading)
                        ? null
                        : () {
                            context.read<AuthCubit>().resendVerificationEmail();
                            _startCooldown();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(tr.text('verificationEmailSent'))),
                            );
                          },
                    child: Text(
                      _secondsLeft > 0
                          ? tr.text('resendEmailCooldown').replaceFirst('{seconds}', '$_secondsLeft')
                          : tr.text('resendEmail'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await FirebaseAuth.instance.signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              AppRoutes.loginRoute,
                              (route) => false,
                            );
                          },
                    child: Text(tr.text('useDifferentAccount')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}