import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onLogout;
  final String? profileImageUrl;
  final String? initials;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onLogout,
    this.profileImageUrl,
    this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profil fotoğrafı ve başlık
          Row(
            children: [
              // Profil fotoğrafı veya isim baş harfleri
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: profileImageUrl == null ? AppTheme.accent : null,
                  shape: BoxShape.circle,
                  image: profileImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(profileImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profileImageUrl == null
                    ? Center(
                        child: Text(
                          initials ?? '',
                          style: AppTheme.manropeBold(14, Colors.white),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Şirket adı
              Text(
                title,
                style: AppTheme.manropeSemiBold(20, const Color(0xFFDEDFE1)),
              ),
            ],
          ),

          // Çıkış yap butonu
          ElevatedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(
              "Çıkış Yap",
              style: AppTheme.manropeSemiBold(13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.accent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppTheme.accent),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
