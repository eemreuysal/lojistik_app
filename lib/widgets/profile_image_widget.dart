import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/logger.dart';
import '../config/theme.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final String? companyName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final VoidCallback? onTap;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.initials,
    this.companyName,
    required this.radius,
    this.backgroundColor = const Color(0xFF0C2D41),
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    logger.i("ProfileImageWidget: imageUrl = ${imageUrl ?? "null"}");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        color: backgroundColor,
        child: imageUrl != null
            ? _buildProfileImage()
            : Center(
                child: Text(
                  initials ?? companyName?.substring(0, 1) ?? 'A',
                  style: AppTheme.manropeBold(fontSize, textColor),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileImage() {
    try {
      // Gelen URL'yi tamamen temizle ve analiz et
      String url = imageUrl!;
      
      // file:// öneklerini kaldır 
      if (url.startsWith('file://')) {
        url = url.substring(7);
      }
      
      // data:image base64 formatı için
      if (url.contains('data:image') && url.contains('base64')) {
        try {
          // Base64 kısmını ayıkla
          final dataStart = url.indexOf(',') + 1;
          if (dataStart > 1) { // Geçerli bir index ise
            final base64Data = url.substring(dataStart);
            if (base64Data.isNotEmpty) {
              try {
                final decodedImage = base64Decode(base64Data);
                return Image.memory(
                  decodedImage,
                  fit: BoxFit.cover,
                  width: radius * 2,
                  height: radius * 2,
                  errorBuilder: (context, error, stackTrace) {
                    logger.e("Base64 görüntü yükleme hatası: $error");
                    return _buildFallbackContent();
                  },
                );
              } catch (decodeError) {
                logger.e("Base64 decode hatası: $decodeError");
                return _buildFallbackContent();
              }
            }
          }
          logger.e("Geçersiz base64 formatı");
          return _buildFallbackContent();
        } catch (base64Error) {
          logger.e("Base64 işleme hatası: $base64Error");
          return _buildFallbackContent();
        }
      } 
      
      // Standart dosya yolu
      if (url.startsWith('/')) {
        try {
          return Image.file(
            File(url),
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
            errorBuilder: (context, error, stackTrace) {
              logger.e("Dosya yükleme hatası: $error");
              return _buildFallbackContent();
            },
          );
        } catch (fileError) {
          logger.e("Dosya açma hatası: $fileError");
          return _buildFallbackContent();
        }
      }

      // Diğer format - en iyi tahmin et
      logger.d("Tanımlanamayan fotoğraf formatı, varsayılan kullanılacak");
      return _buildFallbackContent();
        
    } catch (e) {
      logger.e("Profil fotoğrafı yükleme hatası: $e");
      return _buildFallbackContent();
    }
  }

  Widget _buildFallbackContent() {
    return Center(
      child: Text(
        initials ?? companyName?.substring(0, 1) ?? 'A',
        style: AppTheme.manropeBold(fontSize, textColor),
      ),
    );
  }
}
