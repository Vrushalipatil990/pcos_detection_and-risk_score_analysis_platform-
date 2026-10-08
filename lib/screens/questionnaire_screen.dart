import 'package:flutter/material.dart';

const Color questionnairePurple = Color(0xFF6C35C9);
const Color questionnaireDark = Color(0xFF1D1930);
const Color questionnaireBackground = Color(0xFFFAF8FC);

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int currentSection = 1;

  // ============================================================
  // SECTION 1 - BASIC INFORMATION
  // ============================================================

  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool get section1Complete =>
      ageController.text.trim().isNotEmpty &&
      heightController.text.trim().isNotEmpty &&
      weightController.text.trim().isNotEmpty;

  // ============================================================
  // SECTION 2 - MENSTRUAL HEALTH
  // ============================================================

  String? periodRegularity;
  String? missedPeriods;
  String? periodDuration;
  String? periodChange;
  String? heavyBleeding;

  bool get section2Complete =>
      periodRegularity != null &&
      missedPeriods != null &&
      periodDuration != null &&
      periodChange != null &&
      heavyBleeding != null;

  // ============================================================
  // SECTION 3 - PCOS SYMPTOMS
  // ============================================================

  String? facialHair;
  String? acne;
  String? acneLocation;
  String? hairLoss;
  String? weightGain;
  String? darkSkin;

  bool get section3Complete =>
      facialHair != null &&
      acne != null &&
      acneLocation != null &&
      hairLoss != null &&
      weightGain != null &&
      darkSkin != null;

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void nextSection() {
    if (currentSection == 1 && !section1Complete) {
      _showMessage('Please complete all fields to continue.');
      return;
    }

    if (currentSection == 2 && !section2Complete) {
      _showMessage('Please answer all questions to continue.');
      return;
    }

    if (currentSection == 3 && !section3Complete) {
      _showMessage('Please answer all questions to continue.');
      return;
    }

    if (currentSection == 4 && !section4Complete) {
      _showMessage('Please answer all questions to continue.');
      return;
    }

    if (currentSection == 5) {
      if (!section5Complete) {
        _showMessage('Please answer all questions to continue.');
        return;
      }

      _showMessage('Assessment completed successfully!');
      return;
    }

    setState(() {
      currentSection++;
    });
  }

  void previousSection() {
    if (currentSection > 1) {
      setState(() {
        currentSection--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: questionnaireBackground,
      appBar: AppBar(
        backgroundColor: questionnaireBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: questionnaireDark),
          onPressed: previousSection,
        ),
        title: const Text(
          'Health Assessment',
          style: TextStyle(
            color: questionnaireDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgress(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: _buildCurrentSection(),
              ),
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _sectionName(),
                style: const TextStyle(
                  color: questionnaireDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$currentSection of 5',
                style: TextStyle(
                  color: questionnairePurple.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: currentSection / 5,
              minHeight: 7,
              backgroundColor: const Color(0xFFE8E2F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                questionnairePurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _sectionName() {
    switch (currentSection) {
      case 1:
        return 'Basic Information';
      case 2:
        return 'Menstrual Health';
      case 3:
        return 'PCOS Symptoms';
      case 4:
        return 'Lifestyle';
      case 5:
        return 'Diet & Family History';
      default:
        return 'Health Assessment';
    }
  }

  // ============================================================
  // CURRENT SECTION
  // ============================================================

  Widget _buildCurrentSection() {
    switch (currentSection) {
      case 1:
        return _buildSection1();

      case 2:
        return _buildSection2();

      case 3:
        return _buildSection3();

      case 4:
        return _buildSection4();

      case 5:
        return _buildSection5();

      default:
        return const SizedBox();
    }
  }

  // ============================================================
  // SECTION 1
  // ============================================================

  Widget _buildSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          icon: Icons.favorite_outline,
          title: 'Let’s understand your health',
          subtitle: 'Start with some basic information',
        ),

        const SizedBox(height: 24),

        _buildInputCard(
          icon: Icons.cake_outlined,
          title: 'Age',
          hint: 'Enter your age',
          controller: ageController,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 16),

        _buildInputCard(
          icon: Icons.height_outlined,
          title: 'Height',
          hint: 'Enter your height',
          suffix: 'cm',
          controller: heightController,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 16),

        _buildInputCard(
          icon: Icons.monitor_weight_outlined,
          title: 'Weight',
          hint: 'Enter your weight',
          suffix: 'kg',
          controller: weightController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ============================================================
  // SECTION 2
  // ============================================================

  Widget _buildSection2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          icon: Icons.water_drop_outlined,
          title: 'Menstrual Health',
          subtitle: 'Tell us about your menstrual cycle',
        ),

        const SizedBox(height: 24),

        _buildQuestionCard(
          number: '01',
          icon: Icons.calendar_month_outlined,
          question: 'How regular are your periods?',
          options: ['Regular', 'Irregular', 'Sometimes irregular', 'Not sure'],
          selectedValue: periodRegularity,
          onSelected: (value) {
            setState(() {
              periodRegularity = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '02',
          icon: Icons.event_busy_outlined,
          question: 'How often do you miss your periods?',
          options: ['Never', 'Rarely', 'Sometimes', 'Frequently'],
          selectedValue: missedPeriods,
          onSelected: (value) {
            setState(() {
              missedPeriods = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '03',
          icon: Icons.schedule_outlined,
          question: 'How long do your periods usually last?',
          options: [
            '1–2 days',
            '3–5 days',
            '6–7 days',
            'More than 7 days',
            'Varies significantly',
          ],
          selectedValue: periodDuration,
          onSelected: (value) {
            setState(() {
              periodDuration = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '04',
          icon: Icons.sync_alt_outlined,
          question: 'Have you noticed a significant change in your periods during the last year?',
          options: ['Yes', 'No'],
          selectedValue: periodChange,
          onSelected: (value) {
            setState(() {
              periodChange = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '05',
          icon: Icons.water_drop_outlined,
          question: 'Do you experience unusually heavy menstrual bleeding?',
          options: ['Never', 'Rarely', 'Sometimes', 'Frequently', 'Not sure'],
          selectedValue: heavyBleeding,
          onSelected: (value) {
            setState(() {
              heavyBleeding = value;
            });
          },
        ),
      ],
    );
  }

  // ============================================================
  // SECTION 3
  // ============================================================

  Widget _buildSection3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          icon: Icons.health_and_safety_outlined,
          title: 'PCOS Symptoms',
          subtitle: 'Tell us about symptoms you may have noticed',
        ),

        const SizedBox(height: 24),

        _buildQuestionCard(
          number: '01',
          icon: Icons.face_retouching_natural_outlined,
          question: 'Do you experience excessive facial or body hair growth?',
          options: ['Yes', 'No', 'Not sure'],
          selectedValue: facialHair,
          onSelected: (value) {
            setState(() {
              facialHair = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '02',
          icon: Icons.face_outlined,
          question: 'How would you describe your acne?',
          options: ['No acne', 'Mild', 'Moderate', 'Not sure'],
          selectedValue: acne,
          onSelected: (value) {
            setState(() {
              acne = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '03',
          icon: Icons.location_on_outlined,
          question: 'Where do you usually experience acne?',
          options: [
            'Chin',
            'Forehead',
            'Cheeks',
            'Jawline',
            'Chest',
            'Back',
            'None',
            'Other',
          ],
          selectedValue: acneLocation,
          onSelected: (value) {
            setState(() {
              acneLocation = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '04',
          icon: Icons.content_cut_outlined,
          question: 'Have you noticed unusual hair thinning or hair loss?',
          options: ['Yes', 'No'],
          selectedValue: hairLoss,
          onSelected: (value) {
            setState(() {
              hairLoss = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '05',
          icon: Icons.monitor_weight_outlined,
          question: 'Have you experienced unexplained weight gain?',
          options: ['Yes', 'No', 'Not sure'],
          selectedValue: weightGain,
          onSelected: (value) {
            setState(() {
              weightGain = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '06',
          icon: Icons.accessibility_new_outlined,
          question: 'Have you noticed dark or thickened skin, especially around your neck?',
          options: ['Yes', 'No', 'Not sure'],
          selectedValue: darkSkin,
          onSelected: (value) {
            setState(() {
              darkSkin = value;
            });
          },
        ),
      ],
    );
  }
  // ============================================================
  // SECTION 4
  // ============================================================

  Widget _buildSection4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          icon: Icons.directions_run_outlined,
          title: 'Lifestyle',
          subtitle: 'Tell us about your daily habits',
        ),

        const SizedBox(height: 24),

        _buildQuestionCard(
          number: '01',
          icon: Icons.fitness_center_outlined,
          question: 'How many days a week do you exercise?',
          options: ['0 days', '1–2 days', '3–4 days', '5 or more days'],
          selectedValue: exerciseDays,
          onSelected: (value) {
            setState(() {
              exerciseDays = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '02',
          icon: Icons.timer_outlined,
          question: 'How long does your usual exercise session last?',
          options: [
            'Less than 15 minutes',
            '15–30 minutes',
            '30–60 minutes',
            'More than 60 minutes',
          ],
          selectedValue: exerciseDuration,
          onSelected: (value) {
            setState(() {
              exerciseDuration = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '03',
          icon: Icons.directions_walk_outlined,
          question: 'What type of physical activity do you usually do?',
          options: [
            'Walking',
            'Cycling',
            'Yoga',
            'Gym',
            'Sports',
            'None',
            'Other',
          ],
          selectedValue: activityType,
          onSelected: (value) {
            setState(() {
              activityType = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '04',
          icon: Icons.bedtime_outlined,
          question: 'How many hours do you usually sleep?',
          options: [
            'Less than 5 hours',
            '5–6 hours',
            '7–8 hours',
            'More than 8 hours',
          ],
          selectedValue: sleepHours,
          onSelected: (value) {
            setState(() {
              sleepHours = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '05',
          icon: Icons.psychology_outlined,
          question: 'How would you describe your usual stress level?',
          options: ['Low', 'Moderate', 'High', 'Very high'],
          selectedValue: stressLevel,
          onSelected: (value) {
            setState(() {
              stressLevel = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '06',
          icon: Icons.local_drink_outlined,
          question: 'How often do you consume sugary drinks or sugary foods?',
          options: [
            'Rarely',
            '1–2 times a week',
            '3–4 times a week',
            'Almost every day',
            'Multiple times a day',
          ],
          selectedValue: sugaryFoodFrequency,
          onSelected: (value) {
            setState(() {
              sugaryFoodFrequency = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '07',
          icon: Icons.fastfood_outlined,
          question: 'How often do you consume fast food or processed food?',
          options: [
            'Rarely',
            '1–2 times a week',
            '3–4 times a week',
            'Almost every day',
            'Every day',
          ],
          selectedValue: fastFoodFrequency,
          onSelected: (value) {
            setState(() {
              fastFoodFrequency = value;
            });
          },
        ),
      ],
    );
  }
  // ============================================================
  // SECTION 5
  // ============================================================

  Widget _buildSection5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          icon: Icons.restaurant_outlined,
          title: 'Diet & Family History',
          subtitle: 'A few final questions about your health',
        ),

        const SizedBox(height: 24),

        _buildQuestionCard(
          number: '01',
          icon: Icons.eco_outlined,
          question: 'How many servings of fruits and vegetables do you usually have per day?',
          options: [
            'Rarely',
            '1 serving',
            '2–3 servings',
            'More than 3 servings',
          ],
          selectedValue: fruitsVegetables,
          onSelected: (value) {
            setState(() {
              fruitsVegetables = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '02',
          icon: Icons.restaurant_outlined,
          question: 'What type of diet do you follow?',
          options: ['Vegetarian', 'Non-vegetarian', 'Other'],
          selectedValue: dietType,
          onSelected: (value) {
            setState(() {
              dietType = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '03',
          icon: Icons.lunch_dining_outlined,
          question: 'How many meals do you usually have per day?',
          options: ['1–2 meals', '3 meals', '4 meals', '5 or more meals'],
          selectedValue: mealsPerDay,
          onSelected: (value) {
            setState(() {
              mealsPerDay = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '04',
          icon: Icons.cookie_outlined,
          question: 'How often do you experience sugar cravings?',
          options: ['Never', 'Rarely', 'Sometimes', 'Almost every day'],
          selectedValue: sugarCravings,
          onSelected: (value) {
            setState(() {
              sugarCravings = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '05',
          icon: Icons.family_restroom_outlined,
          question: 'Does anyone in your family have PCOS?',
          options: ['Yes', 'No', 'I don’t know'],
          selectedValue: familyPCOS,
          onSelected: (value) {
            setState(() {
              familyPCOS = value;
            });
          },
        ),

        _buildSpacing(),

        _buildQuestionCard(
          number: '06',
          icon: Icons.medical_services_outlined,
          question: 'Have you ever been diagnosed with PCOS by a doctor?',
          options: ['Yes', 'No'],
          selectedValue: doctorDiagnosis,
          onSelected: (value) {
            setState(() {
              doctorDiagnosis = value;
            });
          },
        ),

        const SizedBox(height: 10),

        // Small completion message
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1EAFF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: questionnairePurple),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You are almost done. Review your answers and continue.',
                  style: TextStyle(
                    color: questionnaireDark,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget _buildHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C35C9), Color(0xFF8B5ADD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: questionnairePurple.withValues(alpha: 0.20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT CARD
  // ============================================================

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    required String hint,
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF1EAFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: questionnairePurple),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: title,
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                suffixText: suffix,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard({
    required String number,
    required IconData icon,
    required String question,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EAFF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: questionnairePurple, size: 22),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    color: questionnaireDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),

              Text(
                number,
                style: TextStyle(
                  color: questionnairePurple.withValues(alpha: 0.45),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...options.map(
            (option) => _buildOption(
              option: option,
              selected: selectedValue == option,
              onTap: () => onSelected(option),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OPTION
  // ============================================================

  Widget _buildOption({
    required String option,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1EAFF) : const Color(0xFFFAF9FC),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? questionnairePurple : const Color(0xFFE8E4EE),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? questionnairePurple : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? questionnairePurple
                      : const Color(0xFFBDB7C8),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: questionnaireDark,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM BUTTON
  // ============================================================

  Widget _buildBottomButton() {
    bool complete;

    if (currentSection == 1) {
      complete = section1Complete;
    } else if (currentSection == 2) {
      complete = section2Complete;
    } else if (currentSection == 3) {
      complete = section3Complete;
    } else if (currentSection == 4) {
      complete = section4Complete;
    } else if (currentSection == 5) {
      complete = section5Complete;
    } else {
      complete = false;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: questionnaireBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: complete ? nextSection : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: questionnairePurple,
            disabledBackgroundColor: const Color(0xFFD8D3DF),
            foregroundColor: Colors.white,
            disabledForegroundColor: const Color(0xFF8F8998),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentSection == 5 ? 'Finish Assessment' : 'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: complete ? Colors.white : const Color(0xFF8F8998),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: complete ? Colors.white : const Color(0xFF8F8998),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildSpacing() {
    return const SizedBox(height: 16);
  }
}
// ============================================================
// SECTION 4 - LIFESTYLE
// ============================================================

String? exerciseDays;
String? exerciseDuration;
String? activityType;
String? sleepHours;
String? stressLevel;
String? sugaryFoodFrequency;
String? fastFoodFrequency;

bool get section4Complete =>
    exerciseDays != null &&
    exerciseDuration != null &&
    activityType != null &&
    sleepHours != null &&
    stressLevel != null &&
    sugaryFoodFrequency != null &&
    fastFoodFrequency != null;

// ============================================================
// SECTION 5 - DIET & FAMILY HISTORY
// ============================================================

String? fruitsVegetables;
String? dietType;
String? mealsPerDay;
String? sugarCravings;
String? familyPCOS;
String? doctorDiagnosis;

bool get section5Complete =>
    fruitsVegetables != null &&
    dietType != null &&
    mealsPerDay != null &&
    sugarCravings != null &&
    familyPCOS != null &&
    doctorDiagnosis != null;
