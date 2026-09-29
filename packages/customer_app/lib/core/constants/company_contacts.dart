/// Company Contact Constants for LY-Elite Tourism Group (مجموعة النخبة للخدمات السياحية)
class CompanyContacts {
  const CompanyContacts._();

  /// Default WhatsApp number used across all automated conversion buttons
  static const String primaryWhatsApp = '218915919921';

  /// Secondary WhatsApp line 1
  static const String secondaryWhatsApp1 = '218910613800';

  /// Secondary WhatsApp line 2
  static const String secondaryWhatsApp2 = '218910613700';

  /// All official company WhatsApp contact lines
  static const List<WhatsAppLine> lines = [
    WhatsAppLine(
      number: primaryWhatsApp,
      title: 'فريق المبيعات والحجوزات (الرئيسي)',
      subtitle: 'الرد السريع وتأكيد الحجوزات',
      isDefault: true,
    ),
    WhatsAppLine(
      number: secondaryWhatsApp1,
      title: 'خدمة العملاء والاستفسارات',
      subtitle: 'المتابعة والدعم الميداني',
      isDefault: false,
    ),
    WhatsAppLine(
      number: secondaryWhatsApp2,
      title: 'قسم التأشيرات والرحلات الخاصة',
      subtitle: 'تأشيرات السفر وباقات رجال الأعمال',
      isDefault: false,
    ),
  ];
}

class WhatsAppLine {
  final String number;
  final String title;
  final String subtitle;
  final bool isDefault;

  const WhatsAppLine({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.isDefault,
  });

  String get formattedDisplay => '+$number';
}
