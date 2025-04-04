import 'package:flutter/material.dart';
import '../config/theme.dart';

class DashboardCard extends StatelessWidget {
  final int tripCount;
  final int driverCount;
  final int vehicleCount;
  final VoidCallback onCreateTrip;

  const DashboardCard({
    super.key,
    required this.tripCount,
    required this.driverCount,
    required this.vehicleCount,
    required this.onCreateTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // İstatistik kartları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sefer sayısı
              _buildStatCard('Sefer', tripCount.toString()),
              
              // Şoför sayısı
              _buildStatCard('Şoför', driverCount.toString()),
              
              // Araç sayısı
              _buildStatCard('Araç', vehicleCount.toString()),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              // Sefer oluştur butonu
              ElevatedButton(
                onPressed: onCreateTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.textDark,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.withAlpha(77)),
                  ),
                ),
                child: Text(
                  "Sefer Oluştur",
                  style: AppTheme.manropeSemiBold(15),
                ),
              ),
              
              const Spacer(),
              
              // İllüstrasyon
              Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return SizedBox(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.interRegular(12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.clashGroteskSemiBold(18),
          ),
        ],
      ),
    );
  }
}