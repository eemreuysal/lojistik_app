import 'package:flutter/material.dart';
// import '../../config/theme.dart'; // Kullanılmayan import kaldırıldı

class LoadingPointAddScreen extends StatefulWidget {
  final int loadId;

  const LoadingPointAddScreen({
    super.key,
    required this.loadId,
  });

  @override
  State<LoadingPointAddScreen> createState() => _LoadingPointAddScreenState();
}

class _LoadingPointAddScreenState extends State<LoadingPointAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveLoadingPoint() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Create loading point object to return
        final loadingPoint = {
          'id': DateTime.now().millisecondsSinceEpoch,
          'location': _locationController.text,
          'name': _nameController.text,
          'address': _addressController.text,
          'description': _descriptionController.text,
        };

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yükleme noktası başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, loadingPoint);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              // Gradient Background
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF06263E),
                        const Color(0xFF10344F),
                        const Color(0xFF1E485C)
                      ],
                    ),
                  ),
                ),
              ),

              // Back button
              Positioned(
                left: 16,
                top: 16,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF06263E),
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),

              // Title
              Positioned(
                left: 20,
                top: 67,
                child: const Text(
                  'Yükleme Noktası Ekle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.09,
                  ),
                ),
              ),

              // Main Content - Light Grey Container
              Positioned(
                left: 0,
                top: 115,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8F8F8),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 19),

                          // Lokasyon (İl, İlçe)
                          _buildFieldLabel('Lokasyon (İl, İlçe)'),
                          _buildTextField(
                            controller: _locationController,
                            hintText: 'Gediz, Kütahya',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lokasyon bilgisi gereklidir';
                              }
                              return null;
                            },
                          ),

                          // Tesis/Şirket Adı
                          _buildFieldLabel('Tesis/Şirket Adı'),
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Gediz Ekol Madencilik Ana Sahası',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tesis/Şirket adı gereklidir';
                              }
                              return null;
                            },
                          ),

                          // Tam Adres
                          _buildFieldLabel('Tam Adres'),
                          _buildTextField(
                            controller: _addressController,
                            hintText: 'Adres giriniz...',
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Adres bilgisi gereklidir';
                              }
                              return null;
                            },
                          ),

                          // Açıklama
                          _buildFieldLabel('Açıklama (İsteğe Bağlı)'),
                          _buildTextField(
                            controller: _descriptionController,
                            hintText: 'Açıklama giriniz...',
                            maxLines: 3,
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Bar
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  height: 104,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withValues(red: 0, green: 0, blue: 0, opacity: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Vazgeç Butonu
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Vazgeç',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF474747),
                            fontSize: 18,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                      ),

                      // Kaydet Butonu
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveLoadingPoint,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF06263E),
                          minimumSize: const Size(180, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Kaydet',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.33,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Alan etiketi widgetı
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF878787),
          fontSize: 15,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 1.60,
        ),
      ),
    );
  }

  // Text field widgetı
  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFDFE2E3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(
          color: Color(0xFF474747),
          fontSize: 18,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFC1C1C2),
            fontSize: 18,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
