import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/company_contacts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../core/providers/repository_providers.dart';
import 'package:core_domain/entities/trip_builder_config_entity.dart';
import 'package:core_domain/entities/custom_trip_request_entity.dart';

class CustomTripWizardScreen extends ConsumerStatefulWidget {
  const CustomTripWizardScreen({super.key});

  @override
  ConsumerState<CustomTripWizardScreen> createState() =>
      _CustomTripWizardScreenState();
}

class _CustomTripWizardScreenState
    extends ConsumerState<CustomTripWizardScreen> {
  int _currentStep = 1; // 1 to 6
  bool _isLoadingConfig = true;
  TripBuilderConfigEntity? _config;

  // Step 1 State
  final _nameController = TextEditingController(text: 'عبد الباري معتوق');
  final _phoneController = TextEditingController(text: '+218 91 591 9921');
  String _selectedNationality = 'ليبي';
  String _tripType = 'رحلة عائلية';
  String? _selectedBusinessSector;
  int _adultsCount = 2;
  int _childrenCount = 1;
  final _budgetController = TextEditingController(text: '3500');

  // Step 2 State (Selected Cities & Countries)
  final Set<String> _selectedCityIds = {'c_ist', 'c_trabzon'};
  final Set<String> _selectedCountryIds = {'turkey'};

  // Step 3 State (Flight & Days)
  final _departureCityController = TextEditingController(text: 'طرابلس (معيتيقة)');
  String flightClass = 'اقتصادية'; // معرّف كـ flightClass بدلاً من _flightClass
  DateTime _startDate = DateTime.now().add(const Duration(days: 20));
  int _totalDays = 8;
  String? _selectedReadyPackageId = 'pkg_classic_7';
  final Map<String, int> _cityDaysDistribution = {'إسطنبول': 4, 'طرابزون': 4};
  final Map<String, String> _countryTransit = {'تركيا': 'طيران داخلي'};

  // Step 4 State (Reception & Stay)
  bool _airportMeetAndGreet = true;
  final Set<String> _accommodationTypes = {'فنادق'};
  final Set<String> _starRatings = {'5 نجوم'};
  final Set<String> _additionalServices = {'تأمين سفر دولي معتمد', 'شريحة إنترنت واتصال محلية'};

  // Step 5 State (Preferences)
  String _guideLanguage = 'عربية';
  String _tourType = 'خاصة Private';
  final Set<String> _tourInterests = {'طبيعة وجبال وغابات', 'تسوق ومولات وأسواق شعبية'};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadConfigAndLocalDraft();
  }

  Future<void> _loadConfigAndLocalDraft() async {
    try {
      final tripRepo = ref.read(customTripRepositoryProvider);
      final cfg = await tripRepo.getTripBuilderConfig();
      setState(() {
        _config = cfg;
        _isLoadingConfig = false;
      });

      // Load draft from SharedPreferences if exists
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('custom_trip_draft');
      if (draftJson != null) {
        final map = jsonDecode(draftJson) as Map<String, dynamic>;
        if (map['currentStep'] != null) {
          _currentStep = map['currentStep'] as int;
        }
      }
    } catch (_) {
      setState(() => _isLoadingConfig = false);
    }
  }

  Future<void> _saveLocalDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftMap = {
      'currentStep': _currentStep,
      'customerName': _nameController.text,
      'customerPhone': _phoneController.text,
      'tripType': _tripType,
      'adultsCount': _adultsCount,
      'childrenCount': _childrenCount,
      'budget': _budgetController.text,
      'selectedCities': _selectedCityIds.toList(),
      'totalDays': _totalDays,
    };
    await prefs.setString('custom_trip_draft', jsonEncode(draftMap));
  }

  bool _validateStep() {
    if (_currentStep == 1) {
      if (_nameController.text.trim().isEmpty) {
        _showError('يرجى كتابة الاسم الكامل');
        return false;
      }
      if (_phoneController.text.trim().isEmpty) {
        _showError('يرجى إدخال رقم الهاتف');
        return false;
      }
      final budget = double.tryParse(_budgetController.text) ?? 0;
      final minBudget = _config?.minimumBudgetUsd ?? 1500;
      if (budget < minBudget) {
        _showError('الحد الأدنى لميزانية الرحلة هو \$$minBudget');
        return false;
      }
      if (_tripType == 'رحلة عمل' && _selectedBusinessSector == null) {
        _showError('يرجى تحديد قطاع الأعمال للرحلة');
        return false;
      }
    } else if (_currentStep == 2) {
      if (_selectedCityIds.isEmpty) {
        _showError('يرجى اختيار مدينة واحدة على الأقل');
        return false;
      }
    } else if (_currentStep == 3) {
      if (_departureCityController.text.trim().isEmpty) {
        _showError('يرجى تحديد مدينة الانطلاق');
        return false;
      }
      final sumDays = _cityDaysDistribution.values.fold<int>(0, (a, b) => a + b);
      if (sumDays != _totalDays) {
        _showError('مجموع توزيع الأيام على المدن ($sumDays) يجب أن يطابق إجمالي مدة الرحلة ($_totalDays)');
        return false;
      }
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: const Color(0xFFDC2626), content: Text(msg, textDirection: TextDirection.rtl)),
    );
  }

  void _nextStep() {
    if (_validateStep()) {
      _saveLocalDraft();
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitRequest(String targetWhatsApp) async {
    setState(() => _isSubmitting = true);
    try {
      final tripRepo = ref.read(customTripRepositoryProvider);

      final req = CustomTripRequestEntity(
        id: '',
        referenceNumber: '',
        userId: 'current_user_uid',
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        nationality: _selectedNationality,
        tripType: _tripType,
        businessSector: _selectedBusinessSector,
        adultsCount: _adultsCount,
        childrenCount: _childrenCount,
        dedicatedBudgetUsd: double.tryParse(_budgetController.text) ?? 2000,
        selectedCityNames: _selectedCityIds.toList(),
        selectedCountryNames: _selectedCountryIds.toList(),
        departureCity: _departureCityController.text.trim(),
        flightClass: flightClass,
        startDate: _startDate,
        totalDays: _totalDays,
        packageChoiceType: 'custom',
        cityDaysDistribution: _cityDaysDistribution,
        countryTransitPreferences: _countryTransit,
        estimatedCalculatedCostUsd: 3800.0,
        airportMeetAndGreet: _airportMeetAndGreet,
        accommodationTypes: _accommodationTypes.toList(),
        starRatings: _starRatings.toList(),
        additionalServices: _additionalServices.toList(),
        guideLanguage: _guideLanguage,
        tourType: _tourType,
        selectedInterests: _tourInterests.toList(),
        targetWhatsAppNumber: targetWhatsApp,
        createdAt: DateTime.now(),
      );

      final created = await tripRepo.createCustomTripRequest(req);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('custom_trip_draft');

      final msg = '''
مرحباً فريق تصميم الرحلات المخصصة بمجموعة النخبة للسياحة،
أود اعتماد طلب الرحلة المخصصة المنشأ عبر التطبيق:
🔖 الرقم المرجعي: ${created.referenceNumber}
👤 الاسم: ${_nameController.text.trim()}
📱 الهاتف: ${_phoneController.text.trim()}
🌍 الوجهات: ${_selectedCountryIds.join(', ')}
✈️ مدينة الانطلاق: ${_departureCityController.text.trim()} ($flightClass)
📅 تاريخ البدء: ${_startDate.year}-${_startDate.month}-${_startDate.day} (مدة $_totalDays أيام)
👥 المسافرون: $_adultsCount بالغين، $_childrenCount أطفال
💰 الميزانية المخصصة: \$${_budgetController.text}
🏨 الإقامة: ${_starRatings.join(', ')} (${_accommodationTypes.join(', ')})
🚗 الاستقبال بالمطار: ${_airportMeetAndGreet ? "نعم" : "لا"}
🗣️ المرشد: $_guideLanguage (${_tourType})

أرجو تزويدي بالبرنامج التفصيلي وعرض السعر المعتمد.
''';

      await WhatsAppHelper.launchWhatsApp(phoneNumber: targetWhatsApp, message: msg);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF059669),
            content: Text('تم حفظ الرحلة المخصصة بنجاح برقم: ${created.referenceNumber}', textDirection: TextDirection.rtl),
          ),
        );
      }
    } catch (e) {
      _showError('حدث خطأ: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingConfig) {
      return const Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Center(child: CircularProgressIndicator(color: AppColors.accentGold)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text('مصمم الرحلة المخصصة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.primaryNavyDark,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الخطوة $_currentStep من 6',
                  style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  _getStepTitle(_currentStep),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: _currentStep / 6,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentStep == 1) _buildStep1BasicInfo(),
            if (_currentStep == 2) _buildStep2Destinations(),
            if (_currentStep == 3) _buildStep3FlightsAndDays(),
            if (_currentStep == 4) _buildStep4StayAndReception(),
            if (_currentStep == 5) _buildStep5TourPreferences(),
            if (_currentStep == 6) _buildStep6BoardingPassSummary(),
          ],
        ),
      ),
      bottomNavigationBar: _currentStep < 6
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.lightDividers)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    if (_currentStep > 1)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryNavy),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('رجوع', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    if (_currentStep > 1) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          foregroundColor: AppColors.primaryNavyDark,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('التالي', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1: return 'بيانات الرحلة الأساسية';
      case 2: return 'الوجهات والمدن';
      case 3: return 'الطيران والباكج وتوزيع الأيام';
      case 4: return 'الاستقبال والإقامة';
      case 5: return 'تفضيلات الجولات';
      case 6: return 'بطاقة الصعود والملخص';
      default: return '';
    }
  }

  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'الاسم الكامل *', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'رقم الهاتف (+218) *', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const Text('نوع الرحلة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['شهر عسل', 'رحلة شبابية', 'رحلة عائلية', 'رحلة عمل'].map((t) {
            final isSel = _tripType == t;
            return ChoiceChip(
              label: Text(t, style: TextStyle(color: isSel ? Colors.white : AppColors.primaryNavy, fontWeight: FontWeight.bold)),
              selected: isSel,
              selectedColor: AppColors.primaryNavy,
              onSelected: (val) => setState(() => _tripType = t),
            );
          }).toList(),
        ),
        if (_tripType == 'رحلة عمل') ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedBusinessSector,
            hint: const Text('اختر قطاع الأعمال'),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: (_config?.businessSectors ?? []).map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _selectedBusinessSector = v),
          ),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'الميزانية المخصصة بالدولار ($1500 كحد أدنى) *', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildStep2Destinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر المدن التي تود زيارتها:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        ...(_config?.countries ?? []).map((c) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryNavy)),
                      if (c.requiresVisa)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(10)),
                          child: Text('تحتاج تأشيرة (\$${c.visaPriceUsd?.toInt()})', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: c.cities.map((city) {
                      final isSel = _selectedCityIds.contains(city.id);
                      return FilterChip(
                        label: Text(city.name),
                        selected: isSel,
                        selectedColor: AppColors.accentGold,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedCityIds.add(city.id);
                              _selectedCountryIds.add(c.id);
                              _cityDaysDistribution.putIfAbsent(city.name, () => 3);
                            } else {
                              _selectedCityIds.remove(city.id);
                              _cityDaysDistribution.remove(city.name);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildStep3FlightsAndDays() {
    final sumDays = _cityDaysDistribution.values.fold<int>(0, (a, b) => a + b);
    final isMatch = sumDays == _totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(controller: _departureCityController, decoration: const InputDecoration(labelText: 'مدينة الانطلاق *', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        Row(
          children: ['اقتصادية', 'رجال أعمال'].map((c) {
            final isSel = flightClass == c;
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ChoiceChip(
                label: Text(c),
                selected: isSel,
                selectedColor: AppColors.primaryNavy,
                labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.primaryNavy),
                onSelected: (v) => setState(() => flightClass = c),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMatch ? Colors.green.shade50 : Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('مجموع الأيام الموزعة: $sumDays من $_totalDays', style: TextStyle(fontWeight: FontWeight.bold, color: isMatch ? Colors.green.shade900 : Colors.amber.shade900)),
              Text(isMatch ? 'متطابق ✓' : 'غير متطابق ⚠️', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isMatch ? Colors.green : Colors.amber.shade900)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._cityDaysDistribution.keys.map((cityName) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cityName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline)
