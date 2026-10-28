
import 'package:flutter/material.dart';

class RecommendationScreen extends StatefulWidget {
  final Map<String, dynamic> questionnaireData;

  const RecommendationScreen({
    super.key,
    required this.questionnaireData,
  });

  @override
  State<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState
    extends State<RecommendationScreen> {
  final Set<String> completedTasks = {};

  final List<Map<String, String>> recommendations = [
    {
      'title': 'Balanced Nutrition',
      'description':
          'Include vegetables, whole grains, protein-rich foods, '
          'and fibre-rich meals in your daily diet.',
    },
    {
      'title': 'Regular Physical Activity',
      'description':
          'Start with a manageable activity such as walking, '
          'cycling, or another exercise you enjoy.',
    },
    {
      'title': 'Yoga and Relaxation',
      'description':
          'Try gentle yoga, stretching, or breathing exercises '
          'as part of a balanced lifestyle.',
    },
    {
      'title': 'Sleep and Routine',
      'description':
          'Maintain a consistent sleep schedule and track '
          'your daily lifestyle habits.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFB84D70);
    const lightPink = Color(0xFFF9E4E8);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Recommendations'),
        backgroundColor: pink,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: lightPink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Daily Wellness Plan',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Follow these general lifestyle suggestions '
                  'and mark the activities you complete.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recommended Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...recommendations.map((item) {
            final title = item['title']!;
            final completed = completedTasks.contains(title);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: CheckboxListTile(
                activeColor: pink,
                value: completed,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      completedTasks.add(title);
                    } else {
                      completedTasks.remove(title);
                    }
                  });
                },
                title: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(item['description']!),
                ),
                controlAffinity:
                    ListTileControlAffinity.leading,
              ),
            );
          }),
          const SizedBox(height: 8),
          Text(
            '${completedTasks.length} of '
            '${recommendations.length} activities completed',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
