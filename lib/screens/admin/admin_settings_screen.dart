import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/bottom_navigation_bar.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  
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
                  "Ayarlar",
                  style: AppTheme.manropeBold(22, Colors.white),
                ),
              ),
              
              // Ayarlar Listesi
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Uygulama Ayarları
                        _buildSectionHeader("Uygulama Ayarları"),
                        
                        const SizedBox(height: 16),
                        
                        // Bildirimler
                        _buildSettingItem(
                          icon: Icons.notifications,
                          title: "Bildirimler",
                          trailing: Switch(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                            activeColor: AppTheme.primary,
                          ),
                        ),
                        
                        // Karanlık Mod
                        _buildSettingItem(
                          icon: Icons.dark_mode,
                          title: "Karanlık Mod",
                          trailing: Switch(
                            value: _darkModeEnabled,
                            onChanged: (value) {
                              setState(() {
                                _darkModeEnabled = value;
                              });
                            },
                            activeColor: AppTheme.primary,
                          ),
                        ),
                        
                        // Dil Seçimi
                        _buildSettingItem(
                          icon: Icons.language,
                          title: "Dil",
                          subtitle: "Türkçe",
                          onTap: () {
                            // Dil seçimi için dialog göster
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Hesap Ayarları
                        _buildSectionHeader("Hesap ve Güvenlik"),
                        
                        const SizedBox(height: 16),
                        
                        // Şifre Değiştir
                        _buildSettingItem(
                          icon: Icons.lock,
                          title: "Şifre Değiştir",
                          onTap: () {
                            // Şifre değiştirme sayfasına git
                          },
                        ),
                        
                        // Güvenlik
                        _buildSettingItem(
                          icon: Icons.security,
                          title: "Güvenlik",
                          onTap: () {
                            // Güvenlik ayarları sayfasına git
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Hakkında
                        _buildSectionHeader("Hakkında"),
                        
                        const SizedBox(height: 16),
                        
                        // Uygulama Versiyonu
                        _buildSettingItem(
                          icon: Icons.info,
                          title: "Uygulama Versiyonu",
                          subtitle: "1.0.0",
                        ),
                        
                        // Gizlilik Politikası
                        _buildSettingItem(
                          icon: Icons.privacy_tip,
                          title: "Gizlilik Politikası",
                          onTap: () {
                            // Gizlilik politikası sayfasına git
                          },
                        ),
                        
                        // Kullanım Şartları
                        _buildSettingItem(
                          icon: Icons.description,
                          title: "Kullanım Şartları",
                          onTap: () {
                            // Kullanım şartları sayfasına git
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Alt Navigasyon Barı
              const CustomBottomNavigationBar(currentIndex: 4),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.manropeSemiBold(18),
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withAlpha(51),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.manropeRegular(16),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTheme.manropeRegular(14, AppTheme.textGrey),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      )
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}