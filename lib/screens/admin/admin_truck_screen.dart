import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/bottom_navigation_bar.dart';

class AdminTruckScreen extends StatelessWidget {
  const AdminTruckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seferler',
          style: AppTheme.manropeSemiBold(20, Colors.white),
        ),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Column(
          children: [
            // İçerik Alanı
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const Center(
                  child: Text('Seferler Sayfası Henüz Tamamlanmamıştır'),
                ),
              ),
            ),
            
            // Alt Navigasyon Barı
            const CustomBottomNavigationBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}