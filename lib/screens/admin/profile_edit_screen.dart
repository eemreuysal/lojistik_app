// Add this header to help find the issue
// This file handles the profile edit screen

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/logger.dart';
import 'dart:convert'; // Import for base64

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 70,
      );
      logger.d("Seçilen fotoğraf: ${image?.path}"); // Debug log

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        logger.d(
            "Fotoğraf dosyası boyutu: ${_selectedImage?.lengthSync()} bytes");
      } else {
        logger.i("Fotoğraf seçilmedi");
      }
    } catch (e) {
      logger.e("Fotoğraf seçme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: 534,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.61, 0.50),
                end: Alignment(0.39, 1.11),
                colors: [
                  Color.fromRGBO(7, 38, 62, 1),
                  Color.fromRGBO(16, 52, 80, 1),
                  Color.fromRGBO(30, 72, 92, 1),
                ],
                stops: [0.004, 0.531, 1.0],
              ),
            ),
          ),

          // White curved background
          Positioned(
            top: 357,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 575,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),

          // Content
          Column(
            children: [
              // Top bar with back button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 64, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const Text(
                      'Profil Fotoğrafı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile photo section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Stack(
                    children: [
                      // Profile photo display
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0C2D41),
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1 * 255),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    logger.e(
                                        "Profil fotoğrafı yükleme hatası: $error");
                                    return Container(
                                        color: const Color(0xFF0C2D41));
                                  },
                                ),
                              )
                            : (user?.profileImageUrl != null
                                ? ClipOval(
                                    child: _buildProfileImage(
                                        user!.profileImageUrl!),
                                  )
                                : Center(
                                    child: Text(
                                      user?.initials ??
                                          user?.companyName?.substring(0, 1) ??
                                          'A',
                                      style: AppTheme.manropeBold(
                                          28, Colors.white),
                                    ),
                                  )),
                      ),

                      // Camera button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0C2D41),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.2 * 255),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Button section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE0E2E4),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'İptal',
                              style: AppTheme.manropeSemiBold(
                                  15, const Color(0xFF474747)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Save button
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectedImage != null
                            ? () {
                                authProvider
                                    .updateProfileImage(_selectedImage!);
                                Navigator.pop(context);
                              }
                            : null,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedImage != null
                                ? const Color(0xFF0C2D41)
                                : const Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Kaydet',
                                    style: AppTheme.manropeSemiBold(
                                        15, Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Profil resmi widget'ını oluşturur
  Widget _buildProfileImage(String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      try {
        // data:image/png;base64, kısmını ayıkla
        final dataStart = imageUrl.indexOf(',') + 1;
        final base64Data = imageUrl.substring(dataStart);
        final decodedImage = base64Decode(base64Data);

        return Image.memory(
          decodedImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            logger.e("Base64 görüntü yükleme hatası: $error");
            return Container(color: const Color(0xFF0C2D41));
          },
        );
      } catch (e) {
        logger.e("Base64 image decode hatası: $e");
        return Container(color: const Color(0xFF0C2D41));
      }
    } else {
      // Dosya yolu
      try {
        String path = imageUrl;
        if (path.startsWith('file://')) {
          path = path.substring(7);
        }

        return Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            logger.e("Dosya yükleme hatası: $error");
            return Container(color: const Color(0xFF0C2D41));
          },
        );
      } catch (e) {
        logger.e("Dosya okuma hatası: $e");
        return Container(color: const Color(0xFF0C2D41));
      }
    }
  }
}
