
import 'package:flutter/material.dart';
import 'questionnaire_screen.dart';

const Color riskPink = Color(0xFFD94F7A);
const Color riskGreen = Color(0xFF369B83);
const Color riskDark = Color(0xFF30232A);
const Color riskBackground = Color(0xFFFFF7F9);

class RiskAssessmentScreen extends StatelessWidget {
  const RiskAssessmentScreen({super.key});

  void _showAssessmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFBFC),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2D7DC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Do you have recent\nmedical reports?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.3,
                    fontWeight: FontWeight.bold,
                    color: riskDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose an option to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                // OPTION 1: WITH REPORTS
                _AssessmentOptionCard(
                  icon: Icons.description_outlined,
                  title: 'Yes, I have medical reports',
                  description:
                      'I have hormone tests, ultrasound results '
                      'or other medical reports.',
                  color: riskGreen,
                  background: const Color(0xFFF0F9F4),
                  borderColor: const Color(0xFFB9E4D2),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Medical report upload will be added next.',
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // OPTION 2: WITHOUT REPORTS
                _AssessmentOptionCard(
                  icon: Icons.assignment_outlined,
                  title: "No, I don't have reports",
                  description:
                      'Answer questions about your periods, '
                      'symptoms and everyday lifestyle.',
                  color: riskPink,
                  background: const Color(0xFFFFF1F5),
                  borderColor: const Color(0xFFF5CBD9),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuestionnaireScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0F8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF8B6599),
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your health information matters. '
                          'We handle your data with care and respect your privacy.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: riskDark,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: riskBackground,
      appBar: AppBar(
        backgroundColor: riskBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: riskDark,
            size: 21,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PCOS Assessment',
          style: TextStyle(
            color: riskDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // LIGHT BOTANICAL BACKGROUND
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 190,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.30,
                 /*  child: Image.asset(
                    'assets/images/leaves.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (_, _, _) =>  
                    const SizedBox.shrink(),
                  ), */
                  child: Image.asset(
  'assets/images/leaves.png',
  fit: BoxFit.cover,
  alignment: Alignment.bottomCenter,
)
                ),
              ),
            ),

            // INTRODUCTION CONTENT
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 4, 22, 18),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 22,
                    ),
                    child: Column(
                      children: [
                        // SIMPLE PROGRESS INDICATOR
                        Row(
                          children: List.generate(4, (index) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                height: 5,
                                decoration: BoxDecoration(
                                  color: index == 0
                                      ? riskPink
                                      : const Color(0xFFE8E0E4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 10),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Step 1 of 4',
                            style: TextStyle(
                              color: riskPink,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // YOUR GIRL ILLUSTRATION
                        SizedBox(
                          height: constraints.maxHeight * 0.43,
                          width: double.infinity,
                          child: Image.asset(
  'assets/images/RiskAssetment.png',
  fit: BoxFit.contain,
),/* child: Image.asset(
                            'assets/images/RiskAssetment.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                  color: riskPink,
                                ),
                              );
                            },
                          ), */
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Let's understand you better",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            color: riskDark,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'This assessment will help us understand '
                          'your symptoms and health history to provide '
                          'personalized lifestyle guidance.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.55,
                            color: Color(0xFF655960),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // TIME ESTIMATE
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE8EE),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: riskPink,
                                size: 21,
                              ),
                              SizedBox(width: 9),
                              Flexible(
                                child: Text(
                                  'It will take about 5–10 minutes',
                                  style: TextStyle(
                                    color: riskPink,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // START BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showAssessmentOptions(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: riskPink,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shadowColor:
                                  riskPink.withValues(alpha: 0.22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Start Assessment',
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

                        const SizedBox(height: 12),

                        const Text(
                          'Your journey starts with understanding your health.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF897B83),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AssessmentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color background;
  final Color borderColor;
  final VoidCallback onTap;

  const _AssessmentOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.background,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
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
                        color: riskDark,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF6D6067),
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/* import 'package:flutter/material.dart';

import 'questionnaire_screen.dart';

const Color riskPurple = Color(0xFF6C35C9);
const Color riskGreen = Color(0xFF3BA66B);
const Color riskDark = Color(0xFF1D1930);
const Color riskBackground = Color(0xFFFAF8FC);

class RiskAssessmentScreen extends StatelessWidget {
  const RiskAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: riskBackground,

      appBar: AppBar(
        backgroundColor: riskBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: riskDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Risk Assessment',
          style: TextStyle(
            color: riskDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
        child: Column(
          children: [

            const Text(
              'Do you have recent medical reports?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: riskDark,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Choose an option to continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),


            const SizedBox(height: 35),

            // YES CARD
            _buildOptionCard(
              icon: Icons.medical_information_outlined,
              title: 'Yes, I have\nmedical reports',
              description:
                  'Provide your hormone test,\nultrasound and other clinical\ndetails for accurate prediction.',
              buttonText: 'Continue with Reports →',
              iconColor: riskGreen,
              backgroundColor: const Color(0xFFEFFAF3),
              buttonColor: riskGreen,
              onPressed: () {
                // We will add report upload here later.
              },
            ),

                               const SizedBox(height: 20),

            // NO CARD
            _buildOptionCard(
              icon: Icons.person_outline,
              title: 'No, I don’t have\nmedical reports',
              description:
                  'Answer a few questions about\nyour symptoms, lifestyle and\nperiods for risk assessment.',
              buttonText: 'Continue without Reports →',
              iconColor: riskPurple,
              backgroundColor: const Color(0xFFF4EEFF),
              buttonColor: riskPurple,
              onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const QuestionnaireScreen(),
    ),
  );
},
            ),

  
            const SizedBox(height: 25),

            // INFORMATION MESSAGE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF1ECFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: riskPurple,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You can always update your medical '
                      'reports later from your dashboard.',
                      style: TextStyle(
                        fontSize: 12,
                        color: riskDark,
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

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required Color iconColor,
    required Color backgroundColor,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: iconColor,
            size: 55,
          ),

          const SizedBox(height: 15),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: riskDark,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} */