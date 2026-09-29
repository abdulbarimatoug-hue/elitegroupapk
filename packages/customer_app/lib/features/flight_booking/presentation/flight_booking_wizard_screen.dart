import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/company_contacts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../core/providers/repository_providers.dart';
import 'package:core_domain/entities/flight_booking_request_entity.dart';

class FlightBookingWizardScreen extends ConsumerStatefulWidget {
  const FlightBookingWizardScreen({super.key});

  @override
  ConsumerState<FlightBookingWizardScreen> createState() =>
      _FlightBookingWizardScreenState();
}

class _FlightBookingWizardScreenState
    extends ConsumerState<FlightBookingWizardScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'عبد الباري معتوق');
  final _phoneController = TextEditingController(text: '+218 91 591 9921');

  FlightTripType _tripType = FlightTripType.roundTrip;
  final _departureCityController = TextEditingController(text: 'طرابلس (TIP)');
  final _arrivalCityController = TextEditingController(text: 'إسطنبول (IST)');
  DateTime _departureDate = DateTime.now().add(const Duration(days: 10));
  DateTime _returnDate = DateTime.now().add(const Duration(days: 20));

  // Multi-city dynamic segments
  final List<Map<String, dynamic>> _multiSegments = [
    {'from': 'طرابلس', 'to': 'إسطنبول', 'date': DateTime.now().add(const Duration(days: 10))},
    {'from': 'إسطنبول', 'to': 'دبي', 'date': DateTime.now().add(const Duration(days: 16))},
    {'from': 'دبي', 'to': 'طرابلس', 'date': DateTime.now().add(const Duration(days: 22))},
  ];

  int _adultsCount = 1;
  int _childrenCount = 0;
  int _infantsCount = 0;

  String _baggage = '23 كيلو';
  final List<String> _baggageOptions = [
    'بدون وزن',
    '8 كيلو حقيبة يد',
    '15 كيلو',
    '23 كيلو',
    '40 كيلو',
  ];

  String _flightClass = 'اقتصادية';

  bool _isSubmitting = false;

  Future<void> _submitFlightBooking(String targetPhone) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final flightRepo = ref.read(flightBookingRepositoryProvider);

      final req = FlightBookingRequestEntity(
        id: '',
        referenceNumber: '',
        userId: 'current_user_uid',
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        tripType: _tripType,
        departureCity: _tripType != FlightTripType.multiCity ? _departureCityController.text.trim() : null,
        arrivalCity: _tripType != FlightTripType.multiCity ? _arrivalCityController.text.trim() : null,
        departureDate: _tripType != FlightTripType.multiCity ? _departureDate : null,
        returnDate: _tripType == FlightTripType.roundTrip ? _returnDate : null,
        multiCitySegments: _tripType == FlightTripType.multiCity
            ? _multiSegments.map((s) => FlightSegment(fromCity: s['from'], toCity: s['to'], flightDate: s['date'])).toList()
            : [],
        adultsCount: _adultsCount,
        childrenCount: _childrenCount,
        infantsCount: _infantsCount,
        baggageAllowance: _baggage,
        flightClass: _flightClass,
        targetWhatsAppNumber: targetPhone,
        status: FlightBookingStatus.pending,
        createdAt: DateTime.now(),
      );

      final created = await flightRepo.createFlightBookingRequest(req);

      final typeStr = _tripType == FlightTripType.roundTrip
          ? 'ذهاب وعودة'
          : (_tripType == FlightTripType.oneWay ? 'ذهاب فقط' : 'مدن متعددة');

      final msg = '''
مرحباً فريق حجز تذاكر الطيران بمجموعة النخبة للسياحة،
أود طلب حجز تذاكر طيران بالمواصفات التالية:
🔖 الرقم المرجعي: ${created.referenceNumber}
✈️ نوع الرحلة: $typeStr
📍 المسار: ${_tripType != FlightTripType.multiCity ? '${_departureCityController.text} ➔ ${_arrivalCityController.text}' : 'مقاطع متعددة'}
📅 تاريخ السفر: ${_departureDate.year}-${_departureDate.month}-${_departureDate.day}${_tripType == FlightTripType.roundTrip ? ' (العودة: ${_returnDate.year}-${_returnDate.month}-${_returnDate.day})' : ''}
👥 المسافرون: $_adultsCount بالغين، $_childrenCount أطفال، $_infantsCount رضع
🧳 الوزن المطلوب: $_baggage
💺 الدرجة: $_flightClass
👤 العميل: ${_nameController.text.trim()} (${_phoneController.text.trim()})

يرجى إفادتي بأفضل رحلات الطيران المتوفرة والأسعار لتأكيد التذاكر.
''';

      await WhatsAppHelper.launchWhatsApp(phoneNumber: targetPhone, message: msg);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF059669),
            content: Text('تم تسجيل طلب حجز الطيران بنجاح برقم: ${created.referenceNumber}', textDirection: TextDirection.rtl),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: const Color(0xFFDC2626), content: Text('حدث خطأ: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text('احجز تذكرتك الآن (طيران)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact info
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'الاسم الكامل *', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'مطلوب' : null),
              const SizedBox(height: 10),
              TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف (+218) *', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'مطلوب' : null),
              const SizedBox(height: 16),

              // Trip Type
              const Text('نوع الرحلة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTripTypeChip('ذهاب وعودة', FlightTripType.roundTrip),
                  const SizedBox(width: 8),
                  _buildTripTypeChip('ذهاب فقط', FlightTripType.oneWay),
                  const SizedBox(width: 8),
                  _buildTripTypeChip('مدن متعددة', FlightTripType.multiCity),
                ],
              ),
              const SizedBox(height: 16),

              // Standard Departure/Arrival or Multi-City
              if (_tripType != FlightTripType.multiCity) ...[
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _departureCityController, decoration: const InputDecoration(labelText: 'من (المغادرة) *', border: OutlineInputBorder()))),
                    const SizedBox(width: 10),
                    Expanded(child: TextFormField(controller: _arrivalCityController, decoration: const InputDecoration(labelText: 'إلى (الوصول) *', border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('تاريخ الذهاب', style: TextStyle(fontSize: 11)),
                        subtitle: Text('${_departureDate.year}-${_departureDate.month}-${_departureDate.day}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.calendar_today, size: 18),
                        onTap: () async {
                          final picked = await showDatePicker(context: context, initialDate: _departureDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                          if (picked != null) setState(() => _departureDate = picked);
                        },
                      ),
                    ),
                    if (_tripType == FlightTripType.roundTrip)
                      Expanded(
                        child: ListTile(
                          title: const Text('تاريخ العودة', style: TextStyle(fontSize: 11)),
                          subtitle: Text('${_returnDate.year}-${_returnDate.month}-${_returnDate.day}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: const Icon(Icons.calendar_today, size: 18),
                          onTap: () async {
                            final picked = await showDatePicker(context: context, initialDate: _returnDate, firstDate: _departureDate, lastDate: DateTime.now().add(const Duration(days: 365)));
                            if (picked != null) setState(() => _returnDate = picked);
                          },
                        ),
                      ),
                  ],
                ),
              ] else ...[
                // Multi City Segments
                const Text('مقاطع الرحلة (مدن متعددة):', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._multiSegments.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final seg = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lightDividers)),
                    child: Row(
                      children: [
                        Text('#${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${seg["from"]} ➔ ${seg["to"]}', style: const TextStyle(fontWeight: FontWeight.bold))),
                        Text('${(seg["date"] as DateTime).month}/${(seg["date"] as DateTime).day}', style: const TextStyle(fontSize: 12)),
                        if (_multiSegments.length > 2)
                          IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red), onPressed: () => setState(() => _multiSegments.removeAt(idx))),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 16),

              // Passengers Counters
              const Text('عدد المسافرين:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildCounter('بالغين (+12)', _adultsCount, (v) => setState(() => _adultsCount = v), min: 1),
                  const SizedBox(width: 8),
                  _buildCounter('أطفال (2-11)', _childrenCount, (v) => setState(() => _childrenCount = v)),
                  const SizedBox(width: 8),
                  _buildCounter('رضع (<2)', _infantsCount, (v) => setState(() => _infantsCount = v)),
                ],
              ),

              const SizedBox(height: 16),

              // Baggage Allowance
              const Text('وزن الأمتعة المفضل:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _baggageOptions.map((b) {
                  final isSel = _baggage == b;
                  return ChoiceChip(
                    label: Text(b),
                    selected: isSel,
                    selectedColor: AppColors.accentGold,
                    onSelected: (val) => setState(() => _baggage = b),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Flight Class
              const Text('درجة الطيران:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: ['اقتصادية', 'رجال أعمال'].map((c) {
                  final isSel = _flightClass == c;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: isSel,
                      selectedColor: AppColors.primaryNavy,
                      labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.primaryNavy),
                      onSelected: (val) => setState(() => _flightClass = c),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // 3 WhatsApp Action Buttons
              const Text('إرسال طلب الحجز إلى فريقك المختار عبر واتساب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryNavy)),
              const SizedBox(height: 10),

              ...CompanyContacts.lines.map((line) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: line.isDefault ? AppColors.accentGold : Colors.white,
                        foregroundColor: line.isDefault ? AppColors.primaryNavyDark : AppColors.primaryNavy,
                        side: line.isDefault ? null : const BorderSide(color: AppColors.primaryNavy),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.flight_takeoff),
                      label: Text('${line.title} (${line.formattedDisplay})'),
                      onPressed: _isSubmitting ? null : () => _submitFlightBooking(line.number),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeChip(String label, FlightTripType type) {
    final isSel = _tripType == type;
    return Expanded(
      child: ChoiceChip(
        label: Center(child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? Colors.white : AppColors.primaryNavy))),
        selected: isSel,
        selectedColor: AppColors.primaryNavy,
        onSelected: (val) => setState(() => _tripType = type),
      ),
    );
  }

  Widget _buildCounter(String label, int val, Function(int) onChange, {int min = 0}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lightDividers)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.remove, size: 14), onPressed: () => val > min ? onChange(val - 1) : null),
                Text('$val', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add, size: 14), onPressed: () => onChange(val + 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
