import 'dart:io';
import 'dart:convert'; // Import for base64
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../utils/logger.dart';

class AdminAccountScreen extends StatelessWidget {
  const AdminAccountScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım (Başlık)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Hesabım",
                  style: AppTheme.manropeBold(22, Colors.white),
                ),
              ),

              // Profil Bilgileri
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),

                        // Profil fotoğrafı
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0C2D41),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.1 * 255),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: user?.profileImageUrl != null
                                  ? ClipOval(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: _getImageProvider(
                                            user!.profileImageUrl!),
                                        onBackgroundImageError:
                                            (exception, stackTrace) {
                                          logger.e(
                                              "Profil fotoğrafı yükleme hatası: $exception");
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        user?.initials ??
                                            user?.companyName
                                                ?.substring(0, 1) ??
                                            'A',
                                        style: AppTheme.manropeBold(
                                            24, Colors.white),
                                      ),
                                    ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Kullanıcı adı
                        Text(
                          user?.fullName ?? 'Kullanıcı Adı',
                          style: AppTheme.manropeBold(20),
                        ),

                        const SizedBox(height: 8),

                        // E-posta
                        Text(
                          user?.email ?? 'E-posta',
                          style: AppTheme.manropeRegular(16, AppTheme.textGrey),
                        ),

                        const SizedBox(height: 8),

                        // Şirket adı
                        Text(
                          user?.companyName ?? 'Şirket Adı',
                          style: AppTheme.manropeRegular(14, AppTheme.textGrey),
                        ),

                        const SizedBox(height: 40),

                        // Hesap bilgileri
                        _buildSectionHeader("Hesap Bilgileri"),

                        const SizedBox(height: 16),

                        _buildProfileItem(
                          icon: Icons.person,
                          title: "Profil Bilgileri",
                          onTap: () {
                            // Profil düzenleme sayfasına git
                          },
                        ),

                        _buildProfileItem(
                          icon: Icons.lock,
                          title: "Şifre Değiştir",
                          onTap: () {
                            // Şifre değiştirme sayfasına git
                          },
                        ),

                        _buildProfileItem(
                          icon: Icons.business,
                          title: "Şirket Bilgileri",
                          onTap: () {
                            // Şirket bilgileri sayfasına git
                          },
                        ),

                        const SizedBox(height: 24),

                        // Çıkış yap butonu
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Çıkış yapmak için onay iste
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Çıkış Yap"),
                                  content: const Text(
                                      "Çıkış yapmak istediğinize emin misiniz?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("İptal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        authProvider.logout();
                                      },
                                      child: const Text("Çıkış Yap"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text("Çıkış Yap"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Alt Navigasyon Barı
              const CustomBottomNavigationBar(currentIndex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTheme.manropeSemiBold(18),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
            Text(
              title,
              style: AppTheme.manropeRegular(16),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Base64 veya dosya yolu tabanlı fotoğraflar için uygun ImageProvider döndürür
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      // Base64 görüntüsü
      try {
        // data:image/png;base64, kısmını ayıkla
        final dataStart = imageUrl.indexOf(',') + 1;
        final base64Data = imageUrl.substring(dataStart);
        return MemoryImage(base64Decode(base64Data));
      } catch (e) {
        logger.e("Base64 image decode hatası: $e");
        return const AssetImage('assets/images/default_profile.png');
      }
    } else {
      // Dosya yolu
      try {
        return FileImage(File(imageUrl.replaceFirst('file://', '')));
      } catch (e) {
        logger.e("Dosya okuma hatası: $e");
        return const AssetImage('assets/images/default_profile.png');
      }
    }
  }
}
