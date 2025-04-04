import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../models/trip_model.dart';
import '../../widgets/custom_app_bar.dart';
import 'driver_trip_detail_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isLoading = true;
  List<Trip> _activeTrips = [];
  
  @override
  void initState() {
    super.initState();
    _loadTrips();
  }
  
  Future<void> _loadTrips() async {
    setState(() {
      _isLoading = true;
    });
    
    // Mock veri - normalde API'den gelebilir
    await Future.delayed(const Duration(seconds: 1));
    
    // Örnek aktif seferler
    _activeTrips = [
      Trip(
        id: 1,
        startDate: '2025-03-24',
        endDate: '2025-03-30',
        vehicleId: 1,
        driverId: 1,
        customerId: 1,
        status: 'Devam Ediyor',
        vehiclePlate: '34 ABC 123',
        driverName: 'Ahmet Yılmaz',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst Bar
              CustomAppBar(
                title: user?.companyName ?? "Şirket Adı",
                onLogout: () => authProvider.logout(),
                initials: user?.initials,
                profileImageUrl: user?.profileImageUrl,
              ),
              
              // İçerik Alanı
              Expanded(
                child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : RefreshIndicator(
                        onRefresh: _loadTrips,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: _activeTrips.isEmpty
                              ? _buildEmptyState(user)
                              : _buildActiveTrips(user),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.directions_car_filled,
          size: 80,
          color: AppTheme.primaryDark,
        ),
        const SizedBox(height: 24),
        Text(
          "Hoş Geldiniz, ${user?.fullName ?? 'Sürücü'}",
          style: AppTheme.manropeBold(24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "Şu anda aktif seferiniz bulunmuyor.",
          style: AppTheme.manropeRegular(16, AppTheme.textGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Güncel sefer bilgisi için yer tutucu
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.accent.withAlpha(128)),  // withOpacity(0.5) yerine withAlpha kullanıldı
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                "Aktif Sefer Bulunmuyor",
                style: AppTheme.manropeSemiBold(18),
              ),
              const SizedBox(height: 8),
              Text(
                "Yeni seferleriniz olduğunda burada görünecek.",
                style: AppTheme.manropeRegular(14, AppTheme.textGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildActiveTrips(user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hoşgeldin mesajı
          Text(
            "Hoş Geldiniz, ${user?.fullName ?? 'Sürücü'}",
            style: AppTheme.manropeBold(24),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            "Aktif Seferleriniz",
            style: AppTheme.manropeSemiBold(18, AppTheme.textGrey),
          ),
          
          const SizedBox(height: 16),
          
          // Aktif seferler listesi
          ...List.generate(_activeTrips.length, (index) {
            final trip = _activeTrips[index];
            return _buildTripCard(trip);
          }),
          
          const SizedBox(height: 24),
          
          // İstatistikler
          Text(
            "İstatistikler",
            style: AppTheme.manropeSemiBold(18, AppTheme.textGrey),
          ),
          
          const SizedBox(height: 16),
          
          // İstatistik kartları
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.local_shipping,
                  title: "Toplam Sefer",
                  value: "12",
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  title: "Tamamlanan",
                  value: "11",
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.speed,
                  title: "Toplam Km",
                  value: "3.578",
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time,
                  title: "Toplam Saat",
                  value: "145",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTripCard(Trip trip) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverTripDetailScreen(trip: trip),
          ),
        ).then((_) {
          // Sayfa geri döndüğünde seferleri yeniden yükle
          _loadTrips();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accent.withAlpha(128)),  // withOpacity(0.5) yerine withAlpha kullanıldı
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),  // withOpacity(0.05) yerine withAlpha kullanıldı
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      trip.tripNumber,
                      style: AppTheme.manropeSemiBold(16),
                    ),
                  ],
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.searchBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    trip.statusText,
                    style: AppTheme.manropeSemiBold(12, AppTheme.statusBlue),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Tarih ve araç bilgisi
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  "${trip.formattedStartDate} - ${trip.endDate != null ? DateFormat('dd.MM.yyyy').format(DateTime.parse(trip.endDate!)) : 'Belirtilmemiş'}",
                  style: AppTheme.manropeRegular(14, AppTheme.textGrey),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Araç bilgisi
            Row(
              children: [
                Icon(
                  Icons.directions_car,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  trip.vehiclePlate ?? 'Araç Yok',
                  style: AppTheme.manropeRegular(14, AppTheme.textGrey),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Düğmeler
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriverTripDetailScreen(trip: trip),
                        ),
                      ).then((_) {
                        // Sayfa geri döndüğünde seferleri yeniden yükle
                        _loadTrips();
                      });
                    },
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text("Detaylar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Durum güncelleme butonu
                OutlinedButton.icon(
                  onPressed: () {
                    _showStatusUpdateDialog(trip);
                  },
                  icon: const Icon(Icons.update, size: 16),
                  label: const Text("Durum Güncelle"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withAlpha(128)),  // withOpacity(0.5) yerine withAlpha kullanıldı
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),  // withOpacity(0.05) yerine withAlpha kullanıldı
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 24,
          ),
          
          const SizedBox(height: 12),
          
          Text(
            value,
            style: AppTheme.manropeBold(20),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            title,
            style: AppTheme.manropeRegular(12, AppTheme.textGrey),
          ),
        ],
      ),
    );
  }
  
  void _showStatusUpdateDialog(Trip trip) {
    // Durumlar listesi
    const List<String> statuses = [
      'Devam Ediyor',
      'Yükleme Başladı',
      'Yola Çıkıldı',
      'Teslimat Başladı',
      'Tamamlandı',
    ];
    
    String selectedStatus = trip.statusText;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Durum Güncelle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...statuses.map((status) => RadioListTile<String>(
                  title: Text(status),
                  value: status,
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                )),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  // Not: API'ye durum güncellemesi gönderilecek
                  Navigator.pop(context);
                  
                  // Başarılı bildirim göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Durum güncellendi'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  // Seferleri yeniden yükle
                  _loadTrips();
                },
                child: const Text('Güncelle'),
              ),
            ],
          );
        },
      ),
    );
  }
}