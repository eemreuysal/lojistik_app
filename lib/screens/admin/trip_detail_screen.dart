import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../config/theme.dart';
import '../../models/load_model.dart'; // Doğru import yolu
import '../../models/trip_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trips_provider.dart';
import '../../utils/logger.dart';
import '../../utils/date_helpers.dart';
import '../../widgets/profile_image_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;
    // final statusIndex = _getStatusIndex(widget.trip.status ?? 'Devam Ediyor'); // Kullanılmayan değişken kaldırıldı

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Geri butonu
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Ekran başlığı
                    Text(
                      'Sefer Detayları',
                      style: AppTheme.manropeBold(18, Colors.white),
                    ),

                    // Profil
                    ProfileImageWidget(
                      imageUrl: currentUser?.profileImageUrl,
                      initials: currentUser?.initials,
                      companyName: currentUser?.companyName,
                      radius: 18.5,
                    ),
                  ],
                ),
              ),
            ),

            // Trip Details Card (Figma Benzeri)
            Positioned(
              left: 20,
              top: 107,
              child: Container(
                width: 395,
                height: 198,
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sefer Numarası',
                                style: TextStyle(
                                  color: const Color(0xFFBBBDC1),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                widget.trip.tripNumber,
                                style: TextStyle(
                                  color: const Color(0xFF474747),
                                  fontSize: 18,
                                  fontFamily: 'Clash Grotesk',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Araç',
                                style: TextStyle(
                                  color: const Color(0xFFBBBDC1),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                widget.trip.vehiclePlate ?? 'Atanmadı',
                                style: TextStyle(
                                  color: const Color(0xFF474747),
                                  fontSize: 18,
                                  fontFamily: 'Clash Grotesk',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Şöför',
                                style: TextStyle(
                                  color: const Color(0xFFBBBDC1),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                widget.trip.driverName ?? 'Atanmadı',
                                style: TextStyle(
                                  color: const Color(0xFF474747),
                                  fontSize: 18,
                                  fontFamily: 'Clash Grotesk',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Başlangıç Tarihi',
                                style: TextStyle(
                                  color: const Color(0xFFBBBDC1),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                // String'i DateTime'a dönüştür
                                DateHelpers.formatTurkishDate(
                                    DateTime.parse(widget.trip.startDate)),
                                style: TextStyle(
                                  color: const Color(0xFF474747),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Bitiş Tarihi',
                                style: TextStyle(
                                  color: const Color(0xFFBBBDC1),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                widget.trip.endDate != null
                                    // String'i DateTime'a dönüştür (null kontrolü ile)
                                    ? DateHelpers.formatTurkishDate(
                                        DateTime.parse(widget.trip.endDate!))
                                    : 'Sefer Devam Ediyor',
                                style: TextStyle(
                                  color: const Color(0xFF474747),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Loads Title
            Positioned(
              left: 20,
              top: 330,
              child: Text(
                'Yükler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Loads List
            Positioned(
              left: 13,
              top: 371,
              child: Container(
                width: MediaQuery.of(context).size.width - 26,
                height: 543,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  // Artık doğru 'loads' alanı kullanılıyor
                  itemCount: widget.trip.loads?.length ?? 0,
                  itemBuilder: (context, index) {
                    // Cast'ler kaldırıldı
                    final load = widget.trip.loads![index];
                    return _buildLoadCard(load);
                  },
                ),
              ),
            ),

            // Status Update Button (Admin için)
            if (currentUser?.isAdmin ?? false)
              Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _showStatusUpdateDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Sefer Durumunu Güncelle',
                          style: AppTheme.manropeSemiBold(16, Colors.white),
                        ),
                ),
              ),

            // Bottom Navigation
            Positioned(
              left: 15,
              bottom: 20,
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                height: 69,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF06263E),
                      const Color(0xFF10344F),
                      const Color(0xFF1E485C)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      // withOpacity yerine withAlpha kullanıldı
                      color: Colors.black.withAlpha(38), // 0.15 * 255 = ~38
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomNavItem(Icons.home, 'Ana Sayfa', false),
                    _bottomNavItem(Icons.attach_money, 'Giderler', false),
                    _bottomNavItem(Icons.local_shipping, 'Seferler', true),
                    _bottomNavItem(Icons.person, 'Hesabım', false),
                    _bottomNavItem(Icons.settings, 'Ayarlar', false),
                  ],
                ),
              ),
            ), // Eksik parantez eklendi
          ],
        ),
      ),
    );
  }

  // Yük kartı widget'ı
  Widget _buildLoadCard(Load load) {
    // Koşullu değerleri önceden hesapla
    final priceText = load.price != null ? '${load.price}₺' : '-';
    final companyText = load.company ?? 'Firma Belirtilmemiş';
    final locationText =
        '${load.startLocation ?? 'N/A'} > ${load.endLocation ?? 'N/A'}';
    final loadPointText = '${load.loadPoint ?? '-'}';
    final nameText = load.name ?? 'Tanımsız Yük';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEAEAEA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nameText, // Değişken kullan
                style: TextStyle(
                  color: const Color(0xFF474747),
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                priceText, // Değişken kullan
                style: TextStyle(
                  color: const Color(0xFF474747),
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            companyText, // Değişken kullan
            style: TextStyle(
              color: const Color(0xFF898A8A),
              fontSize: 15,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            locationText, // Değişken kullan
            style: TextStyle(
              color: const Color(0xFFBCBEC2),
              fontSize: 13,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    loadPointText, // Değişken kullan
                    style: TextStyle(
                      color: const Color(0xFF474747),
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Yükleme Noktası',
                style: TextStyle(
                  color: const Color(0xFF474747),
                  fontSize: 13,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Alt navigasyon öğesi widget'ı
  Widget _bottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.white : const Color(0xFFDDDDDD),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFFDDDDDD),
            fontSize: 11,
            fontFamily: 'Manrope',
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
