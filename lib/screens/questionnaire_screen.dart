import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'assessment_complete_screen.dart';

const Color questionnairePurple = Color(0xFFD96F91); // PCOSense pink
const Color questionnaireDark = Color(0xFF30232A);
const Color questionnaireBackground = Color(0xFFFFF7F9);

const Color questionnaireGreen = Color(0xFF369B83);
const Color questionnaireSoftPink = Color(0xFFFCE6ED);
const Color questionnaireSoftGreen = Color(0xFFE5F5EF);

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int currentSection = 1;
  String heightUnit = 'cm';
  String? cycleLength;
String? painfulPeriods;
Set<String> acneLocations = {};
String? exerciseDays;
String? exerciseDuration;
String? activityType;
String? sleepHours;
String? stressLevel;
String? sugaryFoodFrequency;
String? fastFoodFrequency;

Set<String> activityTypes = {};
final TextEditingController otherActivityController = TextEditingController();
final TextEditingController otherAcneLocationController =TextEditingController();

  // ============================================================
  // SECTION 1 - BASIC INFORMATION
  // ============================================================

  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

bool get section1Complete {
  final age = int.tryParse(ageController.text.trim());
  final height = double.tryParse(heightController.text.trim());
  final weight = double.tryParse(weightController.text.trim());

  return age != null &&
      age >= 10 &&
      age <= 100 &&
      height != null &&
      height > 0 &&
      weight != null &&
      weight > 0 &&
      weight <= 500;
}
  // ============================================================
  // SECTION 2 - MENSTRUAL HEALTH
  // ============================================================

  String? periodRegularity;
  String? missedPeriods;
  String? periodDuration;
  String? periodChange;
  String? heavyBleeding;

bool get section2Complete =>
    cycleLength != null &&
    periodRegularity != null &&
    periodDuration != null &&
    painfulPeriods != null &&
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
    acneLocations.isNotEmpty &&
    hairLoss != null &&
    weightGain != null &&
    darkSkin != null;

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    otherActivityController.dispose();
    otherAcneLocationController.dispose();
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AssessmentCompleteScreen(),
      ),
    );
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

      _buildHeightInputCard(),

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


Widget _buildHeightInputCard() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: _cardDecoration(),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: questionnaireSoftPink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.height_outlined,
            color: questionnairePurple,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: TextField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Height',
              hintText: 'Enter your height',
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),

        const SizedBox(width: 8),

        DropdownButton<String>(
          value: heightUnit,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(
              value: 'cm',
              child: Text('cm'),
            ),
            DropdownMenuItem(
              value: 'in',
              child: Text('inches'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                heightUnit = value;
              });
            }
          },
        ),
      ],
    ),
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
        title: 'Menstrual Information',
        subtitle: 'Help us understand your menstrual cycle.',
      ),

      const SizedBox(height: 20),

      _buildDropdownQuestionCard(
        icon: Icons.calendar_month_outlined,
        title: 'Average cycle length',
        subtitle: 'How many days are usually between two periods?',
        value: cycleLength,
        items: [
          '21 days',
          '24 days',
          '26 days',
          '28 days',
          '30 days',
          '32 days',
          '35 days',
          'More than 35 days',
          'Not sure',
        ],
        onChanged: (value) {
          setState(() => cycleLength = value);
        },
      ),

      _buildSpacing(),

      _buildInlineChoiceCard(
        icon: Icons.sync_outlined,
        title: 'Is your cycle regular?',
        options: ['Regular', 'Irregular','Sometimes irregular', 'Not sure'],
        selectedValue: periodRegularity,
        onSelected: (value) {
          setState(() => periodRegularity = value);
        },
      ),

      _buildSpacing(),

      _buildDropdownQuestionCard(
        icon: Icons.calendar_today_outlined,
        title: 'Period duration',
        subtitle: 'How long does your period usually last?',
        value: periodDuration,
        items: [
          '1–2 days',
          '3–5 days',
          '4–6 days',
          '6–7 days',
          '7–8 days',
          'More than 8 days',
          'Varies significantly',
        ],
        onChanged: (value) {
          setState(() => periodDuration = value);
        },
      ),

      _buildSpacing(),

      _buildInlineChoiceCard(
        icon: Icons.bolt_outlined,
        title: 'Do you experience painful periods?',
        options: ['Yes', 'No','Sometimes'],
        selectedValue: painfulPeriods,
        onSelected: (value) {
          setState(() => painfulPeriods = value);
        },
      ),

      _buildSpacing(),

      _buildInlineChoiceCard(
        icon: Icons.water_drop_outlined,
        title: 'Do you experience unusually heavy bleeding?',
        options: ['Never', 'Rarely', 'Sometimes', 'Frequently'],
        selectedValue: heavyBleeding,
        onSelected: (value) {
          setState(() => heavyBleeding = value);
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
        icon: Icons.spa_outlined,
        title: 'Your Symptoms',
        subtitle: 'Every detail helps us understand your health better.',
      ),

      const SizedBox(height: 12),

      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: questionnaireSoftPink,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.favorite_outline,
              color: questionnairePurple,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Select the answers that best describe you. '
                'You can choose multiple locations where indicated.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: questionnaireDark,
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 18),

      _buildAnimatedSymptomCard(
        icon: Icons.face_retouching_natural_outlined,
        title: 'Facial or body hair',
        subtitle: 'Have you noticed excessive hair growth?',
        options: ['Yes', 'No', 'Not sure'],
        selectedOptions: {
          if (facialHair != null) facialHair!,
        },
        onOptionSelected: (value) {
          setState(() => facialHair = value);
        },
      ),

      _buildSpacing(),

      _buildAnimatedSymptomCard(
        icon: Icons.face_outlined,
        title: 'Acne severity',
        subtitle: 'How would you describe your acne?',
        options: ['No acne', 'Mild', 'Moderate', 'Severe', 'Not sure'],
        selectedOptions: {
          if (acne != null) acne!,
        },
        onOptionSelected: (value) {
          setState(() => acne = value);
        },
      ),

      _buildSpacing(),

  
_buildAnimatedSymptomCard(
  icon: Icons.location_on_outlined,
  title: 'Acne locations',
  subtitle: 'Select all areas where you experience acne.',
  options: [
    'Chin',
    'Forehead',
    'Cheeks',
    'Jawline',
    'Chest',
    'Back',
    'Other',
  ],
  selectedOptions: acneLocations,
  allowMultiple: true,
  onOptionSelected: (value) {
    setState(() {
      if (acneLocations.contains(value)) {
        acneLocations.remove(value);

        if (value == 'Other') {
          otherAcneLocationController.clear();
        }
      } else {
        acneLocations.add(value);
      }
    });
  },
  extraContent: acneLocations.contains('Other')
      ? TextField(
  controller: otherAcneLocationController,
  inputFormatters: [
    FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z\s]'),
    ),
  ],
  decoration: InputDecoration(
    labelText: 'Enter another acne location',
    hintText: 'e.g. Neck, shoulders',
    prefixIcon: const Icon(
      Icons.edit_outlined,
      color: questionnairePurple,
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
)
      : null,
),


      _buildSpacing(),

      _buildAnimatedSymptomCard(
        icon: Icons.content_cut_outlined,
        title: 'Hair thinning or hair loss',
        subtitle: 'Have you noticed unusual hair loss?',
        options: ['Yes', 'No', 'Not sure'],
        selectedOptions: {
          if (hairLoss != null) hairLoss!,
        },
        onOptionSelected: (value) {
          setState(() => hairLoss = value);
        },
      ),

      _buildSpacing(),

      _buildAnimatedSymptomCard(
        icon: Icons.monitor_weight_outlined,
        title: 'Unexplained weight gain',
        subtitle: 'Have you experienced unexplained weight changes?',
        options: ['Yes', 'No', 'Not sure'],
        selectedOptions: {
          if (weightGain != null) weightGain!,
        },
        onOptionSelected: (value) {
          setState(() => weightGain = value);
        },
      ),

      _buildSpacing(),

      _buildAnimatedSymptomCard(
        icon: Icons.health_and_safety_outlined,
        title: 'Skin changes',
        subtitle: 'Have you noticed darkened or thickened skin?',
        options: ['Yes', 'No', 'Not sure'],
        selectedOptions: {
          if (darkSkin != null) darkSkin!,
        },
        onOptionSelected: (value) {
          setState(() => darkSkin = value);
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
      // Lifestyle welcome card
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFD83F73),
              Color(0xFFEA8A9F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.spa_rounded,
              color: Colors.white,
              size: 34,
            ),
            SizedBox(height: 12),
            Text(
              'Your everyday wellness',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Small habits matter. Tell us what your '
              'usual day looks like.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 22),

      _buildLifestyleChoiceCard(
        icon: Icons.fitness_center_rounded,
        title: 'Movement',
        subtitle: 'How often do you exercise?',
        options: [
          'Never',
          '1–2 days',
          '3–4 days',
          '5+ days',
           'Daily',
        ],
        selectedValue: exerciseDays,
        onSelected: (value) {
          setState(() => exerciseDays = value);
        },
      ),


const SizedBox(height: 16),

_buildLifestyleChoiceCard(
  icon: Icons.timer_outlined,
  title: 'Exercise duration',
  subtitle: 'How long do you usually exercise each time?',
  options: [
    'Under 15 min',
    '15–30 min',
    '30–60 min',
    'Over 60 min',
  ],
selectedValue: exerciseDuration,
onSelected: (value) {
  setState(() {
    exerciseDuration = value;
  });
},
),


const SizedBox(height: 16),
      
_buildLifestyleMultiCard(
  icon: Icons.directions_run_rounded,
  title: 'Your favourite activities',
  subtitle: 'Choose all that you usually do.',
  options: [
    'Walking',
    'Cycling',
    'Yoga',
    'Gym',
    'Sports',
    'Other',
    'None',
  ],
  selectedOptions: activityTypes,
  onToggled: (option, selected) {
    setState(() {
      if (option == 'None' && selected) {
        activityTypes
          ..clear()
          ..add('None');
        otherActivityController.clear();
      } else {
        activityTypes.remove('None');

        if (selected) {
          activityTypes.add(option);
        } else {
          activityTypes.remove(option);

          if (option == 'Other') {
            otherActivityController.clear();
          }
        }
      }

      activityType = activityTypes.isEmpty
          ? null
          : activityTypes.join(', ');
    });
  },
  extraContent: activityTypes.contains('Other')
      ? TextField(
  controller: otherActivityController,
  inputFormatters: [
    FilteringTextInputFormatter.allow(
      RegExp(r'[a-zA-Z\s]'),
    ),
  ],
  decoration: InputDecoration(
    labelText: 'Enter your activity',
    hintText: 'e.g. Dancing, Swimming',
    prefixIcon: const Icon(
      Icons.edit_outlined,
      color: questionnaireGreen,
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
  onChanged: (value) {
    setState(() {
      final activities = activityTypes
          .where(
            (item) => item != 'Other' && item != 'None',
          )
          .toList();

      if (value.trim().isNotEmpty) {
        activities.add(value.trim());
      }

      activityType = activities.isEmpty
          ? null
          : activities.join(', ');
    });
  },
)
      : null,
),


      const SizedBox(height: 16),
      _buildLifestyleChoiceCard(
        icon: Icons.bedtime_rounded,
        title: 'Sleep routine',
        subtitle: 'How many hours do you usually sleep?',
        options: [
          'Under 5 hrs',
          '5–6 hrs',
          '7–8 hrs',
          'Over 8 hrs',
        ],
        selectedValue: sleepHours,
        onSelected: (value) {
          setState(() => sleepHours = value);
        },
      ),

      const SizedBox(height: 16),

      _buildLifestyleChoiceCard(
        icon: Icons.psychology_rounded,
        title: 'Stress check-in',
        subtitle: 'How stressed do you usually feel?',
        options: [
          'Low',
          'Moderate',
          'High',
          'Very high',
        ],
        selectedValue: stressLevel,
        onSelected: (value) {
          setState(() => stressLevel = value);
        },
      ),

      const SizedBox(height: 16),

      _buildLifestyleChoiceCard(
        icon: Icons.local_drink_rounded,
        title: 'Sugary food & drinks',
        subtitle: 'How often do you have them?',
        options: [
          'Rarely',
          '1–2 times/week',
          '3–4 times/week',
          'Almost daily',
          'Multiple times/day',
        ],
        selectedValue: sugaryFoodFrequency,
        onSelected: (value) {
          setState(() => sugaryFoodFrequency = value);
        },
      ),

      const SizedBox(height: 16),

      _buildLifestyleChoiceCard(
        icon: Icons.fastfood_rounded,
        title: 'Fast & processed food',
        subtitle: 'How often do you eat these foods?',
        options: [
          'Rarely',
          '1–2 times/week',
          '3–4 times/week',
          'Almost daily',
          'Every day',
        ],
        selectedValue: fastFoodFrequency,
        onSelected: (value) {
          setState(() => fastFoodFrequency = value);
        },
      ),

      const SizedBox(height: 12),

      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: questionnaireSoftGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.favorite_rounded,
              color: questionnaireGreen,
              size: 25,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'There are no perfect answers. '
                'Choose what best describes your usual routine.',
                style: TextStyle(
                  color: questionnaireDark,
                  fontSize: 13,
                  height: 1.45,
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

      const SizedBox(height: 20),

      // Intro card
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFCE6ED),
              Color(0xFFE5F5EF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.favorite_outline_rounded,
                color: questionnairePurple,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your daily wellness',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: questionnaireDark,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tell us about your eating habits and health history.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: questionnaireDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      _buildQuestionCard(
        number: '01',
        icon: Icons.eco_outlined,
        question:
            'How many servings of fruits and vegetables do you usually have per day?',
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
        options: [
          'Vegetarian',
          'Non-vegetarian',
          'Other',
        ],
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
        options: [
          '1–2 meals',
          '3 meals',
          '4 meals',
          '5 or more meals',
        ],
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
        options: [
          'Never',
          'Rarely',
          'Sometimes',
          'Almost every day',
        ],
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
        options: [
          'Yes',
          'No',
          'I don’t know',
        ],
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
        question:
            'Have you ever been diagnosed with PCOS by a doctor?',
        options: [
          'Yes',
          'No',
        ],
        selectedValue: doctorDiagnosis,
        onSelected: (value) {
          setState(() {
            doctorDiagnosis = value;
          });
        },
      ),

      const SizedBox(height: 16),

      // Completion card
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: questionnaireSoftGreen,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: questionnaireGreen.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: questionnaireGreen,
              size: 25,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Almost there!',
                    style: TextStyle(
                      color: questionnaireDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Review your answers and continue when you are ready.',
                    style: TextStyle(
                      color: questionnaireDark,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
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
          colors: const [Color(0xFFD83F73), Color(0xFFEA7398)],
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
              inputFormatters: title == 'Age'? [FilteringTextInputFormatter.digitsOnly]: [ FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'),),],
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
  Widget _questionIcon(IconData icon) {
  return Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: questionnaireSoftPink,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Icon(
      icon,
      color: questionnairePurple,
      size: 23,
    ),
  );
}

Widget _buildInlineChoiceCard({
  required IconData icon,
  required String title,
  required List<String> options,
  required String? selectedValue,
  required ValueChanged<String> onSelected,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration().copyWith(
      border: Border.all(
        color: const Color(0xFFF6D6E1),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _questionIcon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: questionnaireDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final selected = selectedValue == option;

/*             return ChoiceChip(
              label: Text(option),
              selected: selected,
              showCheckmark: false,
              selectedColor: questionnaireGreen,
              // selectedColor: questionnairePurple,
              backgroundColor: Colors.white,
              side: BorderSide(color: selected ? questionnaireGreen : const Color(0xFFE8DCE1),),
              labelStyle: TextStyle(color: selected? questionnaireGreen: questionnaireDark,fontWeight: FontWeight.w600,),
              onSelected: (_) => onSelected(option),
            ); */
            return ChoiceChip(
  label: Text(option),
  selected: selected,
  showCheckmark: false,
  selectedColor: questionnaireSoftGreen,
  backgroundColor: Colors.white,
  side: BorderSide(
    color: selected
        ? questionnaireGreen
        : const Color(0xFFE8DCE1),
  ),
  labelStyle: TextStyle(
    color: selected
        ? questionnaireGreen
        : questionnaireDark,
    fontWeight: FontWeight.w600,
  ),
  onSelected: (_) => onSelected(option),
);
          }).toList(),
        ),
      ],
    ),
  );
}

Widget _buildDropdownQuestionCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration().copyWith(
      border: Border.all(
        color: const Color(0xFFF6D6E1),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _questionIcon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: questionnaireDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF7F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE8DCE1),
              ),
            ),
          ),
          hint: const Text('Select an option'),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}


Widget _buildAnimatedSymptomCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required List<String> options,
  required Set<String> selectedOptions,
  required ValueChanged<String> onOptionSelected,
  bool allowMultiple = false,
  Widget? extraContent,
}) {
  final hasSelection = selectedOptions.isNotEmpty;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: hasSelection
            ? questionnairePurple.withValues(alpha: 0.65)
            : const Color(0xFFF2DDE5),
        width: hasSelection ? 1.6 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: questionnairePurple.withValues(
            alpha: hasSelection ? 0.09 : 0.035,
          ),
          blurRadius: hasSelection ? 16 : 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedScale(
              scale: hasSelection ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: hasSelection
                      ? questionnairePurple
                      : questionnaireSoftPink,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: hasSelection
                      ? Colors.white
                      : questionnairePurple,
                  size: 25,
                ),
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: questionnaireDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            if (hasSelection)
              const Icon(
                Icons.check_circle_rounded,
                color: questionnairePurple,
                size: 22,
              ),
          ],
        ),

        const SizedBox(height: 16),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final selected = selectedOptions.contains(option);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              child: ChoiceChip(
                label: Text(option),
                selected: selected,
                showCheckmark: false,

backgroundColor: Colors.white,
selectedColor: questionnaireSoftGreen,
side: BorderSide(
  color: selected
      ? questionnaireGreen
      : const Color(0xFFEADDE3),
  width: selected ? 1.5 : 1,
),
labelStyle: TextStyle(
  color: selected
      ? questionnaireGreen
      : questionnaireDark,
  fontSize: 13,
  fontWeight: selected
      ? FontWeight.w700
      : FontWeight.w500,
),

                onSelected: (_) => onOptionSelected(option),
              ),
            );
          }).toList(),
        ),
        if (extraContent != null) ...[
  const SizedBox(height: 12),
  extraContent!,
],

        if (allowMultiple) ...[
          const SizedBox(height: 8),
          const Text(
            'You can select more than one.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.black45,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _buildLifestyleChoiceCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required List<String> options,
  required String? selectedValue,
  required ValueChanged<String> onSelected,
}) {
  return Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(
        color: const Color(0xFFF5DCE5),
      ),
      boxShadow: [
        BoxShadow(
          color: questionnairePurple.withValues(alpha: 0.05),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 49,
              height: 49,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFCE6ED),
                    Color(0xFFE5F5EF),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: questionnairePurple,
                size: 26,
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
                      color: questionnaireDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: options.map((option) {
            final selected = selectedValue == option;

            return AnimatedScale(
              scale: selected ? 1.04 : 1.0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: ChoiceChip(
                label: Text(option),
                selected: selected,
                showCheckmark: false,
                backgroundColor: const Color(0xFFFFF7F9),
                // selectedColor: questionnaireSoftPink,
                selectedColor: questionnaireSoftGreen,
                side: BorderSide(
                  color: selected ? questionnaireGreen: const Color(0xFFEADDE3),
                  width: selected ? 1.5 : 1,
                ),
                labelStyle: TextStyle(
                  color: selected ? questionnaireGreen: questionnaireDark,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.w500,
                  fontSize: 12,
                ),
                onSelected: (_) => onSelected(option),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}


Widget _buildLifestyleMultiCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required List<String> options,
  required Set<String> selectedOptions,
  required void Function(String option, bool selected) onToggled,
  Widget? extraContent,
}) {
  final activityIcons = <String, IconData>{
    'Walking': Icons.directions_walk_rounded,
    'Cycling': Icons.directions_bike_rounded,
    'Yoga': Icons.self_improvement_rounded,
    'Gym': Icons.fitness_center_rounded,
    'Sports': Icons.sports_basketball_rounded,
    'Other': Icons.more_horiz_rounded,
    'None': Icons.block_rounded,
  };

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color(0xFFD6EEE4),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: questionnaireGreen, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: questionnaireDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final selected = selectedOptions.contains(option);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: selected
                    ? questionnaireSoftGreen
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? questionnaireGreen
                      : const Color(0xFFE5E5E5),
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onToggled(
                  option,
                  !selected,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        activityIcons[option] ??
                            Icons.check_circle_outline,
                        size: 17,
                        color: selected
                            ? questionnaireGreen
                            : questionnaireDark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 13,
                          color: questionnaireDark,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 5),
                        Icon(
                          Icons.check_circle,
                          size: 15,
                          color: questionnaireGreen,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (extraContent != null) ...[
  const SizedBox(height: 12),
  extraContent!,
],
        if (selectedOptions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            '${selectedOptions.length} selected',
            style: const TextStyle(
              color: questionnaireGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
  color: selected ? questionnaireSoftGreen : const Color(0xFFFAF9FC), borderRadius: BorderRadius.circular(13),border: Border.all( color: selected ? questionnaireGreen: const Color(0xFFE8E4EE),width: selected ? 1.5 : 1,
  ),
),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 21,
              height: 21,
              decoration: BoxDecoration( shape: BoxShape.circle, color: selected ? questionnaireGreen : Colors.transparent,
               border: Border.all(color: selected ? questionnaireGreen: const Color(0xFFBDB7C8), width: 1.5,), ),
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
  bool get section4Complete =>
    exerciseDays != null &&
    exerciseDuration != null &&
    activityType != null &&
    activityType!.trim().isNotEmpty &&
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

