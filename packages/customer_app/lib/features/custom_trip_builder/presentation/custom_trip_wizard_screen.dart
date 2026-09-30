import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer_app/core/constants/company_contacts.dart';
import 'package:customer_app/core/theme/app_colors.dart';
import 'package:customer_app/core/utils/whatsapp_helper.dart';
import 'package:customer_app/core/providers/repository_providers.dart';
import 'package:customer_app/features/custom_trip_builder/domain/entities/trip_builder_config_entity.dart';
import 'package:customer_app/features/custom_trip_builder/domain/entities/custom_trip_request_entity.dart';

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
  final String _selectedNationality = 'ليبي';
  String _tripType = 'رحلة عائلية';
  String? _selectedBusinessSector;
  int _adultsCount = 2;
  int _childrenCount = 1;
  final _budgetController = TextEditingController(text: '3500');

  // Step 2 State
  final Set<String> _selectedCityIds = {'c_ist', 'c_trabzon'};
  final Set<String> _selectedCountryIds = {'turkey'};

  // Step 3 State
  final _departureCityController = TextEditingController(text: 'طرابلس (معيتيقة)');
  String flightClass = 'اقتصادية';
  DateTime _startDate = DateTime.now().add(const Duration(days: 20));
  int _totalDays = 8;
  final Map<String, int> _cityDaysDistribution = {'إسطنبول': 4, 'طرابزون': 4};
  final Map<String, String> _countryTransit = {'تركيا': 'طيران داخلي'};

  // Step 4 State
  bool _airportMeetAndGreet = true;
  final Set<String> _accommodationTypes = {'فنادق'};
  final Set<String> _starRatings = {'5 نجوم'};
  final Set<String> _additionalServices = {'تأمين سفر دولي معتمد', 'شريحة إنترنت واتصال محلية'};

  // Step 5 State
  String _guideLanguage = 'عربية';
  String _tourType = 'خاصة Private';
  final Set<String> _tourInterests = {'طبيعة وجبال وغابات', 'تسوق ومولات وأسوق شعبية'};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadConfigAndLocalDraft();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _budgetController.dispose();
    _departureCityController.dispose();
    super.dispose();
  }

  Future<void> _loadConfigAndLocalDraft() async {
    try {
      final tripRepo = ref.read(customTripRepositoryProvider);
      final cfg = await tripRepo.getTripBuilderConfig();
      if (mounted) {
        setState(() {
          _config = cfg;
          _isLoadingConfig = false;
        });
      }

      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('custom_trip_draft');
      if (draftJson != null) {
        final map = jsonDecode(draftJson) as Map<String, dynamic>;
        if (map['currentStep'] != null && mounted) {
          setState(() {
            _currentStep = map['currentStep'] as int;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingConfig = false);
      }
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
      SnackBar(
        backgroundColor: const Color(0xFFDC2626),
        content: Text(msg, textDirection: TextDirection.rtl),
      ),
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

      final formattedDate = "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}";

      final msg = '''
مرحباً فريق تصميم الرحلات المخصصة بمجموعة النخبة للسياحة،
أود اعتماد طلب الرحلة المخصصة المنشأ عبر التطبيق:
🔖 الرقم المرجعي: ${created.referenceNumber}
👤 الاسم: ${_nameController.text.trim()}
📱 الهاتف: ${_phoneController.text.trim()}
🌍 الوجهات: ${_selectedCountryIds.join(', ')}
✈️ مدينة الانطلاق: ${_departureCityController.text.trim()} ($flightClass)
📅 تاريخ البدء: $formattedDate (مدة $_totalDays أيام)
👥 المسافرون: $_adultsCount بالغين، $_childrenCount أطفال
💰 الميزانية المخصصة: \$${_budgetController.text}
🏨 الإقامة: ${_starRatings.join(', ')} (${_accommodationTypes.join(', ')})
🚗 الاستقبال بالمطار: ${_airportMeetAndGreet ? "نعم" : "لا"}
🗣️ المرشد: $_guideLanguage ($_tourType)

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
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'الاسم الكامل *', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'رقم الهاتف (+218) *', border: OutlineInputBorder()),
        ),
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
            value: (_config?.businessSectors ?? []).contains(_selectedBusinessSector)
                ? _selectedBusinessSector
                : null,
            hint: const Text('اختر قطاع الأعمال'),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: (_config?.businessSectors ?? []).map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _selectedBusinessSector = v),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('بالغين'),
                subtitle: Text('$_adultsCount'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _adultsCount > 1 ? () => setState(() => _adultsCount--) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _adultsCount++),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('أطفال'),
                subtitle: Text('$_childrenCount'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _childrenCount > 0 ? () => setState(() => _childrenCount--) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _childrenCount++),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'الميزانية المخصصة بالدولار (\$1500 كحد أدنى) *',
            border: OutlineInputBorder(),
          ),
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

                              bool hasOtherCities = c.cities.any((otherCity) => _selectedCityIds.contains(otherCity.id));
                              if (!hasOtherCities) {
                                _selectedCountryIds.remove(c.id);
                              }
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
        TextField(
          controller: _departureCityController,
          decoration: const InputDecoration(labelText: 'مدينة الانطلاق *', border: OutlineInputBorder()),
        ),
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
        ListTile(
          title: const Text('إجمالي عدد الأيام'),
          trailing: DropdownButton<int>(
            value: _totalDays,
            items: List.generate(30, (i) => i + 1)
                .map((d) => DropdownMenuItem(value: d, child: Text('$d أيام')))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _totalDays = v);
            },
          ),
        ),
        const Divider(),
        const Text('توزيع الأيام على المدن:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        ..._cityDaysDistribution.keys.map((cityName) {
          final days = _cityDaysDistribution[cityName] ?? 1;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cityName),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: days > 1 ? () => setState(() => _cityDaysDistribution[cityName] = days - 1) : null,
                  ),
                  Text('$days يوم'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _cityDaysDistribution[cityName] = days + 1),
                  ),
                ],
              ),
            ],
          );
        }),
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
              Text(
                'مجموع الأيام الموزعة: $sumDays من $_totalDays',
                style: TextStyle(fontWeight: FontWeight.bold, color: isMatch ? Colors.green.shade900 : Colors.amber.shade900),
              ),
              Text(
                isMatch ? 'متطابق ✓' : 'غير متطابق ⚠',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isMatch ? Colors.green.shade900 : Colors.amber.shade900),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep4StayAndReception() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('خدمة الاستقبال والتوديع في المطار'),
          value: _airportMeetAndGreet,
          onChanged: (v) => setState(() => _airportMeetAndGreet = v),
        ),
        const Divider(),
        const Text('نوع الإقامة المفضل:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['فنادق', 'شقق فندقية', 'فلل خاصة'].map((type) {
            final isSel = _accommodationTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSel,
              onSelected: (val) {
                setState(() {
                  val ? _accommodationTypes.add(type) : _accommodationTypes.remove(type);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('فئة التصنيف:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['4 نجوم', '5 نجوم', 'فاخر VIP'].map((star) {
            final isSel = _starRatings.contains(star);
            return FilterChip(
              label: Text(star),
              selected: isSel,
              onSelected: (val) {
                setState(() {
                  val ? _starRatings.add(star) : _starRatings.remove(star);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep5TourPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('لغة المرشد السياحي:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['عربية', 'إنجليزية', 'تركمانية / محلية'].map((lang) {
            final isSel = _guideLanguage == lang;
            return ChoiceChip(
              label: Text(lang),
              selected: isSel,
              onSelected: (val) => setState(() => _guideLanguage = lang),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('نوع الجولات:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['خاصة Private', 'ضمن مجموعة Group'].map((t) {
            final isSel = _tourType == t;
            return ChoiceChip(
              label: Text(t),
              selected: isSel,
              onSelected: (val) => setState(() => _tourType = t),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('اهتمامات الجولات:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['طبيعة وجبال وغابات', 'تسوق ومولات وأسوق شعبية', 'معالم تاريخية وثقافية', 'أنشطة مغامرة وألعاب مائية'].map((interest) {
            final isSel = _tourInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSel,
              onSelected: (val) {
                setState(() {
                  val ? _tourInterests.add(interest) : _tourInterests.remove(interest);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep6BoardingPassSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('بطاقة ملخص الرحلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                    Icon(Icons.flight_takeoff, color: AppColors.accentGold),
                  ],
                ),
                const Divider(),
                Text('الاسم: ${_nameController.text}'),
                Text('الهاتف: ${_phoneController.text}'),
                Text('نوع الرحلة: $_tripType'),
                Text('الميزانية: \$${_budgetController.text}'),
                Text('مدينة الانطلاق: ${_departureCityController.text} ($flightClass)'),
                Text('مدة الرحلة: $_totalDays أيام'),
                Text('الإقامة: ${_starRatings.join(', ')}'),
                Text('المرشد: $_guideLanguage ($_tourType)'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (_isSubmitting)
          const Center(child: CircularProgressIndicator())
        else
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('إرسال عبر الواتساب (المقر الرئيسي)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _submitRequest(CompanyContacts.primaryWhatsApp),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
