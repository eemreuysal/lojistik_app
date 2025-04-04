import 'package:flutter/material.dart';
import '../config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo alanı (ileride gerçek logo eklenebilir)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "LOJI",
                    style: AppTheme.manropeBold(32, AppTheme.primaryDark),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Yükleniyor göstergesi
              const CircularProgressIndicator(
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                "Yükleniyor...",
                style: AppTheme.manropeSemiBold(16, Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}