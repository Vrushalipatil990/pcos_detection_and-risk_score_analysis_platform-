import 'package:flutter/material.dart';
import '../services/auth_service.dart';

const Color pink = Color(0xFFE88BA8);
const Color darkPink = Color(0xFFD96F91);
const Color green = Color(0xFF6F9F8A);
const Color darkGreen = Color(0xFF426B59);
const Color background = Color(0xFFFFFBF8);
const Color softPink = Color(0xFFFFEEF3);
const Color softGreen = Color(0xFFEAF4EF);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  void nextPage() {
    if (currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: const [PageOne(), PageTwo(), PageThree(), PageFour()],
            ),

            // Page indicators
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? darkPink
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

            // Left arrow
            if (currentPage > 0)
              Positioned(
                left: 15,
                bottom: 15,
                child: _ArrowButton(
                  icon: Icons.arrow_back,
                  onPressed: previousPage,
                ),
              ),

            // Right arrow
            if (currentPage < 3)
              Positioned(
                right: 15,
                bottom: 15,
                child: _ArrowButton(
                  icon: Icons.arrow_forward,
                  onPressed: nextPage,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 1 — WHAT IS PCOS?
// ------------------------------------------------------------

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 35, 28, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LogoSmall(),

            const SizedBox(height: 30),

            const Text(
              'What is PCOS?',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Polycystic Ovary Syndrome (PCOS) is a common hormonal condition that can affect periods, hormones, metabolism and overall well-being.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 22),

            // Fact card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: softPink,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(Icons.favorite, color: darkPink, size: 35),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'PCOS affects about 1 in 10 women of reproductive age.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Woman image
            Center(
              child: Image.asset(
                'assets/images/woman.png',
                height: 240,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 240,
                    width: 220,
                    decoration: BoxDecoration(
                      color: softPink,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.person, size: 100, color: pink),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            const Center(
              child: Text(
                'Understanding your body is the first step toward better health.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 2 — SYMPTOMS
// ------------------------------------------------------------

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 35, 25, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LogoSmall(),

            const SizedBox(height: 25),

            const Text(
              'Common Symptoms',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'PCOS can affect different people in different ways.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 22),

            // TWO IMAGE AREAS
            Row(
              children: [
                Expanded(
                  child: _SymptomImageCard(
                    icon: Icons.calendar_month,
                    title: 'Irregular Periods',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _SymptomImageCard(
                    icon: Icons.face_retouching_natural,
                    title: 'Acne & Skin',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Symptoms grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.1,
              children: const [
                _SymptomCard(
                  icon: Icons.calendar_month,
                  title: 'Irregular periods',
                ),
                _SymptomCard(icon: Icons.face, title: 'Acne'),
                _SymptomCard(icon: Icons.content_cut, title: 'Hair growth'),
                _SymptomCard(
                  icon: Icons.monitor_weight,
                  title: 'Weight changes',
                ),
                _SymptomCard(icon: Icons.spa, title: 'Hair thinning'),
                _SymptomCard(
                  icon: Icons.favorite_border,
                  title: 'Mood changes',
                ),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: softGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: darkGreen, size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Recognizing patterns early can help you make informed health decisions.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: darkGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 3 — ABOUT PCOSENSE
// ------------------------------------------------------------

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(27, 35, 27, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LogoSmall(),

            const SizedBox(height: 30),

            const Text(
              'About PCOSense',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Your personalized AI-powered PCOS health companion.',
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            const _FeatureCard(
              icon: Icons.restaurant_menu,
              title: 'Personalized Nutrition',
              description: 'Get nutrition guidance based on your personal health information and needs.',
            ),

            const SizedBox(height: 14),

            const _FeatureCard(
              icon: Icons.calendar_today,
              title: 'Menstrual Tracking',
              description: 'Track your menstrual cycle and identify unusual patterns over time.',
            ),

            const SizedBox(height: 14),

            const _FeatureCard(
              icon: Icons.psychology,
              title: 'PCOS Risk Insights',
              description: 'Use machine learning to estimate PCOS risk and understand important factors.',
            ),

            const SizedBox(height: 14),

            const _FeatureCard(
              icon: Icons.description,
              title: 'Medical Report Analysis',
              description: 'Upload medical reports and extract relevant health parameters using OCR.',
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: softPink,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PCOSense is designed to support health awareness and informed decisions. It does not replace professional medical advice.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.5, color: darkGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PAGE 4 — GET STARTED
// ------------------------------------------------------------

class PageFour extends StatelessWidget {
  const PageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 45, 28, 90),
        child: Column(
          children: [
            const Text(
              'PCOSense',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: darkGreen,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Understand. Track. Take Control.',
              style: TextStyle(
                fontSize: 15,
                color: darkPink,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            Image.asset(
              'assets/images/uterus.png',
              height: 190,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 190,
                  width: 190,
                  decoration: BoxDecoration(
                    color: softPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, size: 90, color: pink),
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Your health journey starts here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 28),

            // LOGIN
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // SIGN UP
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: darkGreen,
                  side: const BorderSide(color: green, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'OR',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),

            const SizedBox(height: 18),

            const SocialButton(
              icon: Icons.g_mobiledata,
              text: 'Continue with Google',
            ),

            const SizedBox(height: 12),

            const SocialButton(icon: Icons.apple, text: 'Continue with Apple'),

            const SizedBox(height: 20),

            const Text(
              'By continuing, you agree to our Terms of Service and Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// LOGIN SCREEN
// ------------------------------------------------------------

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

            TextField(
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

            TextField(
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
                onPressed: () {},
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

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                  final result = await AuthService.signup(
                    fullName: fullNameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );

                   if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result['message'] ?? 'Something went wrong',
                      ),
                    ),
                  );
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
// ------------------------------------------------------------
// SMALL LOGO
// ------------------------------------------------------------

class _LogoSmall extends StatelessWidget {
  const _LogoSmall();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(color: softPink, shape: BoxShape.circle),
          child: const Icon(Icons.favorite, size: 19, color: darkPink),
        ),
        const SizedBox(width: 10),
        const Text(
          'PCOSense',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// ARROW BUTTON
// ------------------------------------------------------------

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Icon(icon, color: darkGreen, size: 20),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// SYMPTOM IMAGE CARD
// ------------------------------------------------------------

class _SymptomImageCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SymptomImageCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      decoration: BoxDecoration(
        color: softPink,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: darkPink),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// SYMPTOM CARD
// ------------------------------------------------------------

class _SymptomCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SymptomCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: green, size: 25),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// FEATURE CARD
// ------------------------------------------------------------

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: softGreen,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: darkGreen, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// SOCIAL BUTTON
// ------------------------------------------------------------

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const SocialButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black87),
        label: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
