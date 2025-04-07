import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../config/theme.dart';
import '../../models/load_model.dart';
import '../../models/trip_model.dart';
import '../../providers/trips_provider.dart';
import '../../utils/logger.dart';
import '../../utils/date_helpers.dart';
import '../admin/add_load_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailScreen({
    super.key,
    required this.trip,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool _isLoading = false;
  List<Load> _additionalLoads = []; // Yeni eklenen yükleri tutacak liste

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null);
    logger.d("Sefer detay ekranı açıldı: ${widget.trip.tripNumber}");
  }

  // Durum güncelleme metodu
  Future<void> _updateTripStatus(String newStatus) async {
    setState(() {
      _isLoading = true;
    });

    try {
      logger.d("Sefer durumu güncelleniyor: ${widget.trip.id} -> $newStatus");

      final success = await Provider.of<TripsProvider>(context, listen: false)
          .updateTripStatus(widget.trip.id, newStatus);

      if (success && mounted) {
        logger.i("Sefer durumu başarıyla güncellendi");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sefer durumu güncellendi'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      logger.e("Sefer durumu güncellenirken hata: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Durum güncellenirken hata: $e'),
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

  // Durum güncelleme bottom sheet
  void _showStatusUpdateDialog() {
    final statuses = [
      'Yükleme Yapılıyor',
      'Yolda',
      'Teslimata Yakın',
      'Tamamlandı',
    ];

    String currentStatus = widget.trip.status ?? 'Devam Ediyor';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sefer Durumunu Güncelle',
                  style: AppTheme.manropeBold(18),
                ),
                const SizedBox(height: 16),
                for (final status in statuses)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      status,
                      style: AppTheme.manropeSemiBold(16),
                    ),
                    leading: Radio<String>(
                      value: status,
                      groupValue: currentStatus,
                      onChanged: (value) {
                        if (value != null) {
                          Navigator.pop(context);
                          _updateTripStatus(value);
                        }
                      },
                      activeColor: AppTheme.primary,
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  // Bottom nav bar builder
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
          _bottomNavItem(Icons.home, 'Ana Sayfa', false, () {
            Navigator.pushReplacementNamed(context, '/admin_home');
          }),
          _bottomNavItem(Icons.attach_money, 'Giderler', false, () {
            // Handle navigation
          }),
          _bottomNavItem(Icons.local_shipping, 'Seferler', true, () {
            // Already on this screen
          }),
          _bottomNavItem(Icons.person, 'Hesabım', false, () {
            // Handle navigation
          }),
          _bottomNavItem(Icons.settings, 'Ayarlar', false, () {
            // Handle navigation
          }),
        ],
      ),
    );
  }

  // Toplam öğe sayısını döndüren yardımcı metod
  int _getItemCount() {
    // Eğer hem trip.loads hem de _additionalLoads boşsa, 2 demo yük göster
    if ((widget.trip.loads == null || widget.trip.loads!.isEmpty) &&
        _additionalLoads.isEmpty) {
      return 2; // Demo için 2 yük
    }

    // Değilse, her iki listenin toplamını döndür
    int originalCount = widget.trip.loads?.length ?? 0;
    return originalCount + _additionalLoads.length;
  }

  // Belirli bir indeksteki yükü döndüren yardımcı metod
  Load _getLoadAtIndex(int index) {
    // Eğer hem trip.loads hem de _additionalLoads boşsa, demo yükleri döndür
    if ((widget.trip.loads == null || widget.trip.loads!.isEmpty) &&
        _additionalLoads.isEmpty) {
      final demoLoads = [
        Load(
          id: 1,
          name: 'Paletli Mermer Fayans',
          price: 14412,
          customerName: 'Gediz Ekol Madencilik',
          startLocation: 'Gediz, Kütahya',
          endLocation: 'Pozantı,Adana',
          loadPoint: 3,
        ),
        Load(
          id: 2,
          name: 'Paletli Mermer Fayans',
          price: 14412,
          customerName: 'Gediz Ekol Madencilik',
          startLocation: 'Gediz, Kütahya',
          endLocation: 'Pozantı,Adana',
          loadPoint: 3,
        )
      ];
      return demoLoads[index];
    }

    // Önce widget.trip.loads içindeki yükleri göster (eğer varsa)
    int originalCount = widget.trip.loads?.length ?? 0;

    if (index < originalCount) {
      return widget.trip.loads![index];
    } else {
      // Sonra _additionalLoads içindeki yükleri göster
      return _additionalLoads[index - originalCount];
    }
  }

  // Navigation item
  Widget _bottomNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            // Gradient Background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 534,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF06263E),
                      const Color(0xFF10344F),
                      const Color(0xFF1E485C)
                    ],
                  ),
                ),
              ),
            ),

            // App Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Geri butonu
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),

                    // Ekran başlığı
                    Text(
                      'Sefer Detayları',
                      style: TextStyle(
                        color: const Color(0xFFDEDFE1),
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Trip Details Card (Yeni Tasarım)
            Positioned(
              left: 20,
              right: 20,
              top: 112,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x7F082740),
                      blurRadius: 4.70,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst Satır - Sefer Numarası ve Araç
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sefer Numarası
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sefer Numarası',
                              style: const TextStyle(
                                color: Color(0xFFBBBDC1),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.trip.tripNumber,
                              style: const TextStyle(
                                color: Color(0xFF474747),
                                fontSize: 18,
                                fontFamily: 'Clash Grotesk',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),

                        // Araç
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Araç',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFFBBBDC1),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.trip.vehiclePlate ?? '43 SB 076',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFF474747),
                                fontSize: 18,
                                fontFamily: 'Clash Grotesk',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Orta Satır - Şöför ve Durumu Güncelle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Şöför
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Şoför',
                              style: const TextStyle(
                                color: Color(0xFFBBBDC1),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.trip.driverName ?? 'Yaşar Bakış',
                              style: const TextStyle(
                                color: Color(0xFF474747),
                                fontSize: 22,
                                fontFamily: 'Clash Grotesk',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),

                        // Durumu Güncelle Butonu
                        InkWell(
                          onTap: _isLoading ? null : _showStatusUpdateDialog,
                          child: Container(
                            width: 158, // Sabit genişlik
                            height: 35, // Sabit yükseklik
                            decoration: BoxDecoration(
                              color: Colors.white, // Arka plan rengi (#FFFFFF)
                              borderRadius: BorderRadius.circular(
                                  10), // Köşe yuvarlaklığı 10
                              border: Border.all(
                                color: const Color(
                                    0xFFE0E2E3), // Çizgi rengi (#E0E2E3)
                                width: 1, // Kenar çizgisi kalınlığı (1)
                              ),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF474747),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Durumu Güncelle',
                                      style: TextStyle(
                                        color: Color(0xFF474747),
                                        fontSize: 18,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Alt Satır - Başlangıç ve Bitiş Tarihleri
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Başlangıç Tarihi
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Konum ikonu daire
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF2B404F),
                                  size: 22,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Başlangıç Tarihi metin
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Başlangıç Tarihi',
                                  style: const TextStyle(
                                    color: Color(0xFFBBBDC1),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 2,
                                  ),
                                ),
                                Text(
                                  // String'i DateTime'a dönüştür
                                  DateHelpers.formatTurkishDate(
                                      DateTime.parse(widget.trip.startDate)),
                                  style: const TextStyle(
                                    color: Color(0xFF474747),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Bitiş Tarihi
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bayrak ikonu daire
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.flag_outlined,
                                  color: Color(0xFF2B404F),
                                  size: 22,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Bitiş Tarihi metin
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bitiş Tarihi',
                                  style: const TextStyle(
                                    color: Color(0xFFBBBDC1),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 2,
                                  ),
                                ),
                                Text(
                                  widget.trip.endDate != null
                                      // String'i DateTime'a dönüştür (null kontrolü ile)
                                      ? DateHelpers.formatTurkishDate(
                                          DateTime.parse(widget.trip.endDate!))
                                      : 'Sefer Devam Ediyor',
                                  style: const TextStyle(
                                    color: Color(0xFF474747),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loads Title with Add Button to the right
            Positioned(
              left: 20,
              right: 20,
              top: 364, // Adjusted for the new larger card
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yükler',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                    ),
                  ),
                  Container(
                    width: 93,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0E2E3)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          // Yük ekle ekranını aç
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddLoadScreen(
                                tripId: widget.trip.id,
                              ),
                            ),
                          );

                          // Yeni yük eklendiyse state'i güncelle
                          if (result != null && mounted) {
                            setState(() {
                              // Eklenen yükü _additionalLoads listesine ekle
                              _additionalLoads.add(result as Load);
                            });
                          }
                        },
                        child: Center(
                          child: Text(
                            'Yük Ekle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF474747),
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loads List
            Positioned(
              left: 0,
              right: 0,
              top: 413, // Adjusted for the new larger card
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 493, // Adjusted for the new larger card
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  // Hem trip.loads hem de _additionalLoads'daki yükleri göster
                  // Eğer her ikisi de boşsa, demo yükleri göster
                  itemCount: _getItemCount(),
                  itemBuilder: (context, index) {
                    final load = _getLoadAtIndex(index);
                    return _buildLoadCard(load);
                  },
                ),
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

  // Yük kartı widget'ı - iyileştirilmiş tasarım
  Widget _buildLoadCard(Load load) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity, // Esnek genişlik
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFEAEAEA),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0D000000), // %5 saydamlık
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // İçeriğe göre boyutlandırma
          children: [
            // Ürün ismi ve fiyat - üst satır
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ürün ismi - Taşma kontrolü ekledik
                Expanded(
                  flex: 3,
                  child: Text(
                    load.name ?? 'Paletli Mermer Fayans',
                    style: const TextStyle(
                      color: Color(0xFF474747),
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                // Tutar - Taşma kontrolü ekledik
                Expanded(
                  flex: 1,
                  child: Text(
                    '${load.price?.toStringAsFixed(0) ?? '14.412'}₺',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF474747),
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Müşteri - Taşma kontrolü ekledik
            Text(
              load.customerName ?? 'Gediz Ekol Madencilik',
              style: const TextStyle(
                color: Color(0xFF898A8A),
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            
            const SizedBox(height: 4),

            // Konum satırı - Taşma kontrolü ekledik
            Row(
              children: [
                // Başlangıç lokasyonu ikonu
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFFBCBEC2),
                  size: 16,
                ),
                const SizedBox(width: 4),
                // Konum metni
                Expanded(
                  child: Text(
                    '${load.startLocation ?? 'Gediz, Kütahya'} > ${load.endLocation ?? 'Pozantı, Adana'}',
                    style: const TextStyle(
                      color: Color(0xFFBCBEC2),
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Yükleme noktası butonu - Daha modern görünüm
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E2E3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sayı dairesi
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06263E),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${load.loadPoint ?? 3}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Yükleme noktası metni
                  const Text(
                    'Yükleme Noktası',
                    style: TextStyle(
                      color: Color(0xFF474747),
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
