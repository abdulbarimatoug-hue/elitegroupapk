import 'package:url_launcher/url_launcher.dart';
import '../constants/company_contacts.dart';

/// WhatsApp conversion engine: saves requests to database then routes directly to WhatsApp chat
class WhatsAppHelper {
  const WhatsAppHelper._();

  /// Build wa.me URI with URL-encoded text
  static Uri buildWhatsAppUri({
    String? phoneNumber,
    required String message,
  }) {
    final targetPhone = phoneNumber ?? CompanyContacts.primaryWhatsApp;
    final encodedText = Uri.encodeComponent(message);
    return Uri.parse('https://wa.me/$targetPhone?text=$encodedText');
  }

  /// Launch WhatsApp chat in external application
  static Future<bool> launchWhatsApp({
    String? phoneNumber,
    required String message,
  }) async {
    final uri = buildWhatsAppUri(phoneNumber: phoneNumber, message: message);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
