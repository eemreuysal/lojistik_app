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
        height: 534,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.00, 0.00),
            end: const Alignment(1.00, 1.00),
            colors: [
              const Color(0xFF06263E),
              const Color(0xFF10344F),
              const Color(0xFF1E485C)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım (Başlık)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Şoför Ekle",
                  style: AppTheme.manropeBold(22, Colors.white),
                ),
              ),

              // Form Alanı
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ad ve Soyad alanları yan yana
                          Row(
                            children: [
                              // Ad alanı
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ad",
                                      style: AppTheme.manropeRegular(
                                          14, Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        hintText: "Ad",
                                        hintStyle: AppTheme.interMedium(
                                            14, Colors.grey.withAlpha(153)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.grey.withAlpha(77)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ad alanı boş bırakılamaz';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Soyad alanı
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Soyad",
                                      style: AppTheme.manropeRegular(
                                          14, Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        hintText: "Soyad",
                                        hintStyle: AppTheme.interMedium(
                                            14, Colors.grey.withAlpha(153)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.grey.withAlpha(77)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Soyad alanı boş bırakılamaz';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Telefon numarası alanı
                          Text(
                            "Telefon Numarası",
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: "05XX XXX XX XX",
                              hintStyle: AppTheme.interMedium(
                                  14, Colors.grey.withAlpha(153)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.withAlpha(77)),
                              ),
                            ),
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
                          ),

                          const SizedBox(height: 24),

                          // TC Kimlik numarası alanı
                          Text(
                            "TC Kimlik Numarası",
                            style: AppTheme.manropeRegular(14, Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nationalIdController,
                            decoration: InputDecoration(
                              hintText: "TC Kimlik No",
                              hintStyle: AppTheme.interMedium(
                                  14, Colors.grey.withAlpha(153)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.withAlpha(77)),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'TC kimlik numarası boş bırakılamaz';
                              } else if (value.length != 11) {
                                return 'TC kimlik numarası 11 haneli olmalıdır';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Alt butonlar (Vazgeç ve Kaydet)
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
