import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/trip_model.dart';

class DriverTripDetailScreen extends StatefulWidget {
  final Trip trip;
  
  const DriverTripDetailScreen({
    super.key,
    required this.trip,
  });

  @override
  State<DriverTripDetailScreen> createState() => _DriverTripDetailScreenState();
}

class _DriverTripDetailScreenState extends State<DriverTripDetailScreen> {
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sefer Detayı',
          style: AppTheme.manropeSemiBold(20, Colors.white),
        ),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: Column(
                children: [
                  // Üst kısımdaki sefer özeti
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Sefer numarası
                        Text(
                          widget.trip.tripNumber,
                          style: AppTheme.manropeBold(24, Colors.white),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Sefer durumu
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),  // withOpacity(0.2) yerine withAlpha kullanıldı
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.trip.statusText,
                            style: AppTheme.manropeSemiBold(14, Colors.white),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Araç bilgisi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_shipping,  // directions_truck yerine local_shipping kullanıldı
                              color: Colors.white.withAlpha(179),  // withOpacity(0.7) yerine withAlpha kullanıldı
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.trip.vehiclePlate ?? 'Araç Yok',
                              style: AppTheme.manropeRegular(14, Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Alt kısımdaki detay bilgiler
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Detay Bilgiler başlığı
                            Text(
                              "Sefer Bilgileri",
                              style: AppTheme.manropeBold(18),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Tarih bilgileri
                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              title: "Başlangıç Tarihi",
                              value: widget.trip.formattedStartDate,
                            ),
                            
                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              title: "Bitiş Tarihi",
                              value: widget.trip.endDate != null
                                  ? DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.trip.endDate!))
                                  : 'Belirtilmemiş',
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Kargo bilgileri başlığı
                            Text(
                              "Kargo Bilgileri",
                              style: AppTheme.manropeBold(18),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Kargo bilgileri
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withAlpha(51)),  // withOpacity(0.2) yerine withAlpha kullanıldı
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Seramik",
                                    style: AppTheme.manropeSemiBold(16),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Kargo detayları
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildKargoInfo("Miktar", "5000"),
                                      _buildKargoInfo("Birim", "kg"),
                                      _buildKargoInfo("Toplam", "₺500.000"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Konum bilgileri başlığı
                            Text(
                              "Konum Bilgileri",
                              style: AppTheme.manropeBold(18),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Konum bilgileri
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withAlpha(51)),  // withOpacity(0.2) yerine withAlpha kullanıldı
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Yükleme konumu
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.green.withAlpha(26),  // withOpacity(0.1) yerine withAlpha kullanıldı
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add_location,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 12),
                                      
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Yükleme Noktası",
                                              style: AppTheme.manropeSemiBold(14),
                                            ),
                                            
                                            const SizedBox(height: 4),
                                            
                                            Text(
                                              "Uşak Seramik",
                                              style: AppTheme.manropeSemiBold(14, AppTheme.textDark),
                                            ),
                                            
                                            const SizedBox(height: 2),
                                            
                                            Text(
                                              "Uşak/Banaz Organize Sanayi",
                                              style: AppTheme.manropeRegular(12, Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Teslimat konumu
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withAlpha(26),  // withOpacity(0.1) yerine withAlpha kullanıldı
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 12),
                                      
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Teslimat Noktası",
                                              style: AppTheme.manropeSemiBold(14),
                                            ),
                                            
                                            const SizedBox(height: 4),
                                            
                                            Text(
                                              "İstanbul Depo",
                                              style: AppTheme.manropeSemiBold(14, AppTheme.textDark),
                                            ),
                                            
                                            const SizedBox(height: 2),
                                            
                                            Text(
                                              "İstanbul/Tuzla Organize Sanayi",
                                              style: AppTheme.manropeRegular(12, Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Durum güncelleme butonları
                            Text(
                              "Sefer Durumu Güncelleme",
                              style: AppTheme.manropeBold(18),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Durum güncelleme kartı
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withAlpha(51)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mevcut Durum: ${widget.trip.statusText}",
                                    style: AppTheme.manropeSemiBold(16),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Durum güncelleme butonları
                                  Row(
                                    children: [
                                      // Yüklemeye Başla butonu
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _updateTripStatus("Yükleme Başladı");
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "Yüklemeye Başla",
                                            style: AppTheme.manropeSemiBold(12, Colors.white),
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 8),
                                      
                                      // Yola Çık butonu
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _updateTripStatus("Yola Çıkıldı");
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "Yola Çık",
                                            style: AppTheme.manropeSemiBold(12, Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Durum güncelleme butonları
                                  Row(
                                    children: [
                                      // Teslimat Başladı butonu
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _updateTripStatus("Teslimat Başladı");
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "Teslimat Başladı",
                                            style: AppTheme.manropeSemiBold(12, Colors.white),
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 8),
                                      
                                      // Tamamlandı butonu
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _updateTripStatus("Tamamlandı");
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "Tamamlandı",
                                            style: AppTheme.manropeSemiBold(12, Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),  // withOpacity(0.1) yerine withAlpha kullanıldı
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 18,
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.manropeRegular(12, Colors.grey),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  value,
                  style: AppTheme.manropeSemiBold(14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildKargoInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.manropeRegular(12, Colors.grey),
        ),
        
        const SizedBox(height: 4),
        
        Text(
          value,
          style: AppTheme.manropeSemiBold(14),
        ),
      ],
    );
  }
  
  void _updateTripStatus(String status) {
    // Önemli: BuildContext asenkron boşluklar arasında güvenli olmadığı için 
    // API isteği tamamlandıktan sonra mounted kontrolü yapılmalı
    
    setState(() {
      _isLoading = true;
    });
    
    // Not: API'ye durum güncellemesi gönderilecek
    // Mock durum güncellemesi - normalde API'ye gönderilecek
    Future.delayed(const Duration(seconds: 1), () {
      // Widget ağaçtan çıkarılmışsa (örneğin sayfa değiştirilmişse)
      // setState çağrılmamallama
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      // Başarılı bildirim göster - mounted kontrolden sonra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Durum "$status" olarak güncellendi'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Bir önceki sayfaya dön
      Navigator.pop(context);
    });
  }
}