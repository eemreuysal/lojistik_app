import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/trip_model.dart';

class TripListItem extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripListItem({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withAlpha(51)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon ve Sefer Numarası kısmı
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aktif sefer ikonu
                  if (trip.isActive)
                    Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: Icon(
                        Icons.local_shipping,
                        size: 18,
                        color: Colors.blue.shade300,
                      ),
                    ),
                  
                  // Sefer Numarası ve Tarih
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.tripNumber,
                        style: AppTheme.manropeBold(18, const Color(0xFF474747)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${trip.formattedStartDate} • ${DateFormat('HH:mm').format(trip.createdAt)}',
                        style: AppTheme.manropeSemiBold(13, AppTheme.textLightGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Araç ve Şoför bilgisi
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Durum etiketi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.searchBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trip.statusText,
                      style: AppTheme.manropeSemiBold(11, AppTheme.statusBlue),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Plaka
                  if (trip.vehiclePlate != null)
                    Text(
                      trip.vehiclePlate!,
                      style: AppTheme.manropeSemiBold(13, AppTheme.textGrey),
                      textAlign: TextAlign.right,
                    ),
                  
                  // Şoför adı
                  if (trip.driverName != null)
                    Text(
                      trip.driverName!,
                      style: AppTheme.manropeSemiBold(13, AppTheme.textGrey),
                      textAlign: TextAlign.right,
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