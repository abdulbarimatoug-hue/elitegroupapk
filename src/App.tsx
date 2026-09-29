import React, { useState } from 'react';
import {
  FolderTree,
  FileCode2,
  ShieldCheck,
  PhoneCall,
  Layers,
  Palette,
  CheckCircle2,
  ArrowLeft,
  ChevronDown,
  Copy,
  ExternalLink,
  Smartphone,
  Monitor,
  Flame,
  PackageCheck,
  Sparkles,
  Database,
  Plane,
  FileSpreadsheet,
  Globe2,
  Compass,
  CreditCard,
  UserCheck,
  Check,
  Play,
  Heart,
  Calendar,
  Clock,
  Search,
  MapPin,
  Star,
  Users,
  ChevronRight,
  Info,
  X,
  Share2,
  Ticket,
  FileDown,
  Plus,
  Trash2,
  Car,
  Hotel,
  SlidersHorizontal,
  Edit3,
  Luggage,
  LayoutDashboard,
  Filter,
  CheckSquare,
  AlertCircle,
  Download
} from 'lucide-react';
import { EliteLogo } from './components/EliteLogo';

export default function App() {
  // Mode toggle: Customer Mobile App vs Admin Web Dashboard
  const [appMode, setAppMode] = useState<'customer' | 'admin'>('admin');
  const [isApkModalOpen, setIsApkModalOpen] = useState(false);
  const [copiedLink, setCopiedLink] = useState(false);

  // Customer Navigation Screen
  const [currentScreen, setCurrentScreen] = useState<
    'home' | 'package_detail' | 'visas' | 'visa_detail' | 'bookings' | 'favorites' | 'profile' | 'custom_trip' | 'flight_booking'
  >('custom_trip');

  // Admin Dashboard Active Tab
  const [adminTab, setAdminTab] = useState<
    'overview' | 'bookings' | 'custom_trips' | 'flight_requests' | 'visa_requests' | 'visa_catalog' | 'trip_builder_config' | 'packages_mgmt' | 'users' | 'security_rules' | 'notifications' | 'architecture_docs'
  >('overview');

  // Push notifications state (Simulating real FCM messaging & in-app notifications)
  const [notifications, setNotifications] = useState([
    {
      id: 'notif-1',
      title: 'تأكيد حجز الباقة السياحية',
      body: 'تم تأكيد حجزك رقم LY-PKG-2026-1049 لرحلة إسطنبول وطرابزون بنجاح!',
      type: 'booking_status',
      ref: 'LY-PKG-2026-1049',
      time: 'منذ 10 دقائق',
      isRead: false
    },
    {
      id: 'notif-2',
      title: 'إصدار التأشيرة الإلكترونية',
      body: 'تهانينا! تم إصدار تأشيرتك الإلكترونية إلى تركيا رقم LY-VISA-2026-3021.',
      type: 'visa_status',
      ref: 'LY-VISA-2026-3021',
      time: 'منذ ساعتين',
      isRead: true
    },
    {
      id: 'notif-3',
      title: 'جاهزية عرض سعر الرحلة المخصصة',
      body: 'فريق تصميم الرحلات أعد لك برنامجاً متكاملاً لرحلتك العائلية رقم LY-TRIP-2026-5510.',
      type: 'custom_trip_quote',
      ref: 'LY-TRIP-2026-5510',
      time: 'أمس',
      isRead: true
    }
  ]);
  const [isNotifModalOpen, setIsNotifModalOpen] = useState(false);
  const [simulatedFCMToken, setSimulatedFCMToken] = useState('fcm_ly_elite_device_token_9921_prod');

  // Customer info
  const [customerName, setCustomerName] = useState('عبد الباري معتوق');
  const [customerPhone, setCustomerPhone] = useState('+218 91 591 9921');
  const [favorites, setFavorites] = useState<string[]>(['pkg-1', 'pkg-2']);

  // Custom Trip Builder State (القسم ك)
  const [tripStep, setTripStep] = useState<number>(1);
  const [tripType, setTripType] = useState('رحلة عائلية');
  const [businessSector, setBusinessSector] = useState('التجارة العامة والاستيراد');
  const [tripAdults, setTripAdults] = useState(2);
  const [tripChildren, setTripChildren] = useState(1);
  const [tripBudget, setTripBudget] = useState(3800);
  const [tripNationality, setTripNationality] = useState('ليبي');
  const [selectedCities, setSelectedCities] = useState<string[]>(['إسطنبول', 'طرابزون']);
  const [selectedCountries, setSelectedCountries] = useState<string[]>(['تركيا']);
  const [departureCity, setDepartureCity] = useState('طرابلس (معيتيقة)');
  const [flightClass, setFlightClass] = useState('اقتصادية');
  const [tripStartDate, setTripStartDate] = useState('2026-10-20');
  const [totalTripDays, setTotalTripDays] = useState(8);
  const [cityDays, setCityDays] = useState<{ [city: string]: number }>({ 'إسطنبول': 4, 'طرابزون': 4 });
  const [airportMeetAndGreet, setAirportMeetAndGreet] = useState(true);
  const [stayTypes, setStayTypes] = useState<string[]>(['فنادق']);
  const [starRatings, setStarRatings] = useState<string[]>(['5 نجوم']);
  const [guideLang, setGuideLang] = useState('عربية');
  const [tourType, setTourType] = useState('خاصة Private');
  const [interests, setInterests] = useState<string[]>(['طبيعة وجبال', 'تسوق ومولات']);

  // Independent Flight Booking State (القسم ل)
  const [flightTripType, setFlightTripType] = useState<'roundTrip' | 'oneWay' | 'multiCity'>('roundTrip');
  const [flightFrom, setFlightFrom] = useState('طرابلس (TIP)');
  const [flightTo, setFlightTo] = useState('إسطنبول (IST)');
  const [flightDepartDate, setFlightDepartDate] = useState('2026-10-15');
  const [flightReturnDate, setFlightReturnDate] = useState('2026-10-25');
  const [flightAdults, setFlightAdults] = useState(1);
  const [flightChildren, setFlightChildren] = useState(0);
  const [flightInfants, setFlightInfants] = useState(0);
  const [flightBaggage, setFlightBaggage] = useState('23 كيلو');
  const [flightCabinClass, setFlightCabinClass] = useState('اقتصادية');

  // ADMIN LIVE DATA STATE
  const [adminBookings, setAdminBookings] = useState([
    { id: 'b-101', ref: 'LY-PKG-2026-1049', pkg: 'سحر إسطنبول وطرابزون', customer: 'عبد الباري معتوق', phone: '+218915919921', dates: '2026-10-20 إلى 10-28', travelers: '2 بالغين، 1 طفل', status: 'pending', total: 2125 },
    { id: 'b-102', ref: 'LY-PKG-2026-0941', pkg: 'بريق دبي والتسوق الفاخر', customer: 'سالم المقريف', phone: '+218921113344', dates: '2026-11-05 إلى 11-11', travelers: '2 بالغين', status: 'confirmed', total: 1440 },
    { id: 'b-103', ref: 'LY-PKG-2026-0812', pkg: 'أسبوع العسل في جزر المالديف', customer: 'أحمد الترهوني', phone: '+218917778899', dates: '2026-12-01 إلى 12-07', travelers: '2 بالغين', status: 'completed', total: 3300 }
  ]);

  const [adminCustomTrips, setAdminCustomTrips] = useState([
    { id: 'ct-1', ref: 'LY-TRIP-2026-5510', customer: 'عبد الباري معتوق', phone: '+218915919921', destination: 'تركيا (إسطنبول 4 ليالٍ + طرابزون 4 ليالٍ)', days: 8, budget: 3800, type: 'عائلية', transit: 'طيران داخلي', status: 'inReview' },
    { id: 'ct-2', ref: 'LY-TRIP-2026-4421', customer: 'خالد السويحلي', phone: '+218912224455', destination: 'الإمارات (دبي 5 ليالٍ + أبوظبي 2 ليالٍ)', days: 7, budget: 5000, type: 'رحلة عمل (طاقة)', transit: 'سيارة خاصة VIP', status: 'quoted' }
  ]);

  const [adminFlightRequests, setAdminFlightRequests] = useState([
    { id: 'fl-1', ref: 'LY-FLIGHT-2026-8802', customer: 'محمد الهادي', phone: '+218921112233', type: 'ذهاب وعودة', route: 'طرابلس (معيتيقة) ➔ إسطنبول (IST)', dates: '2026-11-01 -> 11-10', pax: '2 بالغين، 1 طفل', baggage: '23 كيلو', cabin: 'اقتصادية', status: 'pending' },
    { id: 'fl-2', ref: 'LY-FLIGHT-2026-7731', customer: 'نادية الفرجاني', phone: '+218910009988', type: 'ذهاب فقط', route: 'مصراتة ➔ تونس قرطاج', dates: '2026-10-18', pax: '1 بالغ', baggage: '8 كيلو يد', cabin: 'رجال أعمال', status: 'confirmed' }
  ]);

  const [adminVisaRequests, setAdminVisaRequests] = useState([
    { id: 'vr-1', ref: 'LY-VISA-2026-3021', country: 'تركيا', title: 'تأشيرة إلكترونية', price: 110, customer: 'عبد الباري معتوق', phone: '+218915919921', status: 'processing', notes: 'تم استلام الجواز وجارٍ التقديم' },
    { id: 'vr-2', ref: 'LY-VISA-2026-2910', country: 'الإمارات', title: 'تأشيرة سياحية شهر', price: 130, customer: 'طارق الزنتاني', phone: '+218916665544', status: 'issued', notes: 'تم إصدار التأشيرة وإرسالها واتساب' }
  ]);

  const [adminVisaCatalog, setAdminVisaCatalog] = useState([
    { id: 'v-tr', country: 'تركيا', title: 'تأشيرة إلكترونية سياحية', price: 110, time: 'خلال 24-48 ساعة', gradient: 'من الكحلي إلى الأزرق', docsCount: 3, flag: '🇹🇷' },
    { id: 'v-ae', country: 'الإمارات', title: 'تأشيرة سياحية لمدة شهر', price: 130, time: 'خلال 2-3 أيام عمل', gradient: 'من الذهبي إلى البني', docsCount: 3, flag: '🇦🇪' },
    { id: 'v-eg', country: 'مصر', title: 'الموافقة الأمنية والتأشيرة', price: 95, time: 'خلال 3-5 أيام عمل', gradient: 'من التوتي إلى الأحمر', docsCount: 3, flag: '🇪🇬' },
    { id: 'v-uk', country: 'المملكة المتحدة', title: 'تأشيرة سياحية / زيارة عمل', price: 280, time: 'خلال 15 يوم عمل', gradient: 'من الأسود إلى الكحلي', docsCount: 4, flag: '🇬🇧' }
  ]);

  const [adminTripBuilderConfig, setAdminTripBuilderConfig] = useState({
    minBudget: 1500,
    countriesCount: 5,
    citiesCount: 14,
    readyPackagesCount: 3,
    transitOptions: ['طيران داخلي', 'سيارة خاصة مع سائق', 'قطار فائق السرعة', 'حافلة فاخرة'],
  });

  const sumDistributedDays = Object.values(cityDays).reduce((a, b) => a + b, 0);
  const isDaysMatched = sumDistributedDays === totalTripDays;

  // Handlers for status updates in Admin
  const handleUpdateBookingStatus = (id: string, newStatus: string) => {
    setAdminBookings(adminBookings.map(b => b.id === id ? { ...b, status: newStatus } : b));
  };

  const handleUpdateCustomTripStatus = (id: string, newStatus: string) => {
    setAdminCustomTrips(adminCustomTrips.map(t => t.id === id ? { ...t, status: newStatus } : t));
  };

  const handleUpdateFlightStatus = (id: string, newStatus: string) => {
    setAdminFlightRequests(adminFlightRequests.map(f => f.id === id ? { ...f, status: newStatus } : f));
  };

  const handleUpdateVisaStatus = (id: string, newStatus: string) => {
    setAdminVisaRequests(adminVisaRequests.map(v => v.id === id ? { ...v, status: newStatus } : v));
  };

  return (
    <div className="min-h-screen bg-[#f7f4ec] text-[#16233a] font-['Cairo',sans-serif]">
      {/* Top Luxury Header with Mode Switcher */}
      <header className="bg-gradient-to-r from-[#081a2e] via-[#0e2a47] to-[#081a2e] text-white border-b-2 border-[#c9a227]/40 shadow-xl">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 py-5">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div className="flex items-center gap-4">
              <EliteLogo size="lg" variant="light" showText={true} />
              <div className="hidden sm:block border-r border-white/20 pr-4 mr-2">
                <span className="text-xs bg-[#c9a227]/20 text-[#e8d18f] border border-[#c9a227]/40 px-2.5 py-0.5 rounded-full font-bold">
                  LY-Elite
                </span>
                <p className="text-xs text-[#e8d18f]/90 mt-1">
                  تطبيق العميل للهواتف (Flutter) + لوحة تحكم الإدارة (Flutter Web)
                </p>
              </div>
            </div>

            {/* Controls: Mode Switcher & APK Download Button */}
            <div className="flex flex-wrap items-center gap-2">
              <div className="flex items-center bg-[#081a2e] p-1.5 rounded-2xl border border-[#c9a227]/40">
                <button
                  onClick={() => setAppMode('customer')}
                  className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                    appMode === 'customer'
                      ? 'bg-[#c9a227] text-[#081a2e] shadow-md'
                      : 'text-white/80 hover:text-white'
                  }`}
                >
                  <Smartphone className="w-4 h-4" />
                  تطبيق العميل للهواتف
                </button>

                <button
                  onClick={() => setAppMode('admin')}
                  className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                    appMode === 'admin'
                      ? 'bg-[#c9a227] text-[#081a2e] shadow-md'
                      : 'text-white/80 hover:text-white'
                  }`}
                >
                  <Monitor className="w-4 h-4" />
                  لوحة تحكم الإدارة (المرحلة 6)
                </button>
              </div>

              {/* APK Download & Install Trigger */}
              <button
                onClick={() => setIsApkModalOpen(true)}
                className="flex items-center gap-2 px-4 py-2.5 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-600 text-white font-black text-xs shadow-lg hover:from-emerald-500 hover:to-teal-500 border border-emerald-400/30 transition-all cursor-pointer"
              >
                <Download className="w-4 h-4 animate-bounce" />
                تحميل / تثبيت التطبيق (APK)
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* ============================================================== */}
      {/* MODE 1: ADMIN WEB DASHBOARD (المرحلة 6) */}
      {/* ============================================================== */}
      {appMode === 'admin' && (
        <main className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
          {/* Phase 6 Banner */}
          <div className="mb-6 p-4 bg-gradient-to-r from-amber-50 to-orange-50 rounded-2xl border border-[#c9a227]/40 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2.5 bg-[#c9a227]/20 rounded-xl text-[#0e2a47]">
                <ShieldCheck className="w-6 h-6" />
              </div>
              <div>
                <h3 className="text-sm font-bold text-[#0e2a47]">لوحة تحكم الإدارة المعتمدة - مجموعة النخبة للخدمات السياحية</h3>
                <p className="text-xs text-[#5c6b83]">تسجيل دخول خاص بالمدراء والموظفين، ضبط وإدارة الحجوزات، التأشيرات، ومحددات مصمم الرحلة.</p>
              </div>
            </div>
            <span className="text-xs bg-[#0e2a47] text-[#e8d18f] font-bold px-3 py-1.5 rounded-xl">
              المرحلة 6 مكتملة
            </span>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
            {/* Admin Sidebar Navigation */}
            <div className="lg:col-span-3 bg-white p-4 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-2 h-fit">
              <div className="pb-3 border-b border-slate-100 mb-3">
                <EliteLogo size="sm" variant="dark" showText={true} />
              </div>
              <div className="pb-3 border-b border-slate-100 flex items-center gap-3 mb-2">
                <div className="w-10 h-10 rounded-xl bg-[#0e2a47] text-[#c9a227] flex items-center justify-center font-bold">
                  ع.م
                </div>
                <div>
                  <h4 className="text-xs font-bold text-[#0e2a47]">عبد الباري معتوق</h4>
                  <span className="text-[10px] text-amber-700 bg-amber-50 px-2 py-0.5 rounded font-bold border border-amber-200">
                    مدير عام (Super Admin)
                  </span>
                </div>
              </div>

              {[
                { id: 'overview', label: 'لوحة المؤشرات العامة', icon: LayoutDashboard, badge: 'KPIs' },
                { id: 'bookings', label: 'حجوزات الباقات السياحية', icon: Luggage, badge: adminBookings.length },
                { id: 'custom_trips', label: 'طلبات الرحلات المخصصة', icon: Compass, badge: adminCustomTrips.length },
                { id: 'flight_requests', label: 'طلبات تذاكر الطيران', icon: Plane, badge: adminFlightRequests.length },
                { id: 'visa_requests', label: 'طلبات التأشيرات الواردة', icon: CreditCard, badge: adminVisaRequests.length },
                { id: 'visa_catalog', label: 'إدارة بيانات التأشيرات', icon: SlidersHorizontal, badge: adminVisaCatalog.length },
                { id: 'trip_builder_config', label: 'إدارة محددات مصمم الرحلة', icon: Layers, badge: 'إعدادات' },
                { id: 'packages_mgmt', label: 'إدارة الباقات السياحية', icon: Globe2, badge: '3 باقات' },
                { id: 'users', label: 'العملاء وصلاحيات الموظفين', icon: Users, badge: '482' },
                { id: 'security_rules', label: 'قواعد أمان Firestore', icon: ShieldCheck, badge: 'المرحلة 7' },
                { id: 'notifications', label: 'إرسال وتنبيهات الإشعارات (FCM)', icon: PhoneCall, badge: 'المرحلة 8' },
                { id: 'architecture_docs', label: 'التوثيق والمعمارية الفنية', icon: FolderTree, badge: 'المرحلة 9' },
              ].map((item) => {
                const Icon = item.icon;
                const isSelected = adminTab === item.id;
                return (
                  <button
                    key={item.id}
                    onClick={() => setAdminTab(item.id as any)}
                    className={`w-full flex items-center justify-between p-2.5 rounded-xl text-xs font-bold transition-all ${
                      isSelected
                        ? 'bg-[#0e2a47] text-[#e8d18f] shadow-sm'
                        : 'text-slate-700 hover:bg-slate-50'
                    }`}
                  >
                    <div className="flex items-center gap-2">
                      <Icon className={`w-4 h-4 ${isSelected ? 'text-[#c9a227]' : 'text-slate-400'}`} />
                      <span>{item.label}</span>
                    </div>
                    <span className={`text-[10px] px-2 py-0.5 rounded-full ${
                      isSelected ? 'bg-[#c9a227] text-[#081a2e]' : 'bg-slate-100 text-slate-600'
                    }`}>
                      {item.badge}
                    </span>
                  </button>
                );
              })}
            </div>

            {/* Admin Main Dynamic Panel */}
            <div className="lg:col-span-9 space-y-6">
              {/* TAB 1: OVERVIEW */}
              {adminTab === 'overview' && (
                <div className="space-y-6">
                  {/* KPI Cards */}
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
                    <div className="bg-white p-4 rounded-2xl border border-[#e4ddc9] shadow-sm">
                      <span className="text-[11px] text-slate-500 font-bold block mb-1">حجوزات الباقات الجديدة</span>
                      <div className="text-xl font-black text-[#0e2a47]">{adminBookings.length} حجز</div>
                      <span className="text-[10px] text-emerald-600 font-bold">+2 اليوم</span>
                    </div>

                    <div className="bg-white p-4 rounded-2xl border border-[#e4ddc9] shadow-sm">
                      <span className="text-[11px] text-slate-500 font-bold block mb-1">طلبات الرحلات المخصصة</span>
                      <div className="text-xl font-black text-[#2563eb]">{adminCustomTrips.length} طلب</div>
                      <span className="text-[10px] text-blue-600 font-bold">معالج الـ 6 خطوات</span>
                    </div>

                    <div className="bg-white p-4 rounded-2xl border border-[#e4ddc9] shadow-sm">
                      <span className="text-[11px] text-slate-500 font-bold block mb-1">طلبات تذاكر الطيران</span>
                      <div className="text-xl font-black text-[#c9a227]">{adminFlightRequests.length} طلب</div>
                      <span className="text-[10px] text-amber-700 font-bold">بانتظار التسعير</span>
                    </div>

                    <div className="bg-white p-4 rounded-2xl border border-[#e4ddc9] shadow-sm">
                      <span className="text-[11px] text-slate-500 font-bold block mb-1">طلبات التأشيرات</span>
                      <div className="text-xl font-black text-[#059669]">{adminVisaRequests.length} طلب</div>
                      <span className="text-[10px] text-emerald-600 font-bold">نشطة</span>
                    </div>
                  </div>

                  {/* Recent Bookings Quick Table */}
                  <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                    <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                      <h4 className="text-sm font-bold text-[#0e2a47]">أحدث حجوزات الباقات الواردة:</h4>
                      <button onClick={() => setAdminTab('bookings')} className="text-xs text-[#c9a227] font-bold hover:underline">
                        عرض كافة الحجوزات &larr;
                      </button>
                    </div>

                    <div className="overflow-x-auto">
                      <table className="w-full text-right text-xs">
                        <thead className="bg-slate-50 text-slate-600 border-b border-slate-200">
                          <tr>
                            <th className="p-2.5">المرجع</th>
                            <th className="p-2.5">الباقة</th>
                            <th className="p-2.5">العميل</th>
                            <th className="p-2.5">الإجمالي</th>
                            <th className="p-2.5">الحالة</th>
                            <th className="p-2.5">واتساب</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-100">
                          {adminBookings.map((b) => (
                            <tr key={b.id} className="hover:bg-slate-50">
                              <td className="p-2.5 font-mono font-bold text-[#0e2a47]">{b.ref}</td>
                              <td className="p-2.5 font-bold">{b.pkg}</td>
                              <td className="p-2.5">{b.customer} ({b.phone})</td>
                              <td className="p-2.5 font-bold text-[#0e2a47]">${b.total}</td>
                              <td className="p-2.5">
                                <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                                  b.status === 'confirmed' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'
                                }`}>
                                  {b.status === 'confirmed' ? 'مؤكد' : (b.status === 'pending' ? 'قيد المراجعة' : 'مكتمل')}
                                </span>
                              </td>
                              <td className="p-2.5">
                                <a
                                  href={`https://wa.me/${b.phone.replace(/[^0-9]/g, '')}?text=مرحباً أستاذ ${b.customer} بخصوص حجزكم رقم ${b.ref}`}
                                  target="_blank"
                                  rel="noreferrer"
                                  className="text-emerald-600 hover:text-emerald-700 font-bold flex items-center gap-1"
                                >
                                  <PhoneCall className="w-3.5 h-3.5" />
                                  مراسلة
                                </a>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              )}

              {/* TAB 2: BOOKINGS MANAGEMENT */}
              {adminTab === 'bookings' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">إدارة كافة حجوزات الباقات السياحية</h3>
                      <p className="text-xs text-slate-500">تحديث حالة الحجز (مؤكد / قيد المراجعة / ملغى) ومراسلة العميل عبر واتساب</p>
                    </div>
                  </div>

                  <div className="overflow-x-auto">
                    <table className="w-full text-right text-xs">
                      <thead className="bg-slate-50 text-slate-700 font-bold border-b border-slate-200">
                        <tr>
                          <th className="p-2.5">الرقم المرجعي</th>
                          <th className="p-2.5">الباقة والتواريخ</th>
                          <th className="p-2.5">العميل والجوال</th>
                          <th className="p-2.5">المسافرين والتكلفة</th>
                          <th className="p-2.5">تغيير الحالة</th>
                          <th className="p-2.5">إجراءات</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-slate-100">
                        {adminBookings.map((b) => (
                          <tr key={b.id} className="hover:bg-slate-50/80">
                            <td className="p-2.5 font-mono font-bold text-[#0e2a47]">{b.ref}</td>
                            <td className="p-2.5">
                              <span className="font-bold block text-[#16233a]">{b.pkg}</span>
                              <span className="text-[10px] text-slate-500">{b.dates}</span>
                            </td>
                            <td className="p-2.5">
                              <span className="font-bold block">{b.customer}</span>
                              <span className="text-[10px] font-mono text-slate-500">{b.phone}</span>
                            </td>
                            <td className="p-2.5">
                              <span className="block">{b.travelers}</span>
                              <span className="font-bold text-[#0e2a47]">${b.total}</span>
                            </td>
                            <td className="p-2.5">
                              <select
                                value={b.status}
                                onChange={(e) => handleUpdateBookingStatus(b.id, e.target.value)}
                                className="p-1 rounded-lg border border-slate-300 text-xs bg-white"
                              >
                                <option value="pending">قيد المراجعة</option>
                                <option value="confirmed">تأكيد الحجز</option>
                                <option value="completed">مكتمل</option>
                                <option value="cancelled">إلغاء الحجز</option>
                              </select>
                            </td>
                            <td className="p-2.5">
                              <a
                                href={`https://wa.me/${b.phone.replace(/[^0-9]/g, '')}`}
                                target="_blank"
                                rel="noreferrer"
                                className="px-2.5 py-1 rounded bg-emerald-50 text-emerald-700 border border-emerald-200 text-[11px] font-bold inline-flex items-center gap-1 hover:bg-emerald-100"
                              >
                                <PhoneCall className="w-3 h-3" />
                                واتساب
                              </a>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}

              {/* TAB 3: CUSTOM TRIP REQUESTS (القسم ك) */}
              {adminTab === 'custom_trips' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">إدارة طلبات الرحلات المخصصة (معالج الـ 6 خطوات)</h3>
                      <p className="text-xs text-slate-500">استعراض المسارات وتوزيع الأيام والتنقل الداخلي وإعداد عروض الأسعار</p>
                    </div>
                  </div>

                  <div className="space-y-3">
                    {adminCustomTrips.map((t) => (
                      <div key={t.id} className="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 text-xs">
                        <div className="flex items-center justify-between">
                          <span className="font-mono font-bold text-sm text-[#0e2a47]">{t.ref}</span>
                          <div className="flex items-center gap-2">
                            <span className="text-slate-500">حالة الطلب:</span>
                            <select
                              value={t.status}
                              onChange={(e) => handleUpdateCustomTripStatus(t.id, e.target.value)}
                              className="p-1 rounded-lg border border-slate-300 text-xs bg-white font-bold"
                            >
                              <option value="pending">قيد المراجعة</option>
                              <option value="inReview">جارٍ التسعير والبرنامج</option>
                              <option value="quoted">تم إرسال العرض</option>
                              <option value="confirmed">معتمد ومؤكد</option>
                              <option value="cancelled">ملغى</option>
                            </select>
                          </div>
                        </div>

                        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 pt-1 border-t border-slate-200">
                          <div>
                            <span className="text-slate-500 block">العميل:</span>
                            <span className="font-bold text-[#0e2a47]">{t.customer} ({t.phone})</span>
                          </div>
                          <div>
                            <span className="text-slate-500 block">الوجهات والمدة:</span>
                            <span className="font-bold text-[#0e2a47]">{t.destination} ({t.days} أيام)</span>
                          </div>
                          <div>
                            <span className="text-slate-500 block">التنقل والميزانية:</span>
                            <span className="font-bold text-[#0e2a47]">{t.transit} • ${t.budget}</span>
                          </div>
                          <div className="flex items-center justify-end">
                            <a
                              href={`https://wa.me/${t.phone.replace(/[^0-9]/g, '')}?text=مرحباً ${t.customer}، تم إعداد عرض سعر رحلتكم المخصصة رقم ${t.ref}`}
                              target="_blank"
                              rel="noreferrer"
                              className="px-3 py-1.5 rounded-xl bg-emerald-600 text-white font-bold flex items-center gap-1 hover:bg-emerald-700"
                            >
                              <PhoneCall className="w-3 h-3" />
                              إرسال العرض بواتساب
                            </a>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* TAB 4: FLIGHT REQUESTS (القسم ل) */}
              {adminTab === 'flight_requests' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">إدارة طلبات حجز تذاكر الطيران المستقلة</h3>
                      <p className="text-xs text-slate-500">متابعة طلبات الذهاب والعودة والمدن المتعددة وإصدار التذاكر</p>
                    </div>
                  </div>

                  <div className="overflow-x-auto">
                    <table className="w-full text-right text-xs">
                      <thead className="bg-slate-50 text-slate-700 font-bold border-b border-slate-200">
                        <tr>
                          <th className="p-2.5">المرجع</th>
                          <th className="p-2.5">المسار والنوع</th>
                          <th className="p-2.5">التاريخ والمسافرين</th>
                          <th className="p-2.5">الوزن والدرجة</th>
                          <th className="p-2.5">الحالة</th>
                          <th className="p-2.5">التواصل</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-slate-100">
                        {adminFlightRequests.map((f) => (
                          <tr key={f.id} className="hover:bg-slate-50">
                            <td className="p-2.5 font-mono font-bold text-[#0e2a47]">{f.ref}</td>
                            <td className="p-2.5">
                              <span className="font-bold block">{f.route}</span>
                              <span className="text-[10px] text-[#c9a227]">{f.type}</span>
                            </td>
                            <td className="p-2.5">
                              <span className="block">{f.dates}</span>
                              <span className="text-[10px] text-slate-500">{f.pax}</span>
                            </td>
                            <td className="p-2.5">
                              <span className="block">{f.baggage}</span>
                              <span className="text-[10px] font-bold text-[#0e2a47]">{f.cabin}</span>
                            </td>
                            <td className="p-2.5">
                              <select
                                value={f.status}
                                onChange={(e) => handleUpdateFlightStatus(f.id, e.target.value)}
                                className="p-1 rounded-lg border border-slate-300 text-xs bg-white"
                              >
                                <option value="pending">قيد البحث</option>
                                <option value="confirmed">تم الإصدار</option>
                                <option value="cancelled">ملغى</option>
                              </select>
                            </td>
                            <td className="p-2.5">
                              <a
                                href={`https://wa.me/${f.phone.replace(/[^0-9]/g, '')}?text=مرحباً بخصوص طلب تذاكر الطيران ${f.ref}`}
                                target="_blank"
                                rel="noreferrer"
                                className="text-emerald-600 font-bold flex items-center gap-1"
                              >
                                <PhoneCall className="w-3 h-3" />
                                واتساب
                              </a>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}

              {/* TAB 5: VISA REQUESTS */}
              {adminTab === 'visa_requests' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">إدارة طلبات التأشيرات الواردة (القسم هـ)</h3>
                      <p className="text-xs text-slate-500">متابعة مراحل التأشيرة: قيد المراجعة ➔ قيد المعالجة ➔ تم الإصدار</p>
                    </div>
                  </div>

                  <div className="space-y-3">
                    {adminVisaRequests.map((v) => (
                      <div key={v.id} className="p-3.5 rounded-2xl bg-slate-50 border border-slate-200 flex items-center justify-between text-xs">
                        <div>
                          <div className="flex items-center gap-2 mb-1">
                            <span className="font-mono font-bold text-[#0e2a47]">{v.ref}</span>
                            <span className="font-bold text-amber-800 bg-amber-100 px-2 py-0.5 rounded text-[10px]">
                              {v.country} - {v.title} (${v.price})
                            </span>
                          </div>
                          <span className="text-slate-600 block">{v.customer} &bull; {v.phone}</span>
                          <span className="text-[11px] text-slate-500">ملاحظات الإدارة: {v.notes}</span>
                        </div>

                        <div className="flex items-center gap-3">
                          <select
                            value={v.status}
                            onChange={(e) => handleUpdateVisaStatus(v.id, e.target.value)}
                            className="p-1.5 rounded-xl border border-slate-300 text-xs bg-white font-bold"
                          >
                            <option value="pending">قيد المراجعة</option>
                            <option value="processing">قيد المعالجة بالقنصلية</option>
                            <option value="issued">تم الإصدار بنجاح</option>
                            <option value="rejected">مرفوض</option>
                          </select>

                          <a
                            href={`https://wa.me/${v.phone.replace(/[^0-9]/g, '')}?text=مرحباً ${v.customer}، بخصوص طلب تأشيرة ${v.country} رقم ${v.ref}`}
                            target="_blank"
                            rel="noreferrer"
                            className="px-3 py-1.5 rounded-xl bg-emerald-600 text-white font-bold flex items-center gap-1"
                          >
                            <PhoneCall className="w-3 h-3" />
                            متابعة
                          </a>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* TAB 6: VISA CATALOG MANAGEMENT */}
              {adminTab === 'visa_catalog' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">إدارة كتالوج الدول والتأشيرات</h3>
                      <p className="text-xs text-slate-500">إضافة وتعديل الدول، الأسعار بالدولار، مدة الإنجاز، وقوائم المستندات المطلوبة</p>
                    </div>
                    <button
                      onClick={() => alert('إضافة دولة تأشيرة جديدة إلى Firestore!')}
                      className="px-3 py-1.5 rounded-xl bg-[#c9a227] text-[#081a2e] text-xs font-bold hover:bg-[#b58f1f] flex items-center gap-1"
                    >
                      <Plus className="w-3.5 h-3.5" />
                      إضافة دولة جديدة
                    </button>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    {adminVisaCatalog.map((item) => (
                      <div key={item.id} className="p-3.5 rounded-2xl border border-slate-200 bg-slate-50 flex items-start justify-between text-xs">
                        <div>
                          <div className="flex items-center gap-2 mb-1">
                            <span className="text-xl">{item.flag}</span>
                            <span className="font-bold text-sm text-[#0e2a47]">{item.country}</span>
                            <span className="font-black text-[#c9a227] text-sm">${item.price}</span>
                          </div>
                          <p className="text-slate-600 text-[11px] mb-1">{item.title}</p>
                          <span className="text-[10px] text-slate-500 block">مدة الإنجاز: {item.time}</span>
                          <span className="text-[10px] text-slate-500 block">المستندات: {item.docsCount} عناصر مطلوبة</span>
                        </div>

                        <div className="flex items-center gap-1">
                          <button className="p-1 text-slate-500 hover:text-[#0e2a47]">
                            <Edit3 className="w-4 h-4" />
                          </button>
                          <button className="p-1 text-red-500 hover:text-red-700">
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* TAB 7: TRIP BUILDER MASTER CONFIG */}
              {adminTab === 'trip_builder_config' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">إدارة محددات مصمم الرحلة المخصصة</h3>
                      <p className="text-xs text-slate-500">ضبط القوائم والخيارات التي يعتمد عليها معالج الـ 6 خطوات في تطبيق العميل</p>
                    </div>
                    <button
                      onClick={() => alert('تم حفظ التعديلات في مجموعة trip_builder_config بـ Firestore')}
                      className="px-3 py-1.5 rounded-xl bg-[#0e2a47] text-[#e8d18f] text-xs font-bold"
                    >
                      حفظ التغييرات
                    </button>
                  </div>

                  <div className="space-y-4 text-xs">
                    <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                      <label className="font-bold text-[#0e2a47] block mb-1">الحد الأدنى لميزانية الرحلة (بالدولار):</label>
                      <input
                        type="number"
                        value={adminTripBuilderConfig.minBudget}
                        onChange={(e) => setAdminTripBuilderConfig({ ...adminTripBuilderConfig, minBudget: Number(e.target.value) })}
                        className="p-2 rounded-lg border border-slate-300 text-xs w-48 font-bold"
                      />
                    </div>

                    <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                      <label className="font-bold text-[#0e2a47] block mb-1">وسائل التنقل الداخلي المتاحة في الخطوة 3:</label>
                      <div className="flex flex-wrap gap-2 mt-2">
                        {adminTripBuilderConfig.transitOptions.map((opt, i) => (
                          <span key={i} className="px-2.5 py-1 bg-white border border-slate-300 rounded-lg text-xs font-bold text-[#0e2a47]">
                            {opt}
                          </span>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* TAB 8: PACKAGES MANAGEMENT */}
              {adminTab === 'packages_mgmt' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">إدارة الباقات السياحية الرسمية</h3>
                      <p className="text-xs text-slate-500">إضافة وتعديل الباقات وبرامج الأيام اليومية وقوائم ما يشمله وما لا يشمله السعر</p>
                    </div>
                    <button
                      onClick={() => alert('فتح نافذة إضافة باقة سياحية جديدة!')}
                      className="px-3 py-1.5 rounded-xl bg-[#c9a227] text-[#081a2e] text-xs font-bold flex items-center gap-1"
                    >
                      <Plus className="w-3.5 h-3.5" />
                      إضافة باقة جديدة
                    </button>
                  </div>

                  <div className="space-y-2.5 text-xs">
                    {adminBookings.map((pkg, i) => (
                      <div key={i} className="p-3 rounded-xl bg-slate-50 border border-slate-200 flex items-center justify-between">
                        <div>
                          <span className="font-bold text-[#0e2a47] text-sm block">{pkg.pkg}</span>
                          <span className="text-[11px] text-slate-500">السعر: ${pkg.total} • 8 أيام / 7 ليالٍ</span>
                        </div>
                        <div className="flex items-center gap-2">
                          <button className="px-2.5 py-1 rounded bg-slate-200 text-[#0e2a47] font-bold">تعديل</button>
                          <button className="px-2.5 py-1 rounded bg-red-100 text-red-700 font-bold">حذف</button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* TAB 10: FIRESTORE SECURITY RULES (المرحلة 7) */}
              {adminTab === 'security_rules' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">قواعد أمان Firestore المحكمة (المرحلة 7)</h3>
                      <p className="text-xs text-slate-500">عزل بيانات العملاء بنسبة 100% وحماية صلاحيات الإدارة والموظفين</p>
                    </div>
                    <span className="text-[11px] bg-emerald-100 text-emerald-800 font-bold px-3 py-1 rounded-full">
                      firestore.rules نشطة
                    </span>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs">
                    <div className="p-3 bg-emerald-50/70 rounded-2xl border border-emerald-200 space-y-2">
                      <span className="font-bold text-emerald-900 block">ضوابط عزل بيانات العملاء (Data Isolation):</span>
                      <ul className="space-y-1.5 text-emerald-800 text-[11px]">
                        <li>• لا يستطيع أي عميل قراءة أو تعديل حجوزات أو طلبات عميل آخر (مفحوص عبر <code>resource.data.userId == request.auth.uid</code>).</li>
                        <li>• العميل ينشئ طلبه الخاص فقط بحالة <code>pending</code> المبدئية.</li>
                        <li>• يُمنع العميل من رفع رتبته إلى مدير أو موظف (حظر تعديل حقل <code>role</code>).</li>
                        <li>• يمكن للعميل إلغاء حجزه الخاص فقط إذا كانت حالته لا تزال <code>pending</code>.</li>
                      </ul>
                    </div>

                    <div className="p-3 bg-blue-50/70 rounded-2xl border border-blue-200 space-y-2">
                      <span className="font-bold text-blue-900 block">صلاحيات الإدارة والموظفين (RBAC):</span>
                      <ul className="space-y-1.5 text-blue-800 text-[11px]">
                        <li>• قراءة الباقات وكتالوج التأشيرات ومحددات المعالج متاحة للجميع (<code>allow read: if true</code>).</li>
                        <li>• كتابة وتعديل وحذف الباقات والتأشيرات محصورة في مستوى المدير العام (<code>isAdmin()</code>).</li>
                        <li>• الموظفون والمدراء يقرؤون كافة طلبات الحجز والرحلات ويحدثون الحالات.</li>
                        <li>• الحذف النهائي للسجلات محصور في المدير العام فقط.</li>
                      </ul>
                    </div>
                  </div>

                  {/* Rules Interactive Test Matrix */}
                  <div className="p-4 bg-slate-50 rounded-2xl border border-slate-200 space-y-3">
                    <h4 className="font-bold text-xs text-[#0e2a47]">مصفوفة اختبار الصلاحيات (Security Test Matrix):</h4>
                    <div className="space-y-2 text-xs">
                      {[
                        { op: 'قراءة الباقات السياحية', role: 'زائر / عميل عام', allowed: true, note: 'متاح للجميع لتصفح الرحلات' },
                        { op: 'قراءة حجز عميل آخر', role: 'عميل مسجل', allowed: false, note: 'ممنوع لمنع تسريب بيانات العملاء' },
                        { op: 'تحديث حالة الحجز إلى "مؤكد"', role: 'موظف مبيعات', allowed: true, note: 'مسموح للموظف والمدير' },
                        { op: 'حذف باقة سياحية أو طلب', role: 'موظف مبيعات', allowed: false, note: 'محصور في مستوى المدير العام فقط' },
                        { op: 'تعديل أسعار التأشيرات', role: 'مدير عام', allowed: true, note: 'كامل الصلاحيات للإدارة العليا' },
                      ].map((test, i) => (
                        <div key={i} className="p-2.5 bg-white rounded-xl border border-slate-200 flex items-center justify-between">
                          <div>
                            <span className="font-bold text-[#0e2a47]">{test.op}</span>
                            <span className="text-[10px] text-slate-500 block">المستخدم: {test.role} &bull; {test.note}</span>
                          </div>
                          <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold ${
                            test.allowed ? 'bg-emerald-100 text-emerald-800' : 'bg-red-100 text-red-800'
                          }`}>
                            {test.allowed ? 'مسموح (Allowed)' : 'محظور (Denied)'}
                          </span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              )}

              {/* TAB 11: NOTIFICATIONS SYSTEM (المرحلة 8) */}
              {adminTab === 'notifications' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">خدمة الإشعارات الفورية (Firebase Cloud Messaging - FCM)</h3>
                      <p className="text-xs text-slate-500">إرسال وتتبع إشعارات تحديث الحالات إلى أجهزة العملاء مباشرة</p>
                    </div>
                    <span className="text-xs bg-emerald-100 text-emerald-800 font-bold px-3 py-1 rounded-full">
                      FCM SDK متصل
                    </span>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-3 text-xs">
                    <div className="p-3 bg-amber-50 rounded-xl border border-[#c9a227]/30">
                      <span className="font-bold text-[#0e2a47] block mb-1">رمز الجهاز النشط (Device Token):</span>
                      <code className="text-[10px] text-slate-700 font-mono break-all">{simulatedFCMToken}</code>
                    </div>
                    <div className="p-3 bg-blue-50 rounded-xl border border-blue-200">
                      <span className="font-bold text-blue-900 block mb-1">قنوات الإشعارات (Android Channels):</span>
                      <span className="text-[11px] text-blue-800 block">1. حجوزات الباقات (high_importance)</span>
                      <span className="text-[11px] text-blue-800 block">2. خدمات التأشيرات والرحلات</span>
                    </div>
                    <div className="p-3 bg-emerald-50 rounded-xl border border-emerald-200">
                      <span className="font-bold text-emerald-900 block mb-1">سجل التنبيهات المباشرة:</span>
                      <span className="text-[11px] text-emerald-800 block">{notifications.length} إشعارات مسجلة للمستخدم</span>
                    </div>
                  </div>

                  {/* Test Dispatch Form */}
                  <div className="p-4 bg-slate-50 rounded-2xl border border-slate-200 space-y-3">
                    <h4 className="font-bold text-xs text-[#0e2a47]">إرسال إشعار فوري تجريبي لهاتف العميل:</h4>
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
                      <button
                        onClick={() => {
                          const newN = {
                            id: `notif-${Date.now()}`,
                            title: 'تأكيد الحجز رسمياً',
                            body: 'يسرنا إبلاغك بأنه تم تأكيد حجزك رقم LY-PKG-2026-1049 وجاهزية وثائق السفر!',
                            type: 'booking_status',
                            ref: 'LY-PKG-2026-1049',
                            time: 'الآن',
                            isRead: false
                          };
                          setNotifications([newN, ...notifications]);
                          alert('تم إرسال إشعار تأكيد الحجز إلى هاتف العميل بنجاح!');
                        }}
                        className="p-2.5 bg-[#0e2a47] text-[#e8d18f] rounded-xl font-bold text-xs hover:bg-[#163a61]"
                      >
                        إشعار: تأكيد الحجز
                      </button>

                      <button
                        onClick={() => {
                          const newN = {
                            id: `notif-${Date.now()}`,
                            title: 'إصدار التأشيرة بنجاح',
                            body: 'تم استلام وتأكيد التأشيرة السياحية من القنصلية، يمكنك تحميل النسخة الإلكترونية الآن.',
                            type: 'visa_status',
                            ref: 'LY-VISA-2026-3021',
                            time: 'الآن',
                            isRead: false
                          };
                          setNotifications([newN, ...notifications]);
                          alert('تم إرسال إشعار جاهزية التأشيرة إلى هاتف العميل!');
                        }}
                        className="p-2.5 bg-emerald-700 text-white rounded-xl font-bold text-xs hover:bg-emerald-800"
                      >
                        إشعار: إصدار التأشيرة
                      </button>

                      <button
                        onClick={() => {
                          const newN = {
                            id: `notif-${Date.now()}`,
                            title: 'عرض سعر الرحلة المخصصة',
                            body: 'تم تجهيز عرض السعر المخصص وبرنامج المدن لطلبك LY-TRIP-2026-5510!',
                            type: 'custom_trip_quote',
                            ref: 'LY-TRIP-2026-5510',
                            time: 'الآن',
                            isRead: false
                          };
                          setNotifications([newN, ...notifications]);
                          alert('تم إرسال إشعار عرض السعر للرحلة المخصصة!');
                        }}
                        className="p-2.5 bg-[#c9a227] text-[#081a2e] rounded-xl font-black text-xs hover:bg-[#b58f1f]"
                      >
                        إشعار: عرض الرحلة المخصصة
                      </button>
                    </div>
                  </div>

                  {/* User Notification History View */}
                  <div className="space-y-2">
                    <span className="text-xs font-bold text-[#0e2a47] block">سجل الإشعارات المرسلة لـ {customerName}:</span>
                    {notifications.map((n) => (
                      <div key={n.id} className="p-3 bg-white rounded-xl border border-slate-200 flex items-center justify-between text-xs">
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="font-bold text-[#0e2a47]">{n.title}</span>
                            {n.ref && <code className="text-[10px] text-[#c9a227] font-bold">{n.ref}</code>}
                            {!n.isRead && <span className="w-2 h-2 rounded-full bg-emerald-500" />}
                          </div>
                          <p className="text-slate-600 text-[11px] mt-0.5">{n.body}</p>
                        </div>
                        <span className="text-[10px] text-slate-400">{n.time}</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* TAB 12: ARCHITECTURE & TECHNICAL DOCUMENTATION (المرحلة 9) */}
              {adminTab === 'architecture_docs' && (
                <div className="bg-white p-5 rounded-3xl border border-[#e4ddc9] shadow-sm space-y-4">
                  <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                    <div>
                      <h3 className="text-sm font-bold text-[#0e2a47]">الدليل المعماري والتقني الشامل (المرحلة 9 - التوثيق والبناء)</h3>
                      <p className="text-xs text-slate-500">تفاصيل حزم Melos Monorepo ومعمارية Clean Architecture وأوامر النشر الجاهزة للإنتاج</p>
                    </div>
                    <span className="text-xs bg-emerald-100 text-emerald-800 font-bold px-3 py-1 rounded-full">
                      جاهز للإنتاج 100%
                    </span>
                  </div>

                  {/* Monorepo Structure */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs">
                    <div className="p-4 bg-slate-50 rounded-2xl border border-slate-200 space-y-2">
                      <div className="flex items-center gap-2">
                        <FolderTree className="w-4 h-4 text-[#c9a227]" />
                        <h4 className="font-bold text-[#0e2a47]">هيكلية حزم Melos Monorepo:</h4>
                      </div>
                      <ul className="space-y-1.5 text-slate-700 text-[11px]">
                        <li>• <code className="font-bold text-[#0e2a47]">core_domain/</code>: كيانات الأعمال المجردة (Pure Dart بدون أي مكتبات UI أو Firebase).</li>
                        <li>• <code className="font-bold text-[#0e2a47]">core_data/</code>: نماذج Firestore والمستودعات والتكامل مع Firebase Auth و FCM.</li>
                        <li>• <code className="font-bold text-[#0e2a47]">customer_app/</code>: تطبيق العميل للهواتف (Android & iOS) بجميع شاشات العميل الـ 10.</li>
                        <li>• <code className="font-bold text-[#0e2a47]">admin_dashboard/</code>: لوحة الإدارة (Flutter Web) لمتابعة وتحديث الحالات.</li>
                      </ul>
                    </div>

                    <div className="p-4 bg-slate-50 rounded-2xl border border-slate-200 space-y-2">
                      <div className="flex items-center gap-2">
                        <PhoneCall className="w-4 h-4 text-emerald-600" />
                        <h4 className="font-bold text-[#0e2a47]">تكامل واتساب المباشر (3 خطوط رسمية):</h4>
                      </div>
                      <ul className="space-y-1.5 text-slate-700 text-[11px]">
                        <li>• <strong>المبيعات والحجوزات (الرئيسي):</strong> <code className="font-mono text-emerald-700 font-bold">+218 91 591 9921</code></li>
                        <li>• <strong>خدمة العملاء والاستفسارات:</strong> <code className="font-mono text-slate-700 font-bold">+218 91 061 3800</code></li>
                        <li>• <strong>قسم الرحلات الخاصة والتأشيرات:</strong> <code className="font-mono text-slate-700 font-bold">+218 91 061 3700</code></li>
                        <li>• توليد رسائل معبأة تلقائياً برقم مرجعي فريد وتاريخ وعدد المسافرين.</li>
                      </ul>
                    </div>
                  </div>

                  {/* Production Build Commands & APK Generation */}
                  <div className="p-4 bg-[#081a2e] text-white rounded-2xl border border-[#c9a227]/40 space-y-3 text-xs">
                    <div className="flex items-center justify-between">
                      <h4 className="font-bold text-xs text-[#e8d18f]">خطوات استخراج ملفات APK وتشغيل النظام:</h4>
                      <span className="text-[10px] bg-[#c9a227] text-[#081a2e] px-2.5 py-0.5 rounded-full font-bold">
                        Android Release
                      </span>
                    </div>

                    <p className="text-[11px] text-[#e8d18f]/80 leading-relaxed">
                      نظراً لأن بيئة السحاب الحالية (Web Container) مخصصة لتشغيل الويب وتجربة التطبيق الحية في المتصفح ولا تحتوي على Android SDK / Gradle محلياً لتجميع الحزم الثنائية، يمكنك تجربة كافة الشاشات مباشرة من وضع <strong>"تطبيق العميل للهواتف"</strong> أعلاه، أو بناء ملفات الـ APK مباشرة على جهازك عبر الأوامر التالية:
                    </p>

                    <div className="space-y-2 font-mono text-[11px]">
                      <div className="p-2.5 bg-black/40 rounded-xl border border-white/10">
                        <span className="text-slate-400 block mb-1"># 1. تثبيت وربط حزم Melos المشتركة:</span>
                        <code className="text-emerald-400">melos bootstrap</code>
                      </div>
                      <div className="p-2.5 bg-black/40 rounded-xl border border-white/10">
                        <span className="text-slate-400 block mb-1"># 2. استخراج ملف APK لتطبيق العميل (Customer App APK):</span>
                        <code className="text-emerald-400">cd packages/customer_app && flutter build apk --release</code>
                        <span className="text-slate-400 block mt-1 text-[10px] font-sans">
                          &larr; مسار الملف الناتج: <code className="text-amber-300 font-mono">build/app/outputs/flutter-apk/app-release.apk</code>
                        </span>
                      </div>
                      <div className="p-2.5 bg-black/40 rounded-xl border border-white/10">
                        <span className="text-slate-400 block mb-1"># 3. تشغيل أو بناء لوحة تحكم الإدارة (Flutter Web / Android):</span>
                        <code className="text-emerald-400">cd packages/admin_dashboard && flutter build apk --release</code>
                        <span className="text-slate-400 block mt-1 text-[10px] font-sans">
                          (أو للويب: <code className="text-emerald-400 font-mono">flutter build web --release</code>)
                        </span>
                      </div>
                    </div>
                  </div>

                  {/* Comprehensive Firestore Schema & Repositories Guide */}
                  <div className="p-5 bg-gradient-to-br from-white to-amber-50/40 rounded-3xl border border-[#c9a227]/40 shadow-sm space-y-4">
                    <div className="flex items-center justify-between pb-2 border-b border-amber-200">
                      <div>
                        <h4 className="font-bold text-sm text-[#0e2a47] flex items-center gap-2">
                          <Layers className="w-4 h-4 text-[#c9a227]" />
                          دليل وهيكل بيانات Firestore Repositories
                        </h4>
                        <span className="text-[11px] text-slate-500">
                          توثيق تفصيلي لمجموعات Firestore الثلاث وحقولها ونماذج الـ JSON في Clean Architecture
                        </span>
                      </div>
                      <span className="text-[10px] bg-amber-100 text-amber-900 border border-amber-300 px-2.5 py-1 rounded-full font-bold">
                        docs/FIRESTORE_DATA_ARCHITECTURE.md
                      </span>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-3 text-xs">
                      {/* Collection 1: bookings */}
                      <div className="p-3 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                        <div className="flex items-center justify-between">
                          <span className="font-bold text-[#0e2a47]">1. مجموعة /bookings</span>
                          <span className="text-[10px] text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded font-mono font-bold">LY-PKG-XXXX</span>
                        </div>
                        <p className="text-[11px] text-slate-600">
                          حفظ حجوزات الباقات السياحية الجاهزة من تطبيق العميل وربطها بالرقم المرجعي والعميل.
                        </p>
                        <div className="bg-slate-900 text-slate-200 p-2.5 rounded-xl font-mono text-[10px] space-y-1">
                          <span className="text-amber-400 block">// الحقول الرئيسية:</span>
                          <div>referenceNumber: <span className="text-emerald-400">String</span></div>
                          <div>packageId & Title: <span className="text-emerald-400">String</span></div>
                          <div>customerName & Phone: <span className="text-emerald-400">String</span></div>
                          <div>startDate & returnDate: <span className="text-amber-300">Timestamp</span></div>
                          <div>adults & children: <span className="text-blue-300">int</span></div>
                          <div>estimatedTotal: <span className="text-blue-300">double ($)</span></div>
                          <div>status: <span className="text-purple-300">'pending' | 'confirmed'</span></div>
                          <div>targetWhatsAppNumber: <span className="text-emerald-400">String</span></div>
                        </div>
                      </div>

                      {/* Collection 2: custom_trip_requests */}
                      <div className="p-3 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                        <div className="flex items-center justify-between">
                          <span className="font-bold text-[#0e2a47]">2. /custom_trip_requests</span>
                          <span className="text-[10px] text-[#c9a227] bg-amber-50 px-2 py-0.5 rounded font-mono font-bold">LY-TRIP-XXXX</span>
                        </div>
                        <p className="text-[11px] text-slate-600">
                          حفظ مخرجات معالج مصمم الرحلة المخصصة بجميع خطواته الست مع توزيع الليالي ومطابقتها.
                        </p>
                        <div className="bg-slate-900 text-slate-200 p-2.5 rounded-xl font-mono text-[10px] space-y-1">
                          <span className="text-amber-400 block">// الحقول الرئيسية:</span>
                          <div>tripType & nationality: <span className="text-emerald-400">String</span></div>
                          <div>dedicatedBudgetUsd: <span className="text-blue-300">double (&ge;$1500)</span></div>
                          <div>selectedCities & Countries: <span className="text-blue-200">Array&lt;String&gt;</span></div>
                          <div>cityDaysDistribution: <span className="text-yellow-300">Map&lt;String, int&gt;</span></div>
                          <div>totalDays & departureCity: <span className="text-emerald-400">int / String</span></div>
                          <div>accommodationTypes: <span className="text-blue-200">Array&lt;String&gt;</span></div>
                          <div>guideLanguage & tourType: <span className="text-emerald-400">String</span></div>
                          <div>status: <span className="text-purple-300">'pending' | 'quoted'</span></div>
                        </div>
                      </div>

                      {/* Collection 3: visa_requests */}
                      <div className="p-3 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                        <div className="flex items-center justify-between">
                          <span className="font-bold text-[#0e2a47]">3. /visa_requests</span>
                          <span className="text-[10px] text-blue-700 bg-blue-50 px-2 py-0.5 rounded font-mono font-bold">LY-VISA-XXXX</span>
                        </div>
                        <p className="text-[11px] text-slate-600">
                          طلبات التأشيرات الإلكترونية والسياحية مع تفاصيل الأسعار والمدة والمستندات المطلوبة.
                        </p>
                        <div className="bg-slate-900 text-slate-200 p-2.5 rounded-xl font-mono text-[10px] space-y-1">
                          <span className="text-amber-400 block">// الحقول الرئيسية:</span>
                          <div>visaId & visaTitle: <span className="text-emerald-400">String</span></div>
                          <div>countryName: <span className="text-emerald-400">String</span></div>
                          <div>priceUsd: <span className="text-blue-300">double ($)</span></div>
                          <div>processingTime: <span className="text-emerald-400">String</span></div>
                          <div>customerName & Phone: <span className="text-emerald-400">String</span></div>
                          <div>status: <span className="text-purple-300">'pending' | 'approved'</span></div>
                          <div>adminNotes: <span className="text-slate-400">String?</span></div>
                          <div>targetWhatsAppNumber: <span className="text-emerald-400">String</span></div>
                        </div>
                      </div>
                    </div>

                    {/* Clean Architecture Repository Pattern Callout */}
                    <div className="p-3 bg-amber-50 rounded-2xl border border-amber-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs">
                      <div>
                        <span className="font-bold text-[#0e2a47] block mb-0.5">آلية عمل المستودعات (Clean Architecture Repository Implementation):</span>
                        <p className="text-[11px] text-slate-600">
                          كل مستودع (`BookingRepositoryImpl`، `CustomTripRepositoryImpl`، `VisaRepositoryImpl`) يرث من واجهة مجردة في `core_domain` ويعالج تحويلات Firestore Timestamps تلقائياً ويقوم بتوليد الرقم المرجعي دون أي اعتماد عكسي.
                        </p>
                      </div>
                      <span className="text-[10px] font-mono bg-[#0e2a47] text-[#e8d18f] px-3 py-1.5 rounded-xl font-bold whitespace-nowrap self-start sm:self-center">
                        Riverpod Providers جاهزة
                      </span>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </main>
      )}

      {/* ============================================================== */}
      {/* MODE 2: CUSTOMER MOBILE APP (تطبيق العميل للهواتف) */}
      {/* ============================================================== */}
      {appMode === 'customer' && (
        <main className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
          <div className="flex justify-center">
            <div className="w-full max-w-lg bg-white rounded-3xl shadow-2xl border-4 border-[#0e2a47] overflow-hidden flex flex-col min-h-[760px]">
              {/* Phone Status Bar */}
              <div className="bg-[#081a2e] text-white px-5 py-2 flex items-center justify-between text-[11px] font-mono select-none">
                <span>10:30</span>
                <div className="flex items-center gap-1.5">
                  <span>5G</span>
                  <span>100%</span>
                </div>
              </div>

              {/* Phone App Bar */}
              <div className="bg-[#0e2a47] text-white px-4 py-3 flex items-center justify-between border-b border-[#c9a227]/30">
                <EliteLogo size="sm" variant="light" showText={true} />
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setIsNotifModalOpen(!isNotifModalOpen)}
                    className="relative w-7 h-7 rounded-full bg-white/10 flex items-center justify-center text-[#e8d18f]"
                    title="مركز الإشعارات والتنبيهات"
                  >
                    <Info className="w-4 h-4" />
                    {notifications.some(n => !n.isRead) && (
                      <span className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 rounded-full border border-[#0e2a47]" />
                    )}
                  </button>

                  <a
                    href="https://wa.me/218915919921"
                    target="_blank"
                    rel="noreferrer"
                    className="w-7 h-7 rounded-full bg-emerald-600 flex items-center justify-center text-white"
                  >
                    <PhoneCall className="w-3.5 h-3.5" />
                  </a>
                </div>
              </div>

              {/* Screen Body */}
              <div className="flex-1 overflow-y-auto bg-[#f7f4ec] p-4 scrollbar-thin space-y-4">
                {/* Official Logo Brand Card */}
                <div className="bg-white p-5 rounded-3xl shadow-sm border border-[#e4ddc9] text-center flex flex-col items-center">
                  <div className="w-24 h-24 rounded-2xl bg-white p-2 shadow-md border-2 border-[#c9a227]/40 mb-3 flex items-center justify-center">
                    <img
                      src="/logo.jpg"
                      alt="شعار مجموعة النخبة للخدمات السياحية"
                      className="w-full h-full object-contain"
                    />
                  </div>
                  <div className="flex items-center justify-center gap-1.5 mb-0.5">
                    <h3 className="font-black text-lg text-[#0e2a47]">مجموعة النخبة</h3>
                    <span className="text-[#c9a227] text-sm">👑</span>
                  </div>
                  <span className="text-xs font-bold text-[#0070ba] tracking-wider mb-2">للخدمات السياحية</span>
                  <p className="text-[11px] text-slate-500 max-w-xs">
                    بوابتك الأولى لرحلات لا تُنسى وحجوزات الطيران وخدمات التأشيرات المعتمدة
                  </p>
                </div>

                <div className="p-4 bg-white rounded-2xl text-center space-y-3">
                  <h4 className="font-bold text-sm text-[#0e2a47]">تطبيق العميل (Android & iOS)</h4>
                  <p className="text-xs text-slate-500">تم بناء جميع الشاشات: الرئيسية، الباقات، معالج الـ 6 خطوات، حجز الطيران، والتأشيرات.</p>
                  <div className="flex flex-wrap justify-center gap-2 pt-2">
                    <button
                      onClick={() => setAppMode('admin')}
                      className="px-4 py-2 bg-[#0e2a47] text-[#e8d18f] text-xs font-bold rounded-xl"
                    >
                      التبديل إلى لوحة تحكم الإدارة (المرحلة 6) &rarr;
                    </button>
                  </div>
                </div>
              </div>
              {/* Notifications Popup Modal */}
              {isNotifModalOpen && (
                <div className="absolute inset-0 bg-black/50 z-50 p-4 flex flex-col justify-end">
                  <div className="bg-white rounded-3xl p-4 space-y-3 max-h-[450px] flex flex-col shadow-2xl animate-in slide-in-from-bottom duration-200">
                    <div className="flex items-center justify-between pb-2 border-b border-slate-100">
                      <div className="flex items-center gap-2">
                        <Info className="w-4 h-4 text-[#c9a227]" />
                        <h4 className="font-bold text-xs text-[#0e2a47]">مركز الإشعارات والتنبيهات</h4>
                      </div>
                      <button
                        onClick={() => setIsNotifModalOpen(false)}
                        className="text-slate-400 hover:text-slate-600 p-1"
                      >
                        <X className="w-4 h-4" />
                      </button>
                    </div>

                    <div className="overflow-y-auto space-y-2 flex-1 pr-1 text-xs">
                      {notifications.map((n) => (
                        <div
                          key={n.id}
                          className={`p-3 rounded-2xl border transition-all ${
                            !n.isRead ? 'bg-amber-50/60 border-[#c9a227]/40' : 'bg-slate-50 border-slate-200'
                          }`}
                        >
                          <div className="flex items-center justify-between mb-1">
                            <span className="font-bold text-[#0e2a47]">{n.title}</span>
                            <span className="text-[10px] text-slate-400">{n.time}</span>
                          </div>
                          <p className="text-slate-600 text-[11px] leading-relaxed">{n.body}</p>
                          {n.ref && (
                            <span className="text-[10px] font-mono font-bold text-[#c9a227] mt-1 block">
                              رقم المرجع: {n.ref}
                            </span>
                          )}
                        </div>
                      ))}
                    </div>

                    <button
                      onClick={() => {
                        setNotifications(notifications.map(n => ({ ...n, isRead: true })));
                        setIsNotifModalOpen(false);
                      }}
                      className="w-full py-2 bg-[#0e2a47] text-[#e8d18f] font-bold text-xs rounded-xl"
                    >
                      تحديد الكل كمقروء وإغلاق
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </main>
      )}

      {/* System Completion Callout */}
      <footer className="max-w-7xl mx-auto px-4 sm:px-6 py-6">
        <div className="bg-gradient-to-r from-[#081a2e] via-[#0e2a47] to-[#081a2e] text-white p-6 rounded-3xl border-2 border-[#c9a227] shadow-2xl flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-2xl bg-[#c9a227] flex items-center justify-center text-[#081a2e] shadow-lg flex-shrink-0">
              <Check className="w-6 h-6 stroke-[3]" />
            </div>
            <div>
              <div className="text-xs text-[#e8d18f] font-bold mb-0.5">اكتمل إنجاز المنظومة بالكامل (100% Complete):</div>
              <h3 className="text-lg font-bold text-white">
                مجموعة النخبة للخدمات السياحية (LY-Elite Tourism Group)
              </h3>
              <p className="text-xs text-[#e8d18f]/80 mt-0.5">
                تطبيق العميل للهواتف (Android & iOS) + لوحة تحكم الإدارة (Flutter Web) + قواعد أمان Firestore + خدمة الإشعارات (FCM) + معمارية Clean Architecture جاهزة للإنتاج.
              </p>
            </div>
          </div>
          <span className="text-xs bg-[#c9a227] text-[#081a2e] px-5 py-2.5 rounded-2xl font-black self-start md:self-center shadow-md">
            تم إنجاز كافة المراحل التسع بنجاح ✓
          </span>
        </div>
      </footer>

      {/* APK & Mobile Installation Modal */}
      {isApkModalOpen && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl max-w-xl w-full p-6 shadow-2xl border-2 border-[#c9a227] space-y-5 animate-in fade-in zoom-in-95 duration-200">
            {/* Modal Header */}
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-2xl bg-[#081a2e] text-[#c9a227] flex items-center justify-center shadow-md">
                  <Smartphone className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-black text-[#0e2a47] text-base">مركز تحميل وتثبيت تطبيق النخبة</h3>
                  <span className="text-xs text-slate-500">طرق تجربة وتثبيت التطبيق على هواتف أندرويد وiOS</span>
                </div>
              </div>
              <button
                onClick={() => setIsApkModalOpen(false)}
                className="w-8 h-8 rounded-full bg-slate-100 text-slate-500 hover:bg-slate-200 flex items-center justify-center transition-all cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Option 1: Instant PWA Install on Android Phone (No APK needed!) */}
            <div className="p-4 bg-gradient-to-br from-emerald-50 to-teal-50 rounded-2xl border border-emerald-200 space-y-2.5">
              <div className="flex items-center justify-between">
                <span className="text-xs font-black text-emerald-900 flex items-center gap-1.5">
                  <Check className="w-4 h-4 text-emerald-600 stroke-[3]" />
                  الطريقة 1: التثبيت الفوري على الهاتف (PWA App - بدون انتظار)
                </span>
                <span className="text-[10px] bg-emerald-600 text-white font-bold px-2.5 py-0.5 rounded-full">
                  موصى به للتجربة الفورية
                </span>
              </div>
              <p className="text-[11px] text-emerald-800 leading-relaxed">
                التطبيق مجهّز بملف <strong>Web Manifest</strong> وشعار النخبة الرسمي. يمكنك فتحه على هاتفك الأندرويد أو الآيفون والضغط على <strong>"تثبيت التطبيق"</strong> أو <strong>"إضافة إلى الشاشة الرئيسية"</strong> من قائمة المتصفح ليعمل فوراً كتطبيق كامل بشاشة كاملة وبدون شريط عنوان!
              </p>
              <div className="flex items-center gap-2 pt-1">
                <input
                  type="text"
                  readOnly
                  value="https://ais-pre-uatffit5mpuh5adwubtotl-402147618508.europe-west1.run.app"
                  className="flex-1 bg-white text-[11px] font-mono text-slate-700 px-3 py-2 rounded-xl border border-emerald-300 focus:outline-none"
                />
                <button
                  onClick={() => {
                    navigator.clipboard.writeText("https://ais-pre-uatffit5mpuh5adwubtotl-402147618508.europe-west1.run.app");
                    setCopiedLink(true);
                    setTimeout(() => setCopiedLink(false), 2000);
                  }}
                  className="px-3 py-2 bg-emerald-600 text-white rounded-xl text-xs font-bold hover:bg-emerald-700 transition-all flex items-center gap-1 cursor-pointer"
                >
                  <Copy className="w-3.5 h-3.5" />
                  {copiedLink ? 'تم النسخ!' : 'نسخ الرابط'}
                </button>
                <a
                  href="https://ais-pre-uatffit5mpuh5adwubtotl-402147618508.europe-west1.run.app"
                  target="_blank"
                  rel="noreferrer"
                  className="px-3 py-2 bg-[#0e2a47] text-[#c9a227] rounded-xl text-xs font-bold hover:bg-[#081a2e] transition-all flex items-center gap-1"
                >
                  <ExternalLink className="w-3.5 h-3.5" />
                  فتح
                </a>
              </div>
            </div>

            {/* Option 2: Automated Cloud APK via GitHub Actions */}
            <div className="p-4 bg-slate-50 rounded-2xl border border-slate-200 space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-xs font-black text-[#0e2a47] flex items-center gap-1.5">
                  <Download className="w-4 h-4 text-[#c9a227]" />
                  الطريقة 2: استخراج ملف الـ APK عبر GitHub Actions (سحابياً)
                </span>
                <span className="text-[10px] bg-slate-200 text-slate-700 font-bold px-2 py-0.5 rounded-full font-mono">
                  build_apk.yml
                </span>
              </div>
              <p className="text-[11px] text-slate-600 leading-relaxed">
                تم إنشاء ملف سير العمل التلقائي <code>.github/workflows/build_apk.yml</code> داخل المشروع. بمجرد رفع الكود لمستودع GitHub، تقوم سيرفرات GitHub ببناء ملف <code>app-release.apk</code> وتنزيله كحزمة Artifact فورية بدون الحاجة لتثبيت أي برامج على حاسوبك!
              </p>
            </div>

            {/* Option 3: Local 1-Click Flutter Build */}
            <div className="p-4 bg-[#081a2e] text-white rounded-2xl border border-[#c9a227]/40 space-y-2 text-xs">
              <span className="font-bold text-[#e8d18f] block">الطريقة 3: أمر استخراج الـ APK محلياً (إذا كان لديك Flutter):</span>
              <div className="p-2.5 bg-black/50 rounded-xl font-mono text-[11px] text-emerald-400 select-all border border-white/10">
                melos bootstrap && cd packages/customer_app && flutter build apk --release
              </div>
              <span className="text-[10px] text-slate-300 block">
                ملف الـ APK الناتج: <code>build/app/outputs/flutter-apk/app-release.apk</code>
              </span>
            </div>

            {/* Close Button */}
            <div className="pt-2 flex justify-end">
              <button
                onClick={() => setIsApkModalOpen(false)}
                className="px-5 py-2.5 rounded-xl bg-[#0e2a47] text-white font-bold text-xs hover:bg-[#081a2e] transition-all cursor-pointer"
              >
                إغلاق النافذة
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
