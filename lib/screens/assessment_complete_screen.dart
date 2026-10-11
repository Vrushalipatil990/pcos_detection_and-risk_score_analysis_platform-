
import 'package:flutter/material.dart';
import 'assessment_result_screen.dart';

const Color completePink = Color(0xFFD94F7A);
const Color completeGreen = Color(0xFF369B83);
const Color completeDark = Color(0xFF30232A);
const Color completeBackground = Color(0xFFFFF7F9);

class AssessmentCompleteScreen extends StatelessWidget {
  const AssessmentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: completeBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // SUCCESS ILLUSTRATION
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE6ED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: completePink,
                  size: 78,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'You did it!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: completeDark,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your assessment is complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: completeGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Thank you for taking the time to understand '
                'your health. Your answers can help us prepare '
                'personalized health insights and lifestyle guidance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF655960),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 28),

              // WHAT HAPPENS NEXT
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFF5DCE5),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What happens next?',
                      style: TextStyle(
                        color: completeDark,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 18),
                    _NextStepRow(
                      icon: Icons.insights_rounded,
                      title: 'Understand your results',
                      description:
                          'Review your personalized assessment summary.',
                    ),
                    SizedBox(height: 18),
                    _NextStepRow(
                      icon: Icons.spa_outlined,
                      title: 'Explore lifestyle guidance',
                      description:
                          'Discover practical habits for everyday wellness.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // RESULTS BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AssessmentResultScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: completePink,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View My Results',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: completeGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your health journey continues, one step at a time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF897B83),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextStepRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _NextStepRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F5EF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: completeGreen,
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
                  color: completeDark,
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
    );
  }
}
