import 'package:flutter/material.dart';
import 'risk_assessment_screen.dart';
import '../services/notification_service.dart';

const Color dashboardBackground = Color(0xFFFAF8FC);
const Color dashboardPurple = Color(0xFF6C35C9);
const Color dashboardPink = Color(0xFFE84D9B);
const Color dashboardDark = Color(0xFF1D1930);

class DashboardScreen extends StatelessWidget {
  final String userName;

  const DashboardScreen({
    super.key,
    this.userName = 'Pooja',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashboardBackground,

      appBar: AppBar(
        leading: Builder(
  builder: (context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  },
),
        backgroundColor: dashboardBackground,
        elevation: 0,
        title: const Text(
          'ExplainPCOS AI',
          style: TextStyle(
            color: dashboardPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: dashboardDark,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              child: Icon(Icons.person),
            ),
          ),
          
        ],
      ),
      drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: dashboardPink,
        ),
        child: const Text(
          'PCOSense',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      ListTile(
        leading: const Icon(Icons.dashboard),
        title: const Text('Dashboard'),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      ListTile(
        leading: const Icon(Icons.assessment),
        title: const Text('Risk Assessment'),
        onTap: () {
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RiskAssessmentScreen(),
            ),
          );
        },
      ),

      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      const Divider(),

      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ],
  ),
),

body: SafeArea(
  child: SingleChildScrollView(
    primary: true,
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        // Greeting
        Text(
          'Hello, $userName! 👋',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: dashboardDark,
          ),
        ),

        const SizedBox(height: 6),

        ElevatedButton.icon(
  onPressed: () async {
    await NotificationService.requestPermission();
    await NotificationService.showTestNotification();
  },
  icon: const Icon(Icons.notifications_active),
  label: const Text('Test Notification'),
),

        const Text(
          'Track your health, understand your body,\nand stay healthy.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        _buildRiskCard(),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.calendar_month,
                title: 'Next Period',
                value: '18 Days',
                subtitle: 'Expected on\n28 Aug 2026',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.show_chart,
                title: 'Cycle Length',
                value: '36 Days',
                subtitle: 'Based on last\n3 cycles',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const Text(
          'Health Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dashboardDark,
          ),
        ),

        const SizedBox(height: 12),

        _buildHealthSummary(),

        const SizedBox(height: 24),

        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dashboardDark,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                Icons.health_and_safety_outlined,
                'Risk\nAssessment',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                Icons.calendar_month_outlined,
                'Period\nTracker',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                Icons.restaurant_menu,
                'Nutrition\nPlan',
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildNutritionCard(),

        // Extra space so the last card isn't hidden behind navigation
        const SizedBox(height: 30),
      ],
    ),
  ),
),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: dashboardPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Periods',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF3E9FF),
            Color(0xFFFFF1F8),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.shield_outlined,
                color: dashboardPurple,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'PCOS Risk Level',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: dashboardDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Text(
            'MODERATE RISK',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: dashboardPink,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            '62% Risk Probability',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.62,
              minHeight: 9,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                dashboardPink,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('View Details →'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: dashboardPurple,
            size: 25,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: dashboardDark,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black45,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          _SummaryRow(
            icon: Icons.monitor_weight_outlined,
            title: 'Weight',
            value: '65 kg',
          ),
          Divider(),
          _SummaryRow(
            icon: Icons.calendar_today_outlined,
            title: 'Cycle',
            value: 'Irregular',
          ),
          Divider(),
          _SummaryRow(
            icon: Icons.face_retouching_natural,
            title: 'Symptoms',
            value: 'Moderate',
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      IconData icon,
      String title,
      ) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: dashboardPurple,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: dashboardDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Text(
                'Personalized Nutrition',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: dashboardDark,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            'Your nutrition plan is ready based on your health profile.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'View Nutrition Plan →',
            style: TextStyle(
              color: dashboardPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: dashboardPurple,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: dashboardDark,
          ),
        ),
      ],
    );
  }
}