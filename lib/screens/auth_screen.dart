import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk_sdk;


import 'package:flutter/material.dart';
import 'email_verification_screen.dart';



const Color pink = Color(0xFFE88BA8);
const Color darkPink = Color(0xFFD96F91);
const Color green = Color(0xFF6F9F8A);
const Color darkGreen = Color(0xFF426B59);
const Color background = Color(0xFFFFFBF8);
const Color softPink = Color(0xFFFFEEF3);
const Color softGreen = Color(0xFFEAF4EF);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: background,
        foregroundColor: darkGreen,
      ),

      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 35),

            // Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text;

                  // Check email
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your email'),
                      ),
                    );
                    return;
                  }

                  final emailRegex = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  );

                  if (!emailRegex.hasMatch(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid email address',
                        ),
                      ),
                    );
                    return;
                  }

                  // Check password
                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your password'),
                      ),
                    );
                    return;
                  }

try {
  final clerk = ClerkAuth.of(context);

  debugPrint('PCOSense: Starting login...');

  await clerk.attemptSignIn(
  strategy: clerk_sdk.Strategy.password,
  identifier: email.trim(),
  password: password,
);

debugPrint('PCOSense: Sign-in request completed.');
debugPrint('PCOSense: User after login = ${clerk.user}');
  debugPrint('PCOSense: User after login = ${clerk.user}');
  debugPrint('Sign-in object: ${clerk.client.signIn}');
debugPrint('Current user: ${clerk.user}');
final signIn = clerk.client.signIn;

if (!context.mounted) return;

if (signIn?.needsSecondFactor == true) {
  await clerk.attemptSignIn(
    strategy: clerk_sdk.Strategy.emailCode,
  );

  if (!context.mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EmailVerificationScreen(
        email: email.trim(),
        isLogin: true,
      ),
    ),
  );
  return;
}

debugPrint('PCOSense: Sign-in status = ${signIn?.status}');
debugPrint('PCOSense: Needs first factor = ${signIn?.needsFirstFactor}');
debugPrint('PCOSense: Needs second factor = ${signIn?.needsSecondFactor}');
debugPrint(
  'PCOSense: First factor verification = ${signIn?.firstFactorVerification}',
);
  if (!context.mounted) return;

  if (clerk.user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Sign-in did not establish a session. Check the terminal.',
        ),
      ),
    );
  }
} catch (e, stackTrace) {
  debugPrint('PCOSense: LOGIN ERROR: $e');
  debugPrint('PCOSense: STACK TRACE: $stackTrace');

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Login failed: $e'),
    ),
  );
}
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: const Text('Log In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// SIGN UP SCREEN
// ------------------------------------------------------------

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: background,
        foregroundColor: darkGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'Create Your Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: fullNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 16),

TextField(
  controller: passwordController,
  obscureText: !_isPasswordVisible,
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: const Icon(Icons.lock_outline),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    suffixIcon: IconButton(
      icon: Icon(
        _isPasswordVisible
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    ),
  ),
),

const SizedBox(height: 16),

const SizedBox(height: 16),

TextField(
  controller: confirmPasswordController,
  obscureText: !_isConfirmPasswordVisible,
  decoration: InputDecoration(
    labelText: 'Confirm Password',
    prefixIcon: const Icon(Icons.lock_outline),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    suffixIcon: IconButton(
      icon: Icon(
        _isConfirmPasswordVisible
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          _isConfirmPasswordVisible =
              !_isConfirmPasswordVisible;
        });
      },
    ),
  ),
),

const SizedBox(height: 25),


            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
  final fullName = fullNameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;

  // Full name validation
  if (fullName.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please enter your full name'),
    ),
  );
  return;
}

final nameRegex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');

if (!nameRegex.hasMatch(fullName)) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Please enter a valid name using letters only',
      ),
    ),
  );
  return;
}
  // Email validation
  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your email'),
      ),
    );
    return;
  }

  final emailRegex = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  if (!emailRegex.hasMatch(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid email address'),
      ),
    );
    return;
  }

  // Password validation
  if (password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a password'),
      ),
    );
    return;
  }

  if (password.length < 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password must be at least 8 characters'),
      ),
    );
    return;
  }

  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password must contain at least one uppercase letter',
        ),
      ),
    );
    return;
  }

  if (!RegExp(r'[a-z]').hasMatch(password)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password must contain at least one lowercase letter',
        ),
      ),
    );
    return;
  }

  if (!RegExp(r'[0-9]').hasMatch(password)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password must contain at least one number',
        ),
      ),
    );
    return;
  }

  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password must contain at least one special character',
        ),
      ),
    );
    return;
  }
final confirmPassword = confirmPasswordController.text;

if (confirmPassword.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please confirm your password'),
    ),
  );
  return;
}

if (password != confirmPassword) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Passwords do not match'),
    ),
  );
  return;
}

  if (!context.mounted) return;

// Create the Clerk account
try {
  final clerk = ClerkAuth.of(context);

  await clerk.safelyCall(
    context,
    () => clerk.attemptSignUp(
      strategy: clerk_sdk.Strategy.password,
      firstName: fullName.split(' ').first,
      lastName: fullName.split(' ').length > 1
          ? fullName.split(' ').skip(1).join(' ')
          : null,
      emailAddress: email,
      password: password,
      passwordConfirmation: confirmPassword,
    ),
  );

  if (!context.mounted) return;

  final auth = ClerkAuth.of(context);

  if (auth.client.signUp != null && auth.user == null) {
    await auth.safelyCall(
      context,
      () => auth.attemptSignUp(
        strategy: clerk_sdk.Strategy.emailCode,
      ),
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmailVerificationScreen(email: email),
      ),
    );
  }
} catch (e) {
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Signup failed: $e')),
  );
}
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
