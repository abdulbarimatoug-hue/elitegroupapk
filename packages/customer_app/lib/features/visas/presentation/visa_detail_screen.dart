import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/company_contacts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../core/providers/repository_providers.dart';
import 'package:core_domain/entities/visa_entity.dart';
import 'package:core_domain/entities/visa_request_entity.dart';

class VisaDetailScreen extends ConsumerStatefulWidget {
  final VisaEntity visa;

  const VisaDetailScreen({super.key, required this.visa});

  @override
  ConsumerState<VisaDetailScreen> createState() => _VisaDetailScreenState();
}

class _VisaDetailScreenState extends ConsumerState<VisaDetailScreen> {
  final _nameController = TextEditingController(text: 'عبد الباري معتوق');
  final _phoneController = TextEditingController(text: '+218915919921');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _requestVisa() async {
    setState(() => _isSubmitting = true);
    try {
      final visaRepo = ref.read(visaRepositoryProvider);

      final req = VisaRequestEntity(
        id: '',
        referenceNumber: '',
        visaId: widget.visa.id,
        countryName: widget.visa.countryName,
        visaTitle: widget.visa.visaTitle,
        priceUsd: widget.visa.priceUsd,
        processingTime: widget.visa.processingTime,
        userId: 'current_user_uid',
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        status: VisaRequestStatus.pending,
        targetWhatsAppNumber: CompanyContacts.primaryWhatsApp,
        createdAt: DateTime.now(),
      );

      final createdReq = await visaRepo.createVisaRequest(req);

      final message = '''
مرحباً قسم التأشيرات بمجموعة النخبة للسياحة، أود التقديم على التأشيرة:
🌍 الدولة: ${widget.visa.countryName}
📄 نوع التأشيرة: ${widget.visa.visaTitle}
💰 الرسوم: \$${widget.visa.priceUsd.toInt()}
⏱️ مدة الإنجاز: ${widget.visa.processingTime}
🔖 الرقم المرجعي: ${createdReq.referenceNumber}
👤 الاسم: ${_nameController.text.trim()}
📱 الهاتف: ${_phoneController.text.trim()}

أرجو تزويدي بالإجراءات والخطوات التالية لإرسال المستندات وتأكيد الطلب.
''';

      await WhatsAppHelper.launchWhatsApp(
        phoneNumber: CompanyContacts.primaryWhatsApp,
        message: message,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF059669),
            content: Text(
              'تم حفظ طلب التأشيرة بنجاح برقم: ${createdReq.referenceNumber} وجارٍ فتح واتساب...',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFDC2626),
            content: Text('حدث خطأ: $e', textDirection: TextDirection.rtl),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.visa;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: Text(v.countryName, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Card Header with Price Tag
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightDividers),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.visaTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'تأشيرة رسمية معتمدة لدولة ${v.countryName}',
                            style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                          ),
                        ],
                      ),
                      // Colored Price Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '\$${v.priceUsd.toInt()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.black,
                            color: AppColors.primaryNavyDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Processing time
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.accentGold, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'مدة الإنجاز المتوقعة: ',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        v.processingTime,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Required Documents Section (Bullet List)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                      Icon(Icons.assignment_outlined, color: AppColors.primaryNavy, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'المستندات والمتطلبات اللازمة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...v.requiredDocuments.map((doc) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4, left: 8),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.accentGold,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                doc,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.lightTextPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Button: Order via WhatsApp
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: AppColors.primaryNavyDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: _isSubmitting ? null : _requestVisa,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: AppColors.primaryNavyDark)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'اطلب هذه التأشيرة عبر واتساب',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
