import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/drivers_provider.dart';

class AdminAddDriverScreen extends StatefulWidget {
  const AdminAddDriverScreen({super.key});

  @override
  State<AdminAddDriverScreen> createState() => _AdminAddDriverScreenState();
}

class _AdminAddDriverScreenState extends State<AdminAddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _saveDriver() async {
    if (_formKey.currentState!.validate()) {
      final driversProvider =
          Provider.of<DriversProvider>(context, listen: false);

      final driverData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone': _phoneController.text,
        'national_id': _nationalIdController.text,
        'is_active': true,
      };

      final success = await driversProvider.addDriver(driverData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şoför başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                driversProvider.error ?? 'Şoför eklenirken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final driversProvider = Provider.of<DriversProvider>(context);

    return Scaffold(
      body: Container(
        width: 430,
        height: 932,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Background gradient
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 430,
                height: 534,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, 0.00),
                    end: Alignment(1.00, 1.00),
                    colors: [
                      const Color(0xFF06263E),
                      const Color(0xFF10344F),
                      const Color(0xFF1E485C)
                    ],
                  ),
                ),
              ),
            ),

            // Light gray background
            Positioned(
              left: 0,
              top: 115,
              child: Container(
                width: 430,
                height: 822,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF8F8F8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),

            // White bottom bar
            Positioned(
              left: 0,
              top: 828,
              child: Container(
                width: 430,
                height: 104,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),

            // Title
            Positioned(
              left: 19,
              top: 67,
              child: Text(
                'Şoför Ekle',
                style: AppTheme.manropeBold(22, Colors.white),
              ),
            ),

            // Form ve form elemanları
            Positioned(
              left: 0,
              top: 115,
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: 430,
                  height: 700,
                  child: Stack(
                    children: [
                      // First name label
                      Positioned(
                        left: 19,
                        top: 14,
                        child: SizedBox(
                          width: 184.79,
                          child: Text(
                            'Adı',
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                        ),
                      ),

                      // First name field
                      Positioned(
                        left: 19,
                        top: 42,
                        child: Container(
                          width: 189.92,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ad alanı boş bırakılamaz';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Adı',
                              hintStyle: AppTheme.interMedium(
                                  14, Colors.grey.withAlpha(153)),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Last name label
                      Positioned(
                        left: 223,
                        top: 14,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            'Soyadı',
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                        ),
                      ),

                      // Last name field
                      Positioned(
                        left: 223,
                        top: 42,
                        child: Container(
                          width: 185,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Soyad alanı boş bırakılamaz';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Soyadı',
                              hintStyle: AppTheme.interMedium(
                                  14, Colors.grey.withAlpha(153)),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Phone label
                      Positioned(
                        left: 19,
                        top: 102,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            'Telefon Numarası',
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                        ),
                      ),

                      // Phone field
                      Positioned(
                        left: 19,
                        top: 130,
                        child: Container(
                          width: 384,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Telefon numarası boş bırakılamaz';
                              } else if (value.length < 10) {
                                return 'Geçerli bir telefon numarası girin';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Telefon Numarası',
                              hintStyle: AppTheme.interMedium(
                                  14, Colors.grey.withAlpha(153)),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // National ID label
                      Positioned(
                        left: 19,
                        top: 190,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            'TC Kimlik No',
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                        ),
                      ),

                      // National ID field
                      Positioned(
                        left: 19,
                        top: 218,
                        child: Container(
                          width: 384,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFDFE2E3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: _nationalIdController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              // TC Kimlik No opsiyonel
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.length != 11) {
                                return 'TC kimlik numarası 11 haneli olmalıdır';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'TC Kimlik No',
                              hintStyle: AppTheme.interMedium(
                                  14, Colors.grey.withAlpha(153)),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Alt butonlar (Vazgeç ve Kaydet)
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 430,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    // Vazgeç butonu
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                              color: AppTheme.textGrey.withAlpha(128)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Vazgeç',
                          style: AppTheme.manropeSemiBold(14),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Kaydet butonu
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            driversProvider.isLoading ? null : _saveDriver,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: driversProvider.isLoading
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
                                style:
                                    AppTheme.manropeSemiBold(14, Colors.white),
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
    );
  }
}
