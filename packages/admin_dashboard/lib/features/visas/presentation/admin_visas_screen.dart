import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminVisasScreen extends ConsumerWidget {
  const AdminVisasScreen({super.key});

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
                      'إدارة بيانات التأشيرات (القسم هـ)',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0E2A47)),
                    ),
                    Text(
                      'إضافة وتعديل دول التأشيرات، الأسعار بالدولار، مدة الإنجاز، وقوائم المستندات المطلوبة',
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
                  label: const Text('إضافة دولة تأشيرة', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Visas Table
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
                    _buildVisaAdminRow('تركيا', 'تأشيرة إلكترونية سياحية', '\$110', 'خلال 24-48 ساعة', 3),
                    _buildVisaAdminRow('الإمارات', 'تأشيرة سياحية لمدة 30 أو 60 يوماً', '\$130', 'خلال 2-3 أيام عمل', 3),
                    _buildVisaAdminRow('مصر', 'الموافقة الأمنية والتأشيرة', '\$95', 'خلال 3-5 أيام عمل', 3),
                    _buildVisaAdminRow('المملكة المتحدة', 'تأشيرة سياحية / زيارة عمل', '\$280', 'خلال 15 يوم عمل', 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisaAdminRow(String country, String title, String price, String time, int docsCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE4DDC9), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(country, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0E2A47)))),
          Expanded(flex: 2, child: Text(title, style: const TextStyle(fontSize: 12))),
          Expanded(child: Text(price, style: const TextStyle(fontWeight: FontWeight.black, fontSize: 14, color: Color(0xFFC9A227)))),
          Expanded(child: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(child: Text('$docsCount مستندات مطلوبة', style: const TextStyle(fontSize: 12))),
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
