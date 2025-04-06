import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math'; // min() fonksiyonu için gerekli
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trips_provider.dart';
import '../../models/trip_model.dart';
import '../../models/user_model.dart';
import '../../utils/logger.dart'; // Logger için import eklendi
import '../../utils/date_helpers.dart'; // DateHelpers için import eklendi
import 'admin_create_trip_screen.dart';
import 'trip_detail_screen.dart'; // Sefer detay ekranı için import eklendi
import 'profile_edit_screen.dart';
import '../../widgets/profile_image_widget.dart';

class AdminTruckScreen extends StatefulWidget {
  const AdminTruckScreen({super.key});

  @override
  State<AdminTruckScreen> createState() => _AdminTruckScreenState();
}

class _AdminTruckScreenState extends State<AdminTruckScreen> {
  // Class variables
  String _selectedFilter = 'all'; // 'all', 'active', 'completed'
  String _selectedTimeFilter = 'Bu Hafta';
  bool _isLoading = false;
  List<Trip> _filteredTrips = [];
  final TextEditingController _searchController = TextEditingController();

  // Date range for filtering - Bu haftanın başlangıç ve bitiş tarihleri
  late DateTime _startDate;
  late DateTime _endDate;

  // Şu an kullanılan tarih aralığını ayarla
  void _setupDefaultDateRange() {
    final now = DateTime.now();

    // Haftanın başlangıcını hesapla (Pazartesi)
    _startDate = now.subtract(Duration(days: now.weekday - 1));

    // Eğer şimdiki tarih 2025 yılındaysa veya sonrasındaysa, son tarih sorunu önlemek için
    // Basit bir geçici çözüm olarak 2024 yılını kullan (uzun vadede gerçek tarih kullanılması önerilir)
    if (_startDate.year >= 2025) {
      // 2024 yılının aynı haftasını kullan
      _startDate = DateTime(2024, _startDate.month, _startDate.day);
    }

    // Haftanın sonunu hesapla (Pazar)
    _endDate = _startDate.add(const Duration(days: 6));
  }

  @override
  void initState() {
    super.initState();

    // Varsayılan tarih aralığını ayarla
    _setupDefaultDateRange();

    _loadTrips();

    // Arama alanı değişiklikleri dinleme
    _searchController.addListener(_filterTrips);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTrips);
    _searchController.dispose();
    super.dispose();
  }

  // Seferleri yükleme
  Future<void> _loadTrips() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<TripsProvider>(context, listen: false).loadTrips();
      _filterTrips();
    } catch (e) {
      // Hata durumunda snackbar gösterilmesi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seferler yüklenirken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Seferleri filtreleme - Basitleştirilmiş ve iyileştirilmiş
  void _filterTrips() {
    final tripsProvider = Provider.of<TripsProvider>(context, listen: false);
    final allTrips = tripsProvider.trips;
    print("🔍 FİLTRELEME BAŞLIYOR: Toplam sefer sayısı: ${allTrips.length}");
    print(
        "🔍 Seçilen tarih aralığı: ${_startDate.toString()} - ${_endDate.toString()}");

    setState(() {
      // Önce seferleri kopyalayalım
      List<Trip> tempTrips = List.from(allTrips);

      // 1. ADIM: DURUM FİLTRELEMESİ
      if (_selectedFilter == 'active') {
        tempTrips = tempTrips.where((trip) => trip.isActive).toList();
        print("🔍 Aktif seferler filtrelendi: ${tempTrips.length} sefer kaldı");
      } else if (_selectedFilter == 'completed') {
        tempTrips = tempTrips.where((trip) => !trip.isActive).toList();
        print(
            "🔍 Tamamlanan seferler filtrelendi: ${tempTrips.length} sefer kaldı");
      }

      // 2. ADIM: TARİH FİLTRELEMESİ
      if (tempTrips.isNotEmpty) {
        // Filtreleme öncesi sefer tarihlerini yazdıralım
        print("🔍 Tarih filtrelemesi öncesi örnek sefer tarihleri:");
        for (int i = 0; i < min(3, tempTrips.length); i++) {
          print(
              "   - Sefer #${i + 1}: ${tempTrips[i].tripNumber}, Tarih: ${tempTrips[i].startDate}, Formatlanmış: ${tempTrips[i].formattedStartDate}");
        }

        // Önceki listeyi yedekleyelim
        final List<Trip> beforeDateFilter = List.from(tempTrips);

        // TARİH FİLTRELEMESİ
        tempTrips = tempTrips.where((trip) {
          // Seferin tarihini analiz edelim
          DateTime? tripDate = _parseTripDate(trip);

          // Tarih elde edemedik, bu seferi listede tutalım
          if (tripDate == null) {
            print(
                "⚠️ Tarih çözülemedi: ${trip.tripNumber} - ${trip.startDate}");
            return true;
          }

          // Tarih karşılaştırma - Sadece ay ve gün dikkate alınarak
          final bool inRange =
              _isDateInRangeIgnoringYear(tripDate, _startDate, _endDate);

          if (!inRange) {
            print(
                "❌ Tarih aralık dışı: ${trip.tripNumber}, Tarih: $tripDate (${_startDate} - ${_endDate})");
          }

          return inRange;
        }).toList();

        print(
            "🔍 Tarih filtrelemesi sonrası: ${tempTrips.length} sefer kaldı (önceki: ${beforeDateFilter.length})");

        // Eğer filtreleme sonucu boşsa ve ana filtremiz 'all' ise, sonuçları koruyalım
        if (tempTrips.isEmpty && _selectedFilter == 'all') {
          print(
              "⚠️ Tarih filtrelemesi tüm seferleri eledi, tüm seferler gösteriliyor");
          tempTrips = beforeDateFilter;
        }
      }

      // 3. ADIM: ARAMA FİLTRELEMESİ
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        final beforeSearchFilter = tempTrips.length;

        tempTrips = tempTrips.where((trip) {
          return trip.tripNumber.toLowerCase().contains(searchTerm) ||
              (trip.vehiclePlate?.toLowerCase().contains(searchTerm) ??
                  false) ||
              (trip.driverName?.toLowerCase().contains(searchTerm) ?? false);
        }).toList();

        print(
            "🔍 Arama filtresi sonrası: ${tempTrips.length} sefer kaldı (önceki: $beforeSearchFilter)");
      }

      // Sonuçları atayalım ve devam edenleri önce gösterelim
      _filteredTrips = tempTrips;
      
      // Devam eden seferleri önce göster
      _filteredTrips.sort((a, b) {
        // Önce durum karşılaştırması (devam edenler önce)
        if (a.isActive && !b.isActive) return -1; // a devam ediyor, b tamamlanmış -> a önce
        if (!a.isActive && b.isActive) return 1;  // a tamamlanmış, b devam ediyor -> b önce
        
        // Eğer iki sefer de aynı durumdaysa, tarihe göre sırala (en yeniden en eskiye)
        return b.createdAt.compareTo(a.createdAt);
      });
      
      print(
          "✅ Filtreleme tamamlandı: ${_filteredTrips.length} sefer gösteriliyor");
    });
  }

  // Sefer tarihini çözümleme - date parsing için yardımcı fonksiyon
  DateTime? _parseTripDate(Trip trip) {
    // 1. ADIM: Formatlanmış tarihi deneyelim (dd.MM.yyyy)
    try {
      final formattedDate = trip.formattedStartDate;
      if (formattedDate != null && formattedDate.isNotEmpty) {
        final parts = formattedDate.split('.');
        if (parts.length == 3) {
          return DateTime(
              int.parse(parts[2]), // yıl
              int.parse(parts[1]), // ay
              int.parse(parts[0]) // gün
              );
        }
      }
    } catch (e) {
      // Sessizce devam et, diğer formatları deneyelim
    }

    // 2. ADIM: ISO formatını deneyelim (yyyy-MM-dd)
    try {
      if (trip.startDate != null && trip.startDate.isNotEmpty) {
        if (trip.startDate.contains('-')) {
          return DateTime.parse(trip.startDate);
        }
      }
    } catch (e) {
      // Sessizce devam et, diğer formatları deneyelim
    }

    // 3. ADIM: Noktalı formatı deneyelim (dd.MM.yyyy)
    try {
      if (trip.startDate != null && trip.startDate.contains('.')) {
        final parts = trip.startDate.split('.');
        if (parts.length == 3) {
          return DateTime(
              int.parse(parts[2]), // yıl
              int.parse(parts[1]), // ay
              int.parse(parts[0]) // gün
              );
        }
      }
    } catch (e) {
      // Sessizce devam et, diğer formatları deneyelim
    }

    // 4. ADIM: Eğik çizgili formatı deneyelim (dd/MM/yyyy)
    try {
      if (trip.startDate != null && trip.startDate.contains('/')) {
        final parts = trip.startDate.split('/');
        if (parts.length == 3) {
          return DateTime(
              int.parse(parts[2]), // yıl
              int.parse(parts[1]), // ay
              int.parse(parts[0]) // gün
              );
        }
      }
    } catch (e) {
      // Sessizce devam et
    }

    // Hiçbir format uymadı
    return null;
  }

  // Show date range picker - DateHelpers ile geliştirilmiş
  Future<void> _showDateRangePicker() async {
    try {
      logger.d("Tarih seçici açılıyor...");

      // Seçim için güvenli tarih aralıkları tanımla
      final DateTime now = DateTime.now();
      final DateTime safeFirstDate = DateTime(2020, 1, 1);
      final DateTime safeLastDate = DateTime(now.year + 1, 12, 31);

      // Güvenli başlangıç ve bitiş tarihlerini kontrol et
      final DateTime safeStartDate =
          _startDate.isAfter(safeLastDate) ? safeFirstDate : _startDate;
      final DateTime safeEndDate =
          _endDate.isAfter(safeLastDate) ? safeLastDate : _endDate;

      // DateHelpers ile geliştirilmiş Türkçe tarih seçici
      final DateTimeRange? picked = await DateHelpers.showTurkishDateRangePicker(
        context,
        initialDateRange: DateTimeRange(start: safeStartDate, end: safeEndDate),
        firstDate: safeFirstDate,
        lastDate: safeLastDate,
      );

      if (picked != null) {
        setState(() {
          _startDate = picked.start;
          _endDate = picked.end;

          // Update filter text based on selection
          if (DateHelpers.isCurrentWeek(picked)) {
            _selectedTimeFilter = 'Bu Hafta';
          } else if (DateHelpers.isCurrentMonth(picked)) {
            _selectedTimeFilter = 'Bu Ay';
          } else {
            // Türkçe format - DD MMM - DD MMM
            _selectedTimeFilter = DateHelpers.formatDateRange(picked.start, picked.end);
          }

          logger.d("Seçilen tarih aralığı: $_selectedTimeFilter");
          // Re-apply filters
          _filterTrips();
        });
      } else {
        logger.d("Tarih seçimi iptal edildi");
      }
    } catch (e) {
      logger.e("Tarih seçici hatası: $e");
      // Hata durumunda kullanıcıya bilgi verelim
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarih seçici açılırken bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Check if the selected date range is current week
  bool _isCurrentWeek(DateTime start, DateTime end) {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final currentWeekEnd = currentWeekStart.add(const Duration(days: 6));

    return start.year == currentWeekStart.year &&
        start.month == currentWeekStart.month &&
        start.day == currentWeekStart.day &&
        end.year == currentWeekEnd.year &&
        end.month == currentWeekEnd.month &&
        end.day == currentWeekEnd.day;
  }

  // Check if the selected date range is current month
  bool _isCurrentMonth(DateTime start, DateTime end) {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final currentMonthEnd =
        DateTime(now.year, now.month + 1, 0); // Last day of month

    return start.year == currentMonthStart.year &&
        start.month == currentMonthStart.month &&
        start.day == currentMonthStart.day &&
        end.year == currentMonthEnd.year &&
        end.month == currentMonthEnd.month &&
        end.day == currentMonthEnd.day;
  }

  // Yılı dikkate almadan tarih aralığı kontrolü - Basitleştirilmiş
  bool _isDateInRangeIgnoringYear(
      DateTime date, DateTime rangeStart, DateTime rangeEnd) {
    // Sadece tarihlerin gün ve ay değerlerini karşılaştır
    final dateMonthDay = (date.month * 100) + date.day; // örn: Mart 15 = 315
    final startMonthDay =
        (rangeStart.month * 100) + rangeStart.day; // örn: Mart 10 = 310
    final endMonthDay =
        (rangeEnd.month * 100) + rangeEnd.day; // örn: Mart 20 = 320

    print(
        "📅 Ay-Gün Kontrolü: Sefer ${date.day}/${date.month} ---- Aralık ${rangeStart.day}/${rangeStart.month} - ${rangeEnd.day}/${rangeEnd.month}");
    print(
        "📅 Ay-Gün Değerleri: Sefer $dateMonthDay ---- Aralık $startMonthDay - $endMonthDay");

    // Normal durum: Başlangıç < Bitiş (aynı yıl içinde veya ocak-aralık arası değil)
    if (startMonthDay <= endMonthDay) {
      final inRange =
          dateMonthDay >= startMonthDay && dateMonthDay <= endMonthDay;
      print("📅 Normal Aralık Kontrolü: $inRange");
      return inRange;
    }
    // Yıl geçişi durumu: Aralık-Ocak arası gibi (Başlangıç > Bitiş)
    else {
      // Tarih ya başlangıçtan sonra (Aralık) ya da bitişten önce (Ocak) ise aralıktadır
      final inRange =
          dateMonthDay >= startMonthDay || dateMonthDay <= endMonthDay;
      print("📅 Yıl Geçişi Aralık Kontrolü: $inRange");
      return inRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tripsProvider = Provider.of<TripsProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            // Gradient background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 534,
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
              ),
            ),

            // Main content area (Light gray background)
            Positioned(
              left: 0,
              top: 204,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 204,
                decoration: ShapeDecoration(
                  color: AppTheme.backgroundGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // App Bar
                  _buildAppBar(currentUser: currentUser),

                  // Filter tabs
                  _buildFilterTabs(),

                  // Trips list
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.backgroundGrey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Search and date filter
                          _buildSearchAndFilter(),

                          // Trip count and date range info
                          _buildInfoRow(tripsProvider: tripsProvider),

                          // Trips list
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildTripsList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              left: 15,
              bottom: 45,
              child: _buildBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  // App Bar Widget
  Widget _buildAppBar({required User? currentUser}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with profile and company name
              Row(
                children: [
                  // Profile
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                    },
                    child: ProfileImageWidget(
                      imageUrl: currentUser?.profileImageUrl,
                      initials: currentUser?.initials,
                      companyName: currentUser?.companyName,
                      radius: 18.5,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Text(
                    (currentUser?.companyName ?? 'Fırathan Lojistik').length >
                            20
                        ? (currentUser?.companyName ?? 'Fırathan Lojistik')
                            .substring(0, 20)
                        : currentUser?.companyName ?? 'Fırathan Lojistik',
                    style: const TextStyle(
                      color: Color(0xFFDEDFE1),
                      fontSize: 20,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      height: 0,
                      letterSpacing: 0.60,
                    ),
                  ),
                ],
              ),

              // "Seferler" Title - Added as big text on the left
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                child: Text(
                  'Seferler',
                  style: AppTheme.manropeBold(22, Colors.white),
                ),
              ),
            ],
          ),

          // Sefer Oluştur button positioned to be vertically centered with "Seferler" text
          Positioned(
            right: 0,
            bottom:
                0, // Aligns with the bottom of the Column, where "Seferler" is
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminCreateTripScreen(),
                  ),
                ).then((_) {
                  // Refresh trips when returning from create screen
                  if (mounted) {
                    Provider.of<TripsProvider>(context, listen: false)
                        .loadTrips();
                  }
                });
              },
              child: Container(
                width: 137,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1A000000), // %10 saydamlık
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Sefer Oluştur",
                    style: AppTheme.manropeSemiBold(16, AppTheme.textDark),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Filter Tabs Widget
  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 1),
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            // Tümü
            _buildFilterTab(
              title: 'Tümü',
              isSelected: _selectedFilter == 'all',
              onTap: () => setState(() {
                _selectedFilter = 'all';
                _filterTrips();
              }),
            ),
            const SizedBox(width: 35),

            // Devam Eden
            _buildFilterTab(
              title: 'Devam Eden',
              isSelected: _selectedFilter == 'active',
              onTap: () => setState(() {
                _selectedFilter = 'active';
                _filterTrips();
              }),
            ),
            const SizedBox(width: 35),

            // Tamamlanan
            _buildFilterTab(
              title: 'Tamamlanan',
              isSelected: _selectedFilter == 'completed',
              onTap: () => setState(() {
                _selectedFilter = 'completed';
                _filterTrips();
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Individual Filter Tab
  Widget _buildFilterTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF84AAC9),
              fontSize: 15,
              fontFamily: 'Manrope',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 1),
          if (isSelected)
            Container(
              height: 3,
              width: title.length * 8.0, // Adjust width based on text length
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  // Search and Date Filter Widget
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              width: 239,
              height: 45,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFDFE2E3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x0D000000), // %5 saydamlık
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Seferlerde ara...',
                  hintStyle: const TextStyle(
                    color: Color(0xFFC1C1C2),
                    fontSize: 15,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child:
                        Icon(Icons.search, color: Color(0xFFC1C1C2), size: 24),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Date filter
          GestureDetector(
            onTap: () => _showDateRangePicker(),
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFDFE2E3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x0D000000), // %5 saydamlık
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month,
                      size: 20, color: Color(0xFFC1C2C2)),
                  const SizedBox(width: 8),
                  Text(
                    _selectedTimeFilter,
                    style: const TextStyle(
                      color: const Color(0xFF474747),
                      fontSize: 15,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      height: 1.60,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF838383)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Info Row (Trip count and date range)
  Widget _buildInfoRow({required TripsProvider tripsProvider}) {
    // Seçilen tarih aralığını formatla
    final startFormatted =
        '${_startDate.day.toString().padLeft(2, '0')}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.year}';
    final endFormatted =
        '${_endDate.day.toString().padLeft(2, '0')}/${_endDate.month.toString().padLeft(2, '0')}/${_endDate.year}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Trip count
          Text(
            'Toplam ${_filteredTrips.length} Sefer',
            style: AppTheme.manropeRegular(13, const Color(0xFFC1C1C2)),
          ),

          // Date range - Boşluk ekleyelim
          Text(
            '$startFormatted - $endFormatted',
            style: AppTheme.manropeRegular(13, const Color(0xFFC1C1C2)),
          ),
        ],
      ),
    );
  }

  // Trips List Widget
  Widget _buildTripsList() {
    if (_filteredTrips.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car_outlined,
                  size: 48, color: AppTheme.textLightGrey),
              const SizedBox(height: 16),
              Text(
                'Sefer bulunamadı',
                style: AppTheme.manropeSemiBold(16, AppTheme.textLightGrey),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        itemCount: _filteredTrips.length,
        itemBuilder: (context, index) {
          final trip = _filteredTrips[index];
          return _buildTripCard(trip);
        },
      ),
    );
  }

  // Individual Trip Card
  Widget _buildTripCard(Trip trip) {
    return GestureDetector(
      onTap: () => _navigateToTripDetail(trip),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: trip.isActive 
                ? AppTheme.primary.withAlpha(51) 
                : const Color(0xFFEAEAEA),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Mevcut kart içeriği
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Trip number
                      Row(
                        children: [
                          Text(
                            trip.tripNumber,
                            style: AppTheme.manropeBold(18, const Color(0xFF474747)),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            trip.isActive ? Icons.local_shipping : Icons.done_all,
                            color: trip.isActive ? AppTheme.primary : Colors.green,
                            size: 16,
                          ),
                        ],
                      ),

                      // Status badge
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: trip.isActive
                              ? const Color(0xFFD3F0FF)
                              : const Color(0xFFDBFFDF),
                          borderRadius: BorderRadius.circular(20), // Daha yuvarlak
                        ),
                        child: Text(
                          trip.isActive ? 'Devam Ediyor' : 'Tamamlandı',
                          style: AppTheme.manropeBold(
                            11,
                            trip.isActive
                                ? const Color(0xFF2D4856)
                                : const Color(0xFF5D8765),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Tarih bilgisi daha okunaklı düzende
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16, color: Color(0xFFBCBEC2)),
                      const SizedBox(width: 4),
                      Text(
                        trip.formattedStartDate,
                        style: AppTheme.manropeSemiBold(13, const Color(0xFFBCBEC2)),
                      ),
                      Text(
                        ' ${trip.createdAt.hour}:${trip.createdAt.minute.toString().padLeft(2, '0')}',
                        style: AppTheme.manropeSemiBold(13, const Color(0xFFBCBEC2)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Araç ve sürücü bilgisi
                  Row(
                    children: [
                      Icon(Icons.directions_car, size: 16, color: Color(0xFF838383)),
                      const SizedBox(width: 4),
                      Text(
                        trip.vehiclePlate ?? "Plaka yok",
                        style: AppTheme.manropeSemiBold(13, const Color(0xFF838383)),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.person, size: 16, color: Color(0xFF838383)),
                      const SizedBox(width: 4),
                      Text(
                        trip.driverName ?? "Sürücü atanmadı",
                        style: AppTheme.manropeSemiBold(13, const Color(0xFF838383)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Sağa doğru ok ikonu ekleyelim
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Detay sayfasına yönlendirme metodu
  void _navigateToTripDetail(Trip trip) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailScreen(trip: trip),
      ),
    );
    
    // Eğer detay sayfasından güncellenmiş veri ile dönüldüyse listeyi yenile
    if (result == true) {
      _loadTrips();
    }
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 69,
      decoration: ShapeDecoration(
        gradient: AppTheme.navBarGradient,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(
            label: 'Ana Sayfa',
            icon: Icons.home,
            isActive: false,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin_home');
            },
          ),
          _navItem(
            label: 'Giderler',
            icon: Icons.attach_money,
            isActive: false,
            onTap: () {
              // Handle navigation
            },
          ),
          _navItem(
            label: 'Seferler',
            icon: Icons.local_shipping,
            isActive: true,
            onTap: () {
              // Already on this screen
            },
          ),
          _navItem(
            label: 'Hesabım',
            icon: Icons.person,
            isActive: false,
            onTap: () {
              // Handle navigation
            },
          ),
          _navItem(
            label: 'Ayarlar',
            icon: Icons.settings,
            isActive: false,
            onTap: () {
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }

  // Individual Navigation Item
  Widget _navItem({
    required String label,
    required IconData icon,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : AppTheme.navIconColor,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppTheme.navIconColor,
              fontFamily: 'Manrope',
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
