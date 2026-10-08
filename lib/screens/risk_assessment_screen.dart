import 'package:flutter/material.dart';

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
}