import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

// ============================================================
// THEME (same values as the dashboard)
// ============================================================
const Color _bg = Color(0xFFFAF8FC);
const Color _purple = Color(0xFF6C35C9);
const Color _pink = Color(0xFFE84D9B);
const Color _dark = Color(0xFF1D1930);

// ============================================================
// DEMO HEALTH DATA
// TODO: replace with real data saved from the risk assessment
// (your backend or Clerk user metadata).
// ============================================================
class _HealthProfile {
  final int age;
  final double heightCm;
  final double weightKg;
  final String cycleType;
  final int avgCycleDays;
  final String diet;
  final String bloodGroup;
  final String riskLevel;

  const _HealthProfile({
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.cycleType,
    required this.avgCycleDays,
    required this.diet,
    required this.bloodGroup,
    required this.riskLevel,
  });

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));
}

const _demoProfile = _HealthProfile(
  age: 22,
  heightCm: 165,
  weightKg: 65,
  cycleType: 'Irregular',
  avgCycleDays: 36,
  diet: 'Non-vegetarian',
  bloodGroup: 'Not set',
  riskLevel: 'Moderate',
);

// ============================================================
// PROFILE SCREEN
// ============================================================
class ProfileScreen extends StatefulWidget {
  final String userName;
  final String email;

  const ProfileScreen({
    super.key,
    this.userName = 'there',
    this.email = '',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool periodReminders = true;
  bool weeklyTips = false;

  String get _initials {
    final parts = widget.userName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon')),
    );
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to log in again to see your data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Sign out',
              style: TextStyle(color: _pink),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final clerk = ClerkAuth.of(context);
    final navigator = Navigator.of(context);

    await clerk.signOut();

    // The app's home switches to the landing page by itself once the
    // user is signed out. This closes any screens still on top of it.
    navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    const profile = _demoProfile;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: _dark),
        title: const Text(
          'Profile',
          style: TextStyle(color: _dark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),

            // Quick stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.shield_outlined,
                    label: 'Risk Level',
                    value: profile.riskLevel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.show_chart,
                    label: 'Avg Cycle',
                    value: '${profile.avgCycleDays} days',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.monitor_weight_outlined,
                    label: 'BMI',
                    value: profile.bmi.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Health profile
            const _SectionTitle('Health Profile'),
            _CardGroup(
              children: [
                _InfoRow(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: '${profile.age} years',
                ),
                _InfoRow(
                  icon: Icons.height,
                  label: 'Height',
                  value: '${profile.heightCm.toStringAsFixed(0)} cm',
                ),
                _InfoRow(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight',
                  value: '${profile.weightKg.toStringAsFixed(0)} kg',
                ),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Cycle',
                  value: profile.cycleType,
                ),
                _InfoRow(
                  icon: Icons.restaurant_menu,
                  label: 'Diet',
                  value: profile.diet,
                ),
                _InfoRow(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood group',
                  value: profile.bloodGroup,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _comingSoon('Update health details'),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Update details'),
                style: TextButton.styleFrom(foregroundColor: _purple),
              ),
            ),
            const SizedBox(height: 14),

            // Preferences
            const _SectionTitle('Reminders'),
            _CardGroup(
              children: [
                _SwitchRow(
                  icon: Icons.notifications_none,
                  title: 'Period reminders',
                  subtitle: 'Get notified before your next period',
                  value: periodReminders,
                  onChanged: (v) => setState(() => periodReminders = v),
                ),
                _SwitchRow(
                  icon: Icons.lightbulb_outline,
                  title: 'Weekly health tips',
                  subtitle: 'Short tips based on your profile',
                  value: weeklyTips,
                  onChanged: (v) => setState(() => weeklyTips = v),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // More
            const _SectionTitle('More'),
            _CardGroup(
              children: [
                _MenuRow(
                  icon: Icons.history,
                  title: 'Assessment history',
                  onTap: () => _comingSoon('Assessment history'),
                ),
                _MenuRow(
                  icon: Icons.description_outlined,
                  title: 'My reports',
                  onTap: () => _comingSoon('My reports'),
                ),
                _MenuRow(
                  icon: Icons.lock_outline,
                  title: 'Privacy & data',
                  onTap: () => _comingSoon('Privacy & data'),
                ),
                _MenuRow(
                  icon: Icons.help_outline,
                  title: 'Help & support',
                  onTap: () => _comingSoon('Help & support'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E9FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: _purple, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'PCOSense supports health awareness. It is not a '
                      'diagnosis. Please consult a doctor for medical advice.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: _dark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sign out
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _confirmSignOut,
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Sign out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _pink,
                  side: const BorderSide(color: _pink, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Header card -----
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E9FF), Color(0xFFFFF1F8)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: _purple,
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                if (widget.email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () => _comingSoon('Edit profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _purple,
                      side: const BorderSide(color: _purple),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit profile',
                      style: TextStyle(fontSize: 12),
                    ),
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

// ============================================================
// SMALL REUSABLE WIDGETS
// ============================================================
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _dark,
        ),
      ),
    );
  }
}

class _CardGroup extends StatelessWidget {
  final List<Widget> children;
  const _CardGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i != children.length - 1) {
        items.add(const Divider(height: 1, indent: 56));
      }
    }

    return Container(
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
      child: Column(children: items),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Icon(icon, color: _purple, size: 22),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: _purple, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _purple, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _purple,
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _purple, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _dark,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}