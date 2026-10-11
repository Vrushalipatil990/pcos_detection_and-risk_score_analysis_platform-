  
import 'package:flutter/material.dart';

const Color resultPink = Color(0xFFD94F7A);
const Color resultGreen = Color(0xFF369B83);
const Color resultDark = Color(0xFF30232A);
const Color resultBackground = Color(0xFFFFF7F9);

class AssessmentResultScreen extends StatelessWidget {
  const AssessmentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: resultBackground,
      appBar: AppBar(
        backgroundColor: resultBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: resultDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Results',
          style: TextStyle(
            color: resultDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: resultPink,
                      size: 42,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Your health summary',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: resultDark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Thank you for completing your assessment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF756870),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // PROTOTYPE NOTICE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF2D5A4),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF9B6A22),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Preview screen: your actual assessment '
                        'results will appear here after the prediction '
                        'logic is connected.',
                        style: TextStyle(
                          color: Color(0xFF78531D),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // RESULTS OVERVIEW
              const Text(
                'Assessment overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: resultDark,
                ),
              ),

              const SizedBox(height: 14),

              _ResultInfoCard(
                icon: Icons.check_circle_outline_rounded,
                title: 'Questionnaire completed',
                description:
                    'Your answers have been collected for review.',
                iconColor: resultGreen,
                iconBackground: const Color(0xFFE5F5EF),
              ),

              const SizedBox(height: 12),

              _ResultInfoCard(
                icon: Icons.insights_rounded,
                title: 'Risk assessment',
                description:
                    'A risk category will appear once your '
                    'validated assessment logic is connected.',
                iconColor: resultPink,
                iconBackground: const Color(0xFFFCE6ED),
              ),

              const SizedBox(height: 24),

              // LIFESTYLE GUIDANCE
              const Text(
                'Your wellness journey',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: resultDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'You can use these areas to start building '
                'healthy habits while you learn more about your health.',
                style: TextStyle(
                  color: Color(0xFF756870),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              const _WellnessCard(
                icon: Icons.restaurant_menu_rounded,
                title: 'Balanced nutrition',
                description:
                    'Explore balanced meals and a varied diet '
                    'that suits your needs.',
              ),

              const SizedBox(height: 12),

              const _WellnessCard(
                icon: Icons.directions_walk_rounded,
                title: 'Daily movement',
                description:
                    'Choose physical activities that feel '
                    'comfortable and sustainable.',
              ),

              const SizedBox(height: 12),

              const _WellnessCard(
                icon: Icons.nights_stay_outlined,
                title: 'Sleep and stress',
                description:
                    'Build a regular sleep routine and make '
                    'time for relaxation.',
              ),

              const SizedBox(height: 24),

              // MEDICAL DISCLAIMER
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5EF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      color: resultGreen,
                      size: 23,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This assessment is intended for informational '
                        'purposes only and cannot diagnose PCOS. '
                        'Please consult a qualified healthcare '
                        'professional about symptoms or concerns.',
                        style: TextStyle(
                          color: Color(0xFF345D4B),
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // RETURN BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: resultPink,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color iconBackground;

  const _ResultInfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFF2E1E7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: resultDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF756870),
                    fontSize: 12,
                    height: 1.5,
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

class _WellnessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _WellnessCard({
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
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFF2E1E7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F5EF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: resultGreen,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: resultDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF756870),
                    fontSize: 12,
                    height: 1.5,
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
