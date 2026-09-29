import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedNavIndex = 0;

  final List<AdminNavItem> _navItems = const [
    AdminNavItem(title: 'لوحة المؤشرات', icon: Icons.dashboard_outlined),
    AdminNavItem(title: 'حجوزات الباقات', icon: Icons.luggage_outlined),
    AdminNavItem(title: 'طلبات الرحلات المخصصة', icon: Icons.auto_awesome_outlined),
    AdminNavItem(title: 'طلبات تذاكر الطيران', icon: Icons.flight_outlined),
    AdminNavItem(title: 'طلبات التأشيرات', icon: Icons.assignment_outlined),
    AdminNavItem(title: 'بيانات التأشيرات', icon: Icons.credit_card_outlined),
    AdminNavItem(title: 'محددات مصمم الرحلة', icon: Icons.tune_outlined),
    AdminNavItem(title: 'الباقات السياحية', icon: Icons.travel_explore_outlined),
    AdminNavItem(title: 'العملاء والمستخدمين', icon: Icons.people_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      body: Row(
        children: [
          // Admin Luxury Sidebar (RTL)
          Container(
            width: 260,
            decoration: const BoxDecoration(
              color: Color(0xFF0E2A47),
              border: Border(left: BorderSide(color: Color(0xFFC9A227), width: 1.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Header
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFF081A2E),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9A227),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shield, color: Color(0xFF081A2E), size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'لوحة تحكم النخبة',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'LY-Elite Admin Panel',
                              style: TextStyle(color: Color(0xFFE8D18F), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Admin Profile Badge
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFC9A227),
                        child: Text('ع.م', style: TextStyle(color: Color(0xFF081A2E), fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('عبد الباري معتوق', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('مدير عام (Super Admin)', style: TextStyle(color: Color(0xFFE8D18F), fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Nav Links
                Expanded(
                  child: ListView.builder(
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      final isSelected = _selectedNavIndex === index;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFC9A227) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            item.icon,
                            color: isSelected ? const Color(0xFF081A2E) : Colors.white70,
                            size: 18,
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF081A2E) : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () => setState(() => _selectedNavIndex = index),
                        ),
                      );
                    },
                  ),
                ),

                // Logout
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
                    icon: const Icon(Icons.logout, size: 16),
                    label: const Text('تسجيل الخروج', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Main Admin Content View
          Expanded(
            child: Scaffold(
              backgroundColor: const Color(0xFFF7F4EC),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                title: Text(
                  _navItems[_selectedNavIndex].title,
                  style: const TextStyle(color: Color(0xFF0E2A47), fontWeight: FontWeight.bold, fontSize: 16),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Color(0xFF0E2A47)),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildCurrentAdminView(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentAdminView() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildDashboardOverview();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_navItems[_selectedNavIndex].icon, size: 54, color: const Color(0xFFC9A227)),
              const SizedBox(height: 16),
              Text(
                'قسم ${_navItems[_selectedNavIndex].title}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0E2A47)),
              ),
              const SizedBox(height: 8),
              const Text(
                'متاح بكامل وظائف الإضافة والتعديل والفلترة في لوحة التحكم التفاعلية المباشرة',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildDashboardOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KPI Cards Row
        Row(
          children: [
            _buildStatCard('حجوزات الباقات الجديدة', '14 حجز', Icons.luggage, const Color(0xFFD97706), '+3 اليوم'),
            const SizedBox(width: 16),
            _buildStatCard('طلبات الرحلات المخصصة', '8 طلبات', Icons.auto_awesome, const Color(0xFF2563EB), 'معالج 6 خطوات'),
            const SizedBox(width: 16),
            _buildStatCard('طلبات التأشيرات', '19 طلب', Icons.credit_card, const Color(0xFF059669), 'قيد المعالجة'),
            const SizedBox(width: 16),
            _buildStatCard('إجمالي العملاء المسجلين', '482 عميل', Icons.people, const Color(0xFF0E2A47), 'نشط في النظام'),
          ],
        ),

        const SizedBox(height: 24),

        // Recent Bookings Table
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4DDC9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أحدث الحجوزات والطلبات الواردة',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0E2A47)),
                    ),
                    Text('تحديث تلقائي لحظي', style: TextStyle(fontSize: 12, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTableRow('LY-PKG-2026-1049', 'سحر إسطنبول وطرابزون', 'عبد الباري معتوق', '+218915919921', 'قيد المراجعة', const Color(0xFFD97706)),
                      _buildTableRow('LY-TRIP-2026-5510', 'رحلة عائلية مخصصة (تركيا)', 'محمد الهادي', '+218921112233', 'جارٍ التسعير', const Color(0xFF2563EB)),
                      _buildTableRow('LY-VISA-2026-3021', 'تأشيرة تركيا الإلكترونية', 'أحمد الترهوني', '+218917778899', 'تم الإصدار', const Color(0xFF059669)),
                      _buildTableRow('LY-FLIGHT-2026-8802', 'تذاكر طيران معيتيقة - إسطنبول', 'سالم المقريف', '+218914445566', 'مؤكد', const Color(0xFF059669)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color, String badge) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4DDC9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(badge, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.black, color: Color(0xFF0E2A47))),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String ref, String service, String customer, String phone, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE4DDC9), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(ref, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace'))),
          Expanded(flex: 2, child: Text(service, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0E2A47)))),
          Expanded(child: Text(customer, style: const TextStyle(fontSize: 12))),
          Expanded(child: Text(phone, style: const TextStyle(fontSize: 11, fontFamily: 'monospace'))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class AdminNavItem {
  final String title;
  final IconData icon;

  const AdminNavItem({required this.title, required this.icon});
}
