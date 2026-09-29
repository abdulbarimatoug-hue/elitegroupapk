# دليل ونموذج توثيق مستودعات وهيكل بيانات Firestore
## مجموعة النخبة للخدمات السياحية (LY-Elite Tourism Group)
### الإصدار: 1.0.0 (Production Architecture Documentation)

---

## 📑 جدول المحتويات
1. [معمارية المستودعات (Firestore Repositories Architecture)](#1-معمارية-المستودعات-firestore-repositories-architecture)
2. [دورة حياة البيانات وتدفق الطلبات (Data Flow & Lifecycle)](#2-دورة-حياة-البيانات-وتدفق-الطلبات-data-flow--lifecycle)
3. [محددات وقواعد الترقيم المرجعي التلقائي (Reference Generation)](#3-محددات-وقواعد-الترقيم-المرجعي-التلقائي-reference-generation)
4. [هيكل بيانات مجموعة `bookings` (حجوزات الباقات السياحية)](#4-هيكل-بيانات-مجموعة-bookings-حجوزات-الباقات-السياحية)
5. [هيكل بيانات مجموعة `custom_trip_requests` (طلبات مصمم الرحلة المخصصة)](#5-هيكل-بيانات-مجموعة-custom_trip_requests-طلبات-مصمم-الرحلة-المخصصة)
6. [هيكل بيانات مجموعة `visa_requests` (طلبات التأشيرات الواردة)](#6-هيكل-بيانات-مجموعة-visa_requests-طلبات-التأشيرات-الواردة)
7. [المجموعات المساندة (Complementary Collections)](#7-المجموعات-المساندة-complementary-collections)
8. [قواعد الأمان والتحقق من الصلاحيات (Security Rules Mapping)](#8-قواعد-الأمان-والتحقق-من-الصلاحيات-security-rules-mapping)
9. [نماذج كود استدعاء المستودعات (Repository Code Usage Templates)](#9-نماذج-كود-استدعاء-المستودعات-repository-code-usage-templates)

---

## 1. معمارية المستودعات (Firestore Repositories Architecture)

تم تصميم طبقة البيانات وفق مبادئ **Clean Architecture** ونظام **Melos Monorepo**، حيث تم فصل منطق الأعمال تماماً عن مكتبات وتفاصيل Firebase:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Customer Mobile App UI  &  Admin Web Dashboard)     │
└───────────────────────────┬────────────────────────────┘
                            │ (Riverpod Providers)
┌───────────────────────────▼────────────────────────────┐
│                    core_domain                         │
│  • Pure Dart Entities (Business Models)                │
│  • Abstract Interfaces: IBookingRepository, etc.       │
│  • Failures & Domain Exceptions                        │
└───────────────────────────┬────────────────────────────┘
                            │ (Implements Interfaces)
┌───────────────────────────▼────────────────────────────┐
│                     core_data                          │
│  • Data Models (Entity extension + JSON Serialization) │
│  • Concrete Repositories (BookingRepositoryImpl, etc.) │
│  • Cloud Firestore SDK, Auth SDK, Firebase Messaging   │
└────────────────────────────────────────────────────────┘
```

### المبادئ الهندسية المتبعة:
1. **عدم الاعتماد العكسي (Dependency Inversion):** الواجهات تعتمد فقط على عقود مجردة من `core_domain`.
2. **المعاملة الآمنة للتواريخ:** تحويل كائنات `Timestamp` الخاصة بـ Firestore إلى كائنات `DateTime` القياسية في Dart وبالعكس.
3. **التغليف والتحويل الوقائي (Defensive Parsing):** استخدام القيم الافتراضية والتحويل المرن للأرقام `(num?)?.toInt()` لتفادي أخطاء النوع الشائعة.
4. **معالجة الاستثناءات الموحدة:** التقاط أخطاء Firestore وتغليفها داخل `ServerFailure` أو `NetworkFailure`.

---

## 2. دورة حياة البيانات وتدفق الطلبات (Data Flow & Lifecycle)

```
[ العميل يملأ النموذج ]
         │
         ▼
[ توليد رقم مرجعي LY-XXX-YYYY-XXXX ]
         │
         ▼
[ الحفظ في Firestore بحالة: pending ]
         │
         ├──────────────────────────────────────────────┐
         ▼                                              ▼
[ فتح واتساب مع رسالة جاهزة ]               [ ظهور فوري في لوحة تحكم الإدارة ]
(لرقم المبيعات المعتمد)                         (Flutter Web Admin Real-time Stream)
                                                        │
                                                        ▼
                                           [ مراجعة الموظف وتحديث الحالة ]
                                        (pending ➔ confirmed ➔ completed)
                                                        │
                                                        ▼
                                           [ إرسال إشعار فوري FCM للعميل ]
```

---

## 3. محددات وقواعد الترقيم المرجعي التلقائي (Reference Generation)

كل معاملة أو حجز يُمنح رقماً مرجعياً فريداً لضمان سهولة التتبع في مراسلات واتساب ونظام الفواتير:

| نوع الطلب | بادئة الرقم المرجعي | الصيغة القياسية | مثال |
| :--- | :--- | :--- | :--- |
| **حجز باقة سياحية** | `LY-PKG` | `LY-PKG-[السنة]-[4 أرقام عشوائية]` | `LY-PKG-2026-1049` |
| **طلب رحلة مخصصة** | `LY-TRIP` | `LY-TRIP-[السنة]-[4 أرقام عشوائية]` | `LY-TRIP-2026-5510` |
| **طلب تأشيرة إلكترونية** | `LY-VISA` | `LY-VISA-[السنة]-[4 أرقام عشوائية]` | `LY-VISA-2026-3021` |
| **طلب حجز طيران مستقل** | `LY-FLT` | `LY-FLT-[السنة]-[4 أرقام عشوائية]` | `LY-FLT-2026-7782` |

---

## 4. هيكل بيانات مجموعة `bookings` (حجوزات الباقات السياحية)

- **مسار المجموعة (Collection Path):** `/bookings/{bookingId}`
- **وصف المجموعة:** تخزين كافة طلبات حجز الباقات السياحية الجاهزة المقدمة من العملاء.

### جدول الحقول (Schema Fields):

| اسم الحقل | نوع البيانات (Firestore) | الإلزامية | الوصف | مثال واقعي |
| :--- | :--- | :--- | :--- | :--- |
| `referenceNumber` | `String` | إلزامي | الرقم المرجعي الفريد للحجز | `"LY-PKG-2026-1049"` |
| `packageId` | `String` | إلزامي | معرّف الباقة السياحية المحجوزة | `"pkg_istanbul_trabzon_spring"` |
| `packageTitle` | `String` | إلزامي | عنوان الباقة باللغة العربية | `"سحر إسطنبول وطرابزون الفاخر"` |
| `packageDestination` | `String` | إلزامي | وجهة الباقة السياحية | `"تركيا"` |
| `userId` | `String` | إلزامي | معرّف العميل (Firebase Auth UID) | `"usr_elite_ly_9921"` |
| `customerName` | `String` | إلزامي | الاسم الكامل للعميل | `"عبد الباري معتوق"` |
| `customerPhone` | `String` | إلزامي | رقم هاتف العميل بالصيغة الدولية | `"+218 91 591 9921"` |
| `startDate` | `Timestamp` | إلزامي | تاريخ بداية الرحلة المرغوب | `Timestamp(seconds=1778918400)` |
| `returnDate` | `Timestamp` | إلزامي | تاريخ العودة | `Timestamp(seconds=1779523200)` |
| `durationDays` | `Number (int)` | إلزامي | مدة الإقامة بالأيام | `8` |
| `adultsCount` | `Number (int)` | إلزامي | عدد المسافرين البالغين (12+ سنة) | `2` |
| `childrenCount` | `Number (int)` | إلزامي | عدد الأطفال المرافقين | `1` |
| `estimatedTotal` | `Number (double)` | إلزامي | التكلفة التقديرية للحجز بالدولار | `2700.0` |
| `notes` | `String` | اختياري | ملاحظات إضافية من العميل | `"نفضل غرفة بإطلالة بحرية"` |
| `status` | `String` | إلزامي | حالة الحجز (`pending`, `confirmed`, `completed`, `cancelled`) | `"pending"` |
| `targetWhatsAppNumber`| `String` | إلزامي | رقم واتساب الشركة الذي تم توجيه الطلب إليه | `"218915919921"` |
| `createdAt` | `Timestamp` | إلزامي | تاريخ ووقت إنشاء الحجز | `Timestamp.now()` |
| `updatedAt` | `Timestamp` | اختياري | تاريخ آخر تحديث للحالة أو البيانات | `Timestamp.now()` |

### نموذج وثيقة JSON واقعي (Document Sample):
```json
{
  "referenceNumber": "LY-PKG-2026-1049",
  "packageId": "pkg_istanbul_trabzon_spring",
  "packageTitle": "سحر إسطنبول وطرابزون الفاخر",
  "packageDestination": "تركيا",
  "userId": "usr_elite_ly_9921",
  "customerName": "عبد الباري معتوق",
  "customerPhone": "+218 91 591 9921",
  "startDate": "2026-05-15T00:00:00.000Z",
  "returnDate": "2026-05-23T00:00:00.000Z",
  "durationDays": 8,
  "adultsCount": 2,
  "childrenCount": 1,
  "estimatedTotal": 2700.0,
  "notes": "نفضل غرفة بإطلالة بحرية وسرير إضافي للأطفال",
  "status": "pending",
  "targetWhatsAppNumber": "218915919921",
  "createdAt": "2026-04-10T14:32:00.000Z",
  "updatedAt": null
}
```

---

## 5. هيكل بيانات مجموعة `custom_trip_requests` (طلبات مصمم الرحلة المخصصة)

- **مسار المجموعة (Collection Path):** `/custom_trip_requests/{requestId}`
- **وصف المجموعة:** تخزين تفاصيل برنامج الرحلة المصممة عبر معالج الـ 6 خطوات التفاعلي.

### جدول الحقول (Schema Fields):

| اسم الحقل | نوع البيانات (Firestore) | الإلزامية | الخطوة المرتبطة | الوصف والمثال |
| :--- | :--- | :--- | :--- | :--- |
| `referenceNumber` | `String` | إلزامي | - | الرقم المرجعي `"LY-TRIP-2026-5510"` |
| `userId` | `String` | إلزامي | الخطوة 1 | معرّف صاحب الطلب |
| `customerName` | `String` | إلزامي | الخطوة 1 | الاسم الكامل للعميل |
| `customerPhone` | `String` | إلزامي | الخطوة 1 | هاتف العميل للتواصل وتأكيد الحجز |
| `nationality` | `String` | إلزامي | الخطوة 1 | جنسية المسافر الرئيسي (`"ليبي"`) |
| `tripType` | `String` | إلزامي | الخطوة 1 | نوع الرحلة (`"عائلية"`, `"عمل"`, `"شبابية"`, `"شهر عسل"`) |
| `businessSector` | `String` | اختياري | الخطوة 1 | قطاع الأعمال في حال كانت الرحلة لرجال الأعمال |
| `adultsCount` | `Number (int)` | إلزامي | الخطوة 1 | عدد المسافرين البالغين (مثال: `2`) |
| `childrenCount` | `Number (int)` | إلزامي | الخطوة 1 | عدد الأطفال (مثال: `2`) |
| `dedicatedBudgetUsd` | `Number (double)`| إلزامي | الخطوة 1 | الميزانية المرصودة (الحد الأدنى $1500) |
| `selectedCountryNames`| `Array<String>` | إلزامي | الخطوة 2 | الدول المختارة `["تركيا"]` |
| `selectedCityNames` | `Array<String>` | إلزامي | الخطوة 2 | المدن المختارة `["إسطنبول", "طرابزون"]` |
| `includesVisaAssistance`| `Boolean` | إلزامي | الخطوة 2 | هل يطلب العميل مساعدة في استخراج التأشيرة؟ |
| `departureCity` | `String` | إلزامي | الخطوة 3 | مطار الانطلاق (`"طرابلس (مطار معيتيقة)"`) |
| `flightClass` | `String` | إلزامي | الخطوة 3 | درجة الطيران (`"اقتصادية"`, `"رجال أعمال"`) |
| `startDate` | `Timestamp` | إلزامي | الخطوة 3 | موعد السفر المبدئي |
| `totalDays` | `Number (int)` | إلزامي | الخطوة 3 | إجمالي مدة الرحلة بالأيام (مثال: `9`) |
| `packageChoiceType` | `String` | إلزامي | الخطوة 3 | تخصيص كامل أو دمج باقة (`"custom_modular"`) |
| `cityDaysDistribution`| `Map<String, int>`| إلزامي | الخطوة 3 | توزيع الليالي: `{"إسطنبول": 5, "طرابزون": 4}` |
| `countryTransitPreferences`| `Map<String, String>`| اختياري| الخطوة 3 | وسيلة التنقل الداخلي: `{"turkey": "طيران داخلي"}` |
| `estimatedCalculatedCostUsd`| `Number (double)`| إلزامي| الخطوة 3 | التكلفة التقريبية المحسوبة في المعالج |
| `airportMeetAndGreet`| `Boolean` | إلزامي | الخطوة 4 | خدمة الاستقبال والتوديع في المطار |
| `accommodationTypes` | `Array<String>` | إلزامي | الخطوة 4 | نوع السكن `["فندق 5 نجوم", "منتجع فاخر"]` |
| `starRatings` | `Array<int>` | إلزامي | الخطوة 4 | تصنيف النجوم المفضل `[5]` |
| `additionalServices` | `Array<String>` | اختياري | الخطوة 4 | سيارة خاصة، شريحة إنترنت، إلخ. |
| `guideLanguage` | `String` | إلزامي | الخطوة 5 | لغة المرشد السياحي (`"عربي"`, `"إنجليزي"`) |
| `tourType` | `String` | إلزامي | الخطوة 5 | نمط الجولات (`"جولات خاصة مع سائق VIP"`) |
| `selectedInterests` | `Array<String>` | اختياري | الخطوة 5 | اهتمامات المسافر (تسوق، طبيعة، آثار) |
| `targetWhatsAppNumber`| `String` | إلزامي | الخطوة 6 | رقم الخط المعتمد المحوّل إليه |
| `status` | `String` | إلزامي | الخطوة 6 | حالة الطلب (`"pending"`, `"quoted"`, `"confirmed"`) |
| `createdAt` | `Timestamp` | إلزامي | الخطوة 6 | وقت تقديم الطلب |

### نموذج وثيقة JSON واقعي (Document Sample):
```json
{
  "referenceNumber": "LY-TRIP-2026-5510",
  "userId": "usr_elite_ly_9921",
  "customerName": "عبد الباري معتوق",
  "customerPhone": "+218 91 591 9921",
  "nationality": "ليبي",
  "tripType": "رحلة عائلية فاخرة",
  "businessSector": null,
  "adultsCount": 2,
  "childrenCount": 2,
  "dedicatedBudgetUsd": 4200.0,
  "selectedCountryNames": ["تركيا"],
  "selectedCityNames": ["إسطنبول", "طرابزون"],
  "includesVisaAssistance": true,
  "departureCity": "طرابلس (مطار معيتيقة الدولي)",
  "flightClass": "درجة رجال الأعمال",
  "startDate": "2026-06-10T00:00:00.000Z",
  "totalDays": 9,
  "packageChoiceType": "custom_modular",
  "cityDaysDistribution": {
    "إسطنبول": 5,
    "طرابزون": 4
  },
  "countryTransitPreferences": {
    "turkey": "طيران داخلي (Turkish Airlines)"
  },
  "estimatedCalculatedCostUsd": 3850.0,
  "airportMeetAndGreet": true,
  "accommodationTypes": ["فندق 5 نجوم إطلالة مضيق البوسفور"],
  "starRatings": [5],
  "additionalServices": [
    "سيارة VIP خاصة مع سائق يتحدث العربية طوال الرحلة",
    "شرائح اتصال وإنترنت مفتوح فور الوصول للمطار"
  ],
  "guideLanguage": "عربي",
  "tourType": "جولات سياحية خاصة VIP",
  "selectedInterests": [
    "مناظر طبيعية وأنهار ومرتفعات",
    "تسوق ومراكز تجارية فاخرة",
    "رحلات بحرية في البوسفور"
  ],
  "targetWhatsAppNumber": "218910613700",
  "status": "pending",
  "createdAt": "2026-04-12T11:20:00.000Z",
  "notes": "الرحلة بمناسبة إجازة نهاية العام الدراسي للعائلة"
}
```

---

## 6. هيكل بيانات مجموعة `visa_requests` (طلبات التأشيرات الواردة)

- **مسار المجموعة (Collection Path):** `/visa_requests/{requestId}`
- **وصف المجموعة:** تخزين طلبات استخراج التأشيرات الإلكترونية والسياحية المقدمة من العملاء.

### جدول الحقول (Schema Fields):

| اسم الحقل | نوع البيانات (Firestore) | الإلزامية | الوصف | مثال واقعي |
| :--- | :--- | :--- | :--- | :--- |
| `referenceNumber` | `String` | إلزامي | الرقم المرجعي لطلب التأشيرة | `"LY-VISA-2026-3021"` |
| `visaId` | `String` | إلزامي | معرّف نوع التأشيرة من الكتالوج | `"visa_turkey_e"` |
| `countryName` | `String` | إلزامي | اسم الدولة المراد التأشيرة إليها | `"تركيا"` |
| `visaTitle` | `String` | إلزامي | مسمى التأشيرة المعتمد | `"تأشيرة إلكترونية سياحية (E-Visa)"` |
| `priceUsd` | `Number (double)` | إلزامي | السعر المعتمد بالدولار | `110.0` |
| `processingTime` | `String` | إلزامي | مدة الإنجاز المتوقعة | `"خلال 24-48 ساعة عمل"` |
| `userId` | `String` | إلزامي | معرّف صاحب الطلب | `"usr_elite_ly_9921"` |
| `customerName` | `String` | إلزامي | الاسم الرباعي للعميل كما في الجواز | `"عبد الباري معتوق"` |
| `customerPhone` | `String` | إلزامي | رقم هاتف للتواصل وإرسال التأشيرة | `"+218 91 591 9921"` |
| `status` | `String` | إلزامي | حالة الطلب (`pending`, `under_review`, `approved`, `rejected`) | `"pending"` |
| `targetWhatsAppNumber`| `String` | إلزامي | رقم واتساب قسم التأشيرات المحوّل إليه | `"218910613700"` |
| `createdAt` | `Timestamp` | إلزامي | تاريخ ووقت التقديم | `Timestamp.now()` |
| `updatedAt` | `Timestamp` | اختياري | تاريخ التحديث الإداري | `Timestamp.now()` |
| `adminNotes` | `String` | اختياري | ملاحظات الموظف أو رقم المعاملة بالقنصلية | `"تم التدقيق وجاري الإصدار"` |

### نموذج وثيقة JSON واقعي (Document Sample):
```json
{
  "referenceNumber": "LY-VISA-2026-3021",
  "visaId": "visa_turkey_e",
  "countryName": "تركيا",
  "visaTitle": "تأشيرة إلكترونية سياحية (E-Visa)",
  "priceUsd": 110.0,
  "processingTime": "خلال 24-48 ساعة عمل",
  "userId": "usr_elite_ly_9921",
  "customerName": "عبد الباري معتوق",
  "customerPhone": "+218 91 591 9921",
  "status": "pending",
  "targetWhatsAppNumber": "218910613700",
  "createdAt": "2026-04-14T09:15:00.000Z",
  "updatedAt": null,
  "adminNotes": null
}
```

---

## 7. المجموعات المساندة (Complementary Collections)

لإكمال بنية البيانات، يحتوي النظام على المجموعات المساندة التالية:

### 1. مجموعة كتالوج التأشيرات (`visa_catalog`)
- **المسار:** `/visa_catalog/{visaId}`
- **الحقول:**
  - `countryName`: اسم الدولة (`"تركيا"`، `"ماليزيا"`، `"الإمارات"`، إلخ).
  - `countryCode`: رمز الدولة ISO (`"TR"`، `"MY"`، `"AE"`).
  - `priceUsd`: السعر بالدولار.
  - `processingTime`: مدة الإنجاز.
  - `requiredDocuments`: مصفوفة سلاسل نصية بالمستندات المطلوبة (جواز سفر ساري، صور شخصية خلفية بيضاء، كشف حساب).
  - `notes`: تنبيهات هامة للشروط والقوانين.
  - `isActive`: حالة توفر الخدمة (Boolean).

### 2. مجموعة طلبات حجز الطيران المستقل (`flight_booking_requests`)
- **المسار:** `/flight_booking_requests/{requestId}`
- **الحقول:**
  - `referenceNumber`: مثل `"LY-FLT-2026-7782"`.
  - `tripType`: نمط الرحلة (`"round_trip"`, `"one_way"`, `"multi_city"`).
  - `segments`: مصفوفة بمحطات السفر (مطار الإقلاع، مطار الوصول، التاريخ).
  - `passengers`: أعداد البالغين، الأطفال، الرضع.
  - `flightClass`: درجة المقعد.
  - `baggageAllowance`: وزن الأمتعة المطلوب.
  - `status`: حالة الطلب.

### 3. المجموعة الفرعية لإشعارات المستخدم (`/users/{uid}/notifications`)
- **المسار:** `/users/{uid}/notifications/{notificationId}`
- **الحقول:**
  - `title`: عنوان الإشعار.
  - `body`: نص الإشعار.
  - `type`: نوع الإشعار (`booking_status`، `visa_status`، `custom_trip_quote`).
  - `ref`: الرقم المرجعي المرتبط.
  - `isRead`: هل تمت قراءة الإشعار (Boolean).
  - `createdAt`: توقيت الإرسال.

---

## 8. قواعد الأمان والتحقق من الصلاحيات (Security Rules Mapping)

تضمن ملفات `firestore.rules` حماية فائقة وهرمية دقيقة للصلاحيات (RBAC):

```javascript
// مقتطف حقيقي من firestore.rules
match /bookings/{bookingId} {
  // القراءة: صاحب الحجز فقط أو موظف / مدير معتمد
  allow read: if isOwner(resource.data.userId) || isStaffOrAdmin();
  
  // الإنشاء: العميل المسجل لنفسه فقط وبحالة مبدئية pending
  allow create: if isAuthenticated() 
    && request.resource.data.userId == request.auth.uid
    && request.resource.data.status == 'pending';
    
  // التحديث: العميل قبل التأكيد، أو الموظف لتحديث الحالة
  allow update: if (isOwner(resource.data.userId) && resource.data.status == 'pending')
                || isStaffOrAdmin();
                
  // الحذف النهائي: محصور بالمدير العام فقط
  allow delete: if isAdmin();
}
```

---

## 9. نماذج كود استدعاء المستودعات (Repository Code Usage Templates)

### نموذج 1: إنشاء حجز باقة سياحية من تطبيق العميل (Flutter Client)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/entities/booking_entity.dart';
import 'package:customer_app/core/providers/repository_providers.dart';

Future<void> submitBookingExample(WidgetRef ref) async {
  final bookingRepo = ref.read(bookingRepositoryProvider);

  final newBooking = BookingEntity(
    id: '', // سيتم تعيينه تلقائياً بواسطة Firestore
    referenceNumber: '', // سيتم توليده تلقائياً بصيغة LY-PKG-2026-XXXX
    packageId: 'pkg_istanbul_trabzon_spring',
    packageTitle: 'سحر إسطنبول وطرابزون الفاخر',
    packageDestination: 'تركيا',
    userId: 'current_firebase_auth_uid',
    customerName: 'عبد الباري معتوق',
    customerPhone: '+218 91 591 9921',
    startDate: DateTime(2026, 5, 15),
    returnDate: DateTime(2026, 5, 23),
    durationDays: 8,
    adultsCount: 2,
    childrenCount: 1,
    estimatedTotal: 2700.0,
    notes: 'غرفة مطلة على البحر',
    targetWhatsAppNumber: '218915919921',
    createdAt: DateTime.now(),
  );

  try {
    // 1. الحفظ في Firestore
    final createdBooking = await bookingRepo.createBooking(newBooking);
    
    // 2. استخدام الرقم المرجعي الناتج في رسالة واتساب
    print('تم إنشاء الحجز بنجاح برقم مرجعي: ${createdBooking.referenceNumber}');
  } catch (failure) {
    print('حدث خطأ أثناء الحفظ: $failure');
  }
}
```

### نموذج 2: الاستماع الحي للطلبات وتحديث حالتها في لوحة الإدارة (Admin Dashboard)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/entities/booking_entity.dart';
import 'package:admin_dashboard/core/providers/repository_providers.dart';

// الاستماع المباشر لجميع الحجوزات الواردة
final liveBookingsStreamProvider = StreamProvider<List<BookingEntity>>((ref) {
  final bookingRepo = ref.watch(adminBookingRepositoryProvider);
  return bookingRepo.watchAllBookings();
});

// تحديث حالة الحجز إلى "مؤكد" مع إضافة ملاحظات
Future<void> confirmBookingByAdmin(WidgetRef ref, String bookingId) async {
  final bookingRepo = ref.read(adminBookingRepositoryProvider);

  await bookingRepo.updateBookingStatus(
    bookingId: bookingId,
    newStatus: BookingStatus.confirmed,
    adminNotes: 'تم استلام الدفعة النقدية وتأكيد حجز الطيران والفندق',
  );
}
```

---

## 🎯 الخلاصة الهندسية
هذا التوثيق يمثل المرجع الفني المعياري لمنظومة **مجموعة النخبة للخدمات السياحية**. كافة النماذج والمستودعات في كود المشروع تتبع بدقة هذا التوصيف، مما يضمن ثبات هيكل البيانات وسهولة التوسع المستقبلي وربط الخدمات الإضافية بدون أي تعارض.
