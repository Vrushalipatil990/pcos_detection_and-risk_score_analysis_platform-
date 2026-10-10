
import 'package:flutter/material.dart';

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk_sdk;

class EmailVerificationScreen extends StatefulWidget {
 final String email;
final bool isLogin;

const EmailVerificationScreen({
  super.key,
  required this.email,
  this.isLogin = false,
});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends State<EmailVerificationScreen> {
  final TextEditingController _codeController =
      TextEditingController();

  bool _isLoading = false;
  

  static const Color darkGreen = Color(0xFF426B59);
  static const Color pink = Color(0xFFE88BA8);
  static const Color background = Color(0xFFFFFBF8);

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }


Future<void> _verifyCode() async {
  final code = _codeController.text.trim();

  if (code.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter the verification code'),
      ),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final clerk = ClerkAuth.of(context);

    if (widget.isLogin) {
      await clerk.attemptSignIn(
        strategy: clerk_sdk.Strategy.emailCode,
        code: code,
      );
    } else {
      await clerk.attemptSignUp(
        strategy: clerk_sdk.Strategy.emailCode,
        code: code,
      );
    }

    if (!mounted) return;

    if (clerk.user != null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isLogin
                ? 'Login verification is not complete. Please check the code.'
                : 'Signup verification is not complete. Please check the code.',
          ),
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification failed: $e')),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Code resending will be connected to Clerk next.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkGreen),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),

              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE5ED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 45,
                  color: pink,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'We have sent a verification code to your email address.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: pink,
                ),
              ),

              const SizedBox(height: 35),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter verification code',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Enter your verification code',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFD9C5CC),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: pink,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Verify Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: _resendCode,
                    child: const Text(
                      'Resend code',
                      style: TextStyle(
                        color: pink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                'Your account will be ready after verification.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
