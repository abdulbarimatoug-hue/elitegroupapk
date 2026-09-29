import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/company_contacts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../core/providers/repository_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text('الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightDividers),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryNavy,
                    child: Icon(Icons.person, size: 36, color: AppColors.accentGold),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'عبد الباري معتوق',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryNavy),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'abdulbari.matoug@gmail.com',
                          style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '+218 91 591 9921',
                          style: TextStyle(fontSize: 12, color: AppColors.accentGold, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primaryNavy),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // WhatsApp Official Channels Card (3 numbers)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightDividers),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.support_agent, color: Color(0xFF059669), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'قنوات التواصل المباشر عبر واتساب',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryNavy),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...CompanyContacts.lines.map((line) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: line.isDefault ? AppColors.goldSoftBg : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: line.isDefault ? AppColors.accentGold.withOpacity(0.5) : AppColors.lightDividers,
                          ),
                        ),
                        child: ListTile(
                          title: Text(line.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text(line.subtitle, style: const TextStyle(fontSize: 11)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('واتساب', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          onTap: () {
                            WhatsAppHelper.launchWhatsApp(
                              phoneNumber: line.number,
                              message: 'مرحباً مجموعة النخبة للسياحة، أود الاستفسار عن خدماتكم.',
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // General Settings & Company Links
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightDividers),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.primaryNavy),
                    title: const Text('عن مجموعة النخبة للخدمات السياحية', style: TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.arrow_back_ios_new, size: 14),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: AppColors.primaryNavy),
                    title: const Text('الشروط والأحكام', style: TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.arrow_back_ios_new, size: 14),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryNavy),
                    title: const Text('سياسة الخصوصية وأمان البيانات', style: TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.arrow_back_ios_new, size: 14),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFDC2626)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await authRepo.signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
