import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/company_contacts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../core/providers/repository_providers.dart';
import 'package:core_domain/entities/booking_entity.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.statusPending;
      case BookingStatus.confirmed:
        return AppColors.statusConfirmed;
      case BookingStatus.completed:
        return AppColors.statusCompleted;
      case BookingStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'قيد المراجعة';
      case BookingStatus.confirmed:
        return 'مؤكد';
      case BookingStatus.completed:
        return 'مكتمل';
      case BookingStatus.cancelled:
        return 'ملغى';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingRepo = ref.watch(bookingRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text('حجوزاتي وطلباتي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: StreamBuilder<List<BookingEntity>>(
        stream: bookingRepo.watchCustomerBookings('current_user_uid'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentGold));
          }

          final bookings = snapshot.data ?? [];
          if (bookings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      'لا توجد لديك أي حجوزات حالية',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryNavy),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'تصفح باقاتنا السياحية أو صمم رحلتك الخاصة لتظهر هنا',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final b = bookings[index];
              final statusColor = _getStatusColor(b.status);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightDividers),
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
                        Text(
                          b.referenceNumber,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            _getStatusText(b.status),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      b.packageTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'تاريخ السفر: ${b.startDate.year}-${b.startDate.month}-${b.startDate.day} • ${b.durationDays} أيام (${b.adultsCount} بالغين${b.childrenCount > 0 ? "، ${b.childrenCount} أطفال" : ""})',
                      style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF059669),
                            padding: EdgeInsets.zero,
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: const Text('تواصل عبر واتساب', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            final msg = 'مرحباً، أود الاستفسار عن حالة حجزي رقم (${b.referenceNumber}) للباقة (${b.packageTitle})';
                            WhatsAppHelper.launchWhatsApp(
                              phoneNumber: b.targetWhatsAppNumber,
                              message: msg,
                            );
                          },
                        ),
                        if (b.status == BookingStatus.pending)
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('إلغاء الحجز', style: TextStyle(fontSize: 12)),
                            onPressed: () async {
                              await bookingRepo.cancelBooking(b.id);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
