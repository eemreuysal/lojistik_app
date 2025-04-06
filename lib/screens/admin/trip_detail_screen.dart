import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/trip_model.dart';
import '../../providers/trips_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile_image_widget.dart';
import '../../utils/logger.dart';
import '../../utils/date_helpers.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;
  
  const TripDetailScreen({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Türkçe tarih formatı için dil desteğini başlat
    initializeDateFormatting('tr_TR', null);
    
    logger.d("Sefer detay ekranı açıldı: ${widget.trip.tripNumber}");
  }
  
  // Tarihleri Türkçe formatta göster - DateHelpers ile güncellendi
  String formatTurkishDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Belirlenmedi';
    }
    
    final date = DateHelpers.parseDate(dateStr);
    if (date != null) {
      return DateHelpers.formatTurkishDate(date);
    } else {
      logger.d("Tarih ayrıştırılamadı: $dateStr");
      return dateStr; // Tarih ayrıştırılamazsa orijinal değeri döndür
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                height: 250, // Daha kısa gradient
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
              ),
            ),

            // Main content (card style)
            SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                          'Sefer Detayı',
                          style: AppTheme.manropeBold(18, Colors.white),
                        ),
                        
                        // Profil
                        GestureDetector(
                          onTap: () {
                            // Profil sayfasına git
                          },
                          child: ProfileImageWidget(
                            imageUrl: currentUser?.profileImageUrl,
                            initials: currentUser?.initials,
                            companyName: currentUser?.companyName,
                            radius: 18.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sefer başlık kartı
                            _buildTripHeaderCard(),
                            
                            const SizedBox(height: 20),
                            
                            // Sürücü ve araç bilgileri
                            _buildDriverVehicleCard(),
                            
                            const SizedBox(height: 20),
                            
                            // İlerleme durumu
                            _buildTimelineProgress(),
                            
                            const SizedBox(height: 20),
                            
                            // Durum güncelleme butonu (admin için)
                            if (currentUser?.isAdmin ?? false)
                              _buildStatusUpdateButton(),
                          ],
                        ),
                      ),
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
  
  // Sefer başlık kartı
  Widget _buildTripHeaderCard() {
    final isActive = widget.trip.isActive;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sefer numarası ve durumu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.trip.tripNumber,
                    style: AppTheme.manropeBold(24),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    isActive ? Icons.local_shipping : Icons.done_all,
                    color: isActive ? AppTheme.primary : Colors.green,
                    size: 24,
                  ),
                ],
              ),
              
              // Durum etiketi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFD3F0FF) : const Color(0xFFDBFFDF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Devam Ediyor' : 'Tamamlandı',
                  style: AppTheme.manropeBold(
                    12,
                    isActive ? const Color(0xFF2D4856) : const Color(0xFF5D8765),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Tarih bilgileri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Başlangıç tarihi
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Başlangıç Tarihi',
                    style: AppTheme.manropeRegular(13, Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTurkishDate(widget.trip.startDate),
                    style: AppTheme.manropeSemiBold(15),
                  ),
                ],
              ),
              
              // Ok ikonu
              Icon(
                Icons.arrow_forward,
                color: Colors.grey.shade400,
              ),
              
              // Bitiş tarihi
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Bitiş Tarihi',
                    style: AppTheme.manropeRegular(13, Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTurkishDate(widget.trip.endDate),
                    style: AppTheme.manropeSemiBold(15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Sürücü ve araç bilgileri kartı
  Widget _buildDriverVehicleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            'Araç ve Sürücü Bilgileri',
            style: AppTheme.manropeBold(16),
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Sürücü bilgileri
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(77), 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sürücü',
                    style: AppTheme.manropeRegular(13, Colors.grey),
                  ),
                  Text(
                    widget.trip.driverName ?? 'Atanmadı',
                    style: AppTheme.manropeSemiBold(15),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Araç bilgileri
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(77),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions_truck,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Araç',
                    style: AppTheme.manropeRegular(13, Colors.grey),
                  ),
                  Text(
                    widget.trip.vehiclePlate ?? 'Atanmadı',
                    style: AppTheme.manropeSemiBold(15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Sefer ilerleme durumu (timeline)
  Widget _buildTimelineProgress() {
    final isActive = widget.trip.isActive;
    final status = widget.trip.status ?? 'Devam Ediyor';
    
    // Durum sırasını belirleyelim
    final statusIndex = _getStatusIndex(status);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sefer Durumu',
            style: AppTheme.manropeBold(16),
          ),
          
          const SizedBox(height: 20),
          
          // Timeline - Gerçek seferin state'ine göre durum gösterimi
          _timelineItem(
            'Sefer Başladı',
            formatTurkishDate(widget.trip.startDate),
            true, // Her zaman tamamlanmış
            false,
          ),
          _timelineConnector(true),
          
          _timelineItem(
            'Yükleme Tamamlandı',
            statusIndex >= 1 ? _getStatusDate(1) : 'Bekliyor',
            statusIndex >= 1,
            statusIndex == 1,
          ),
          _timelineConnector(statusIndex >= 1),
          
          _timelineItem(
            'Yolda',
            statusIndex >= 2 ? _getStatusDate(2) : 'Bekliyor',
            statusIndex >= 2,
            statusIndex == 2,
          ),
          _timelineConnector(statusIndex >= 2),
          
          _timelineItem(
            'Teslimata Yakın',
            statusIndex >= 3 ? _getStatusDate(3) : 'Bekliyor',
            statusIndex >= 3,
            statusIndex == 3,
          ),
          _timelineConnector(statusIndex >= 3),
          
          _timelineItem(
            'Teslim Edildi',
            statusIndex >= 4 ? formatTurkishDate(widget.trip.endDate) : 'Bekliyor',
            statusIndex >= 4,
            statusIndex == 4,
          ),
        ],
      ),
    );
  }
  
  // Durumun indeksini belirle (timeline için)
  int _getStatusIndex(String status) {
    switch (status) {
      case 'Yükleme Yapılıyor':
        return 1;
      case 'Yolda':
        return 2;
      case 'Teslimata Yakın':
        return 3;
      case 'Tamamlandı':
        return 4;
      default:
        return 0; // Bilinmeyen durum
    }
  }
  
  // Durum tarihi
  String _getStatusDate(int statusIndex) {
    // Gerçek uygulamada, bu tarihler veritabanından gelecektir
    
    // Bugünün tarihi
    final now = DateTime.now();
    
    // Başlangıç tarihini güvenli bir şekilde ayrıştır
    final startDate = DateHelpers.parseDate(widget.trip.startDate) ?? now;
    
    // Duruma göre tarih
    switch (statusIndex) {
      case 1: // Yükleme tamamlandı - başlangıçtan 1 gün sonra
        return DateHelpers.formatTurkishDate(startDate.add(const Duration(days: 1)));
      case 2: // Yolda - başlangıçtan 2 gün sonra
        return DateHelpers.formatTurkishDate(startDate.add(const Duration(days: 2)));
      case 3: // Teslimata yakın - başlangıçtan 3 gün sonra
        return DateHelpers.formatTurkishDate(startDate.add(const Duration(days: 3)));
      case 4: // Teslim edildi - bitiş tarihi
        final endDate = DateHelpers.parseDate(widget.trip.endDate);
        return endDate != null 
            ? DateHelpers.formatTurkishDate(endDate)
            : 'Belirlenmedi';
      default:
        return 'Bekliyor';
    }
  }
  
  // Timeline öğesi
  Widget _timelineItem(String title, String date, bool isCompleted, bool isActive) {
    return Row(
      children: [
        // İkon
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isCompleted 
                ? AppTheme.primary 
                : (isActive ? AppTheme.accent : Colors.grey.shade200),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: isCompleted 
                ? Colors.white 
                : (isActive ? AppTheme.primary : Colors.grey),
            size: isCompleted ? 16 : 10,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Bilgiler
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.manropeSemiBold(
                  14,
                  isCompleted 
                      ? AppTheme.textDark 
                      : (isActive ? AppTheme.primary : Colors.grey),
                ),
              ),
              Text(
                date,
                style: AppTheme.manropeRegular(
                  12,
                  isCompleted 
                      ? Colors.grey 
                      : (isActive ? AppTheme.primary.withAlpha(179) : Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Timeline bağlayıcı çizgi
  Widget _timelineConnector(bool isActive) {
    return Container(
      width: 2,
      height: 30,
      margin: const EdgeInsets.only(left: 14),
      color: isActive ? AppTheme.primary : Colors.grey.shade200,
    );
  }
  
  // Durum güncelleme butonu
  Widget _buildStatusUpdateButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isLoading 
            ? null 
            : () => _showStatusUpdateDialog(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryDark,
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
    );
  }
  
  // Durum güncelleme diyaloğu
  void _showStatusUpdateDialog() {
    final statuses = [
      'Yükleme Yapılıyor',
      'Yolda',
      'Teslimata Yakın',
      'Tamamlandı',
    ];
    
    String currentStatus = widget.trip.status ?? 'Devam Ediyor';
    
    logger.d("Durum güncelleme diyaloğu açılıyor. Mevcut durum: $currentStatus");
    
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
                
                // Durum seçenekleri
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
  
  // Sefer durumunu güncelleme
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
        
        // Sefer listesi ekranına geri dön
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
}
