import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/entities/travel_package_entity.dart';

class AdminPackagesScreen extends ConsumerWidget {
  const AdminPackagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إدارة الباقات السياحية',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0E2A47)),
                    ),
                    Text(
                      'إضافة، تعديل، وحذف الباقات والعروض الترويجية والبرامج اليومية',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A227),
                    foregroundColor: const Color(0xFF081A2E),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة باقة جديدة', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Packages Table Card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE4DDC9)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPackageAdminRow('سحر إسطنبول والشمال التركي', 'تركيا', '8 أيام / 7 ليالٍ', '\$850', 'نشط', Icons.check_circle, Colors.green),
                    _buildPackageAdminRow('بريق دبي وإجازة التسوق الفاخرة', 'الإمارات', '6 أيام / 5 ليالٍ', '\$720', 'نشط', Icons.check_circle, Colors.green),
                    _buildPackageAdminRow('أسبوع العسل في جزر المالديف', 'المالديف', '7 أيام / 6 ليالٍ', '\$1650', 'نشط', Icons.check_circle, Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageAdminRow(String title, String destination, String duration, String price, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE4DDC9), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0E2A47)))),
          Expanded(child: Text(destination, style: const TextStyle(fontSize: 12))),
          Expanded(child: Text(duration, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(child: Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF0E2A47)))),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF0E2A47)), onPressed: () {}),
              IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
