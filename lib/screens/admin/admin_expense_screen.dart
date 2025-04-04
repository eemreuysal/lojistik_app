import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/bottom_navigation_bar.dart';

class AdminExpenseScreen extends StatelessWidget {
  const AdminExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım (Başlık)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Giderler",
                  style: AppTheme.manropeBold(22, Colors.white),
                ),
              ),
              
              // İçerik Alanı
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 80,
                          color: AppTheme.primaryDark.withAlpha(77),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Giderler Sayfası Hazırlanıyor",
                          style: AppTheme.manropeSemiBold(18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Bu özellik yakında kullanıma sunulacak.",
                          style: AppTheme.manropeRegular(14, AppTheme.textGrey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Alt Navigasyon Barı
              const CustomBottomNavigationBar(currentIndex: 1),
            ],
          ),
        ),
      ),
    );
  }
}